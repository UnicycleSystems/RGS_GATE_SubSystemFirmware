#include "../header/soc_voltage.h"
#include "../header/EEpromBlockLabels.h"
#include "../header/MemoryMap.h"

/* ---- The curve ----
 *
 * Pack millivolts against indicated percent, voltage DESCENDING. Every point
 * is measured - voltage against the integrated discharge current of a unit in
 * normal service. See the header for the log it came from and for why the
 * integral, rather than elapsed time, is what the percentages count.
 *
 * Percentages are stored x10 so the table keeps the resolution the rescale to
 * a 13500 mV zero produced, without resorting to floats. Steps are an even 5%
 * and the VOLTAGE spacing is what varies - 303 mV across the top step, 86 mV
 * across the flattest - so the table records the shape of the curve and the
 * lookup follows it for free.
 */
typedef struct
{
    uint16_t mv;
    uint16_t pct_x10;
} socv_point_t;

static const socv_point_t socv_curve[] =
{
    { 16402, 1000 },   /* charger just removed; 311 mA */
    { 16099,  950 },   /* steep: surface charge coming off */
    { 16007,  900 },
    { 15921,  850 },
    { 15786,  800 },
    { 15621,  750 },
    { 15459,  700 },
    { 15303,  650 },
    { 15151,  600 },
    { 14979,  550 },
    { 14819,  500 },
    { 14663,  450 },
    { 14515,  400 },
    { 14386,  350 },
    { 14266,  300 },
    { 14175,  250 },   /* flattest region */
    { 14075,  200 },
    { 13953,  150 },
    { 13795,  100 },   /* SOCV_WARN_PCT lands here */
    { 13629,   50 },   /* SOCV_CRITICAL_PCT lands here */
    { 13500,    0 },   /* indicator sticks at 1% below this */
};

#define SOCV_POINTS  (sizeof(socv_curve) / sizeof(socv_curve[0]))

/* ---- State ---- */

static uint8_t  socv_pct;
static uint16_t socv_warnings;
static bool     socv_shutdown;

/* Debounce counters: a trigger arms only after SOCV_DEBOUNCE_COUNT
 * consecutive qualifying readings, and disarms only once the pack has
 * recovered past the threshold plus hysteresis. */
static uint8_t  socv_cnt_shutdown_mv;
static uint8_t  socv_cnt_warn_pct;
static uint8_t  socv_cnt_crit_pct;
static uint8_t  socv_cnt_imminent_pct;

/* The thresholds have to nest, or a lower warning could assert without the
 * higher one and the Jetson would see "about ten minutes left" without ever
 * having seen "critical". Caught here rather than in review. */
#if (SOCV_IMMINENT_PCT > SOCV_CRITICAL_PCT) || (SOCV_CRITICAL_PCT > SOCV_WARN_PCT)
#error "SOC thresholds must nest: IMMINENT <= CRITICAL <= WARN"
#endif
#if (SOCV_IMMINENT_PCT < SOCV_MIN_REPORTED_PCT)
#error "SOCV_IMMINENT_PCT below the reported floor would never assert"
#endif

/* Debugger aids - the published byte is coarse and clamped at 1%. */
volatile uint16_t socv_dbg_mv;
volatile uint16_t socv_dbg_pct_x10;


/* Linear interpolation along the curve. Voltage descending, so walk until the
 * reading is above the next point. */
static uint16_t socv_lookup_x10(uint16_t mv)
{
    uint8_t i;

    if (mv >= socv_curve[0].mv)
        return socv_curve[0].pct_x10;

    for (i = 1u; i < SOCV_POINTS; i++)
    {
        if (mv >= socv_curve[i].mv)
        {
            const socv_point_t *hi = &socv_curve[i - 1u];
            const socv_point_t *lo = &socv_curve[i];
            uint16_t span_mv  = (uint16_t)(hi->mv - lo->mv);
            uint16_t span_pct = (uint16_t)(hi->pct_x10 - lo->pct_x10);
            uint16_t into     = (uint16_t)(mv - lo->mv);

            /* span_pct is 50 throughout and into <= span_mv <= 303, so the
             * product peaks near 15150 - inside uint16, let alone uint32.
             * The cast is kept so the table can be re-spaced without the
             * arithmetic quietly overflowing. */
            return (uint16_t)(lo->pct_x10 +
                   (uint16_t)(((uint32_t)into * span_pct) / span_mv));
        }
    }
    return 0u;                      /* below the bottom of the curve */
}


/* Arm after N consecutive qualifying readings; disarm only once the
 * condition has cleared outright. Returns the armed state. */
static bool socv_debounce(uint8_t *count, bool qualifying, bool armed)
{
    if (qualifying)
    {
        if (*count < SOCV_DEBOUNCE_COUNT)
            (*count)++;
        if (*count >= SOCV_DEBOUNCE_COUNT)
            return true;
        return armed;               /* still counting - hold current state */
    }

    *count = 0u;
    return false;
}


void SOCV_Init(void)
{
    socv_pct = SOCV_MIN_REPORTED_PCT;
    socv_warnings = 0u;
    socv_shutdown = false;
    socv_cnt_shutdown_mv = 0u;
    socv_cnt_warn_pct = 0u;
    socv_cnt_crit_pct = 0u;
    socv_cnt_imminent_pct = 0u;
    socv_dbg_mv = 0u;
    socv_dbg_pct_x10 = 0u;
}


void SOCV_Update(uint16_t pack_mV, int16_t current_mA)
{
    uint16_t pct_x10;
    uint8_t  pct;
    bool     shut_mv, warn_pct, crit_pct, imm_pct;

    (void)current_mA;       /* reserved for load compensation - see header */

    socv_dbg_mv = pack_mV;

    pct_x10 = socv_lookup_x10(pack_mV);
    socv_dbg_pct_x10 = pct_x10;

    pct = (uint8_t)(pct_x10 / 10u);
    if (pct < SOCV_MIN_REPORTED_PCT)
        pct = SOCV_MIN_REPORTED_PCT;    /* never report 0 on a running unit */
    if (pct > 100u)
        pct = 100u;
    socv_pct = pct;
    EMULATE_EEPROM_Memory[RemainingChargeAddr] = pct;

    /* ---- Triggers ----
     *
     * Three warnings on indicated percentage, and one absolute voltage that
     * forces the power-down. They nest: at 1% all three percentage warnings
     * are asserted, so the Jetson is told "low", then "critical", then "about
     * ten minutes left", each as an addition rather than a replacement.
     *
     * The 1% trigger is the indicator's floor, and that is the point of it -
     * the lookup has bottomed out and the percentage can say nothing more, so
     * the remaining notice has to be carried by a bit instead. It covers
     * 13551 mV down to the 13300 mV stop - 15 minutes when replayed against
     * the logged discharge, against the sixty seconds PowerOff_1_min allows.
     *
     * There is no separate critical VOLTAGE: with the curve's zero at 13500 mV
     * and the stop at 13300 mV, a voltage critical would sit inside that
     * 200 mV gap and fire within a couple of minutes of the shutdown itself,
     * telling nobody anything these have not already said.
     *
     * Hysteresis is applied to the CLEARING side only: a trigger arms at the
     * threshold and clears at threshold + hysteresis, so a pack sitting on
     * the boundary does not chatter. The asymmetry is deliberate - arming
     * must be prompt, clearing must be convincing. */
    shut_mv = (pack_mV < SOCV_SHUTDOWN_MV);
    if (socv_shutdown && pack_mV < (uint16_t)(SOCV_SHUTDOWN_MV + SOCV_HYSTERESIS_MV))
        shut_mv = true;             /* stay armed until it genuinely recovers */

    warn_pct = (pct <= SOCV_WARN_PCT);
    crit_pct = (pct <= SOCV_CRITICAL_PCT);
    imm_pct  = (pct <= SOCV_IMMINENT_PCT);

    socv_shutdown = socv_debounce(&socv_cnt_shutdown_mv, shut_mv, socv_shutdown);

    socv_warnings = 0u;
    if (socv_debounce(&socv_cnt_warn_pct, warn_pct, false))
        socv_warnings |= LowBatteryWarning;
    if (socv_debounce(&socv_cnt_crit_pct, crit_pct, false))
        socv_warnings |= LowBatteryCritical;
    if (socv_debounce(&socv_cnt_imminent_pct, imm_pct, false))
        socv_warnings |= PowerOff_10_min;
    if (socv_shutdown)
        socv_warnings |= PowerOff_1_min;
}


uint8_t SOCV_Percent(void)
{
    return socv_pct;
}


uint16_t SOCV_Warnings(void)
{
    return socv_warnings;
}


bool SOCV_ShutdownRequired(void)
{
    return socv_shutdown;
}
