#include "../header/soc_estimator.h"
#include "../header/EEpromBlockLabels.h"
#include "../header/MemoryMap.h"

/* ---- Configuration ---- */

/* MEASURED usable capacity, not the design figure.
 *
 * 1980 mAh, from the cycle 1 bench discharge: 4.14 V/cell down to 3.05 V/cell,
 * confirmed two independent ways - integrating the measured current by hand,
 * and the gauge's own Avg I Last Run of -582 mA over a 3.4 hour run.
 *
 * Deliberately NOT the 2400 mAh that bq_golden[] writes as Design Capacity.
 * That is the cell's rated figure and the right number for the gauge, which
 * reports state of health against it. This estimator is answering a different
 * question - how much of the charge this product can actually use is left -
 * and scaling to 2400 would read optimistic all the way down.
 *
 * ** PROVISIONAL - factory logs pending, 2026-11-03 **
 *
 * This number is NOT settled. Units in normal service have been observed
 * running about 8 hours at an operational draw of about 320 mA, which is
 * 2560 mAh - more than the cell's 2500 mAh typical, let alone its 2400 rated.
 * So 1980 and the field observation disagree by nearly 30%, and the
 * disagreement points the wrong way: the field units stop at 3.33 V/cell
 * against this measurement's 3.05 V, so allowing for IR drop they stop at a
 * HIGHER open-circuit voltage and should deliver LESS, not more.
 *
 * Candidates: "around 8 hours" may be generous or not strictly
 * full-to-shutdown; "around 320 mA" may be a spot reading rather than a run
 * average; or this 1980 may simply be low, coming from a single bench
 * discharge at 0.68 A on a pack charged to only 4.14 V/cell.
 *
 * At 1980 the estimate reads PESSIMISTIC if the truth is nearer 2400 - it
 * would reach 0% with roughly 17% still in the pack. Safe direction for an
 * indicator, but it will look wrong against measured runtime.
 *
 * TO SETTLE IT: integrate the logged current (published at Current_mA_LSBAddr)
 * over one run from full charge to graceful shutdown. That gives delivered
 * mAh directly, and the true average load alongside it, with no assumptions.
 * Factory logs are expected and will decide this.
 *
 * Also revisit when the charger reaches 16.8 V - charging to 4.2 V/cell
 * instead of 4.14 should raise real capacity regardless.
 */
#define SOC_CAPACITY_MAH    1980L
#define SOC_TICK_SECONDS    2L      /* battery task alternates with the
                                     * accelerometer on a 1 s ticker */

/* 2400 mAh = 8,640,000 mA.s = 4,320,000 units of (mA for one 2 s tick). */
#define SOC_FULL_UNITS      ((int32_t)SOC_CAPACITY_MAH * 3600L / SOC_TICK_SECONDS)

/* Publish at least this often: 300 ticks x 2 s = 10 minutes. */
#define SOC_PUBLISH_TICKS   300u

/* ...and immediately on a move of this many percent, so the Jetson is not
 * reading a ten-minute-old figure right after something interesting. */
#define SOC_PUBLISH_DELTA   2

/* ---- State. Private, and held here rather than re-read from the register
 * file: the accumulator needs more range than the published byte has, and a
 * value the I2C host can write is not a value to integrate against. ---- */

static int32_t  soc_q;                  /* mA.2s, 0 .. SOC_FULL_UNITS */
static bool     soc_known;
static uint8_t  soc_last_published;
static uint16_t soc_publish_countdown;  /* ticks until a forced publish */

/* Debugger aids - the published byte is coarse and only every 10 minutes. */
volatile int32_t soc_dbg_q;
volatile int16_t soc_dbg_last_current;
volatile uint16_t soc_dbg_rejected;     /* readings outside the plausible band */


static uint8_t soc_percent_now(void)
{
    /* soc_q is clamped to SOC_FULL_UNITS, so the product peaks at
     * 432,000,000 - inside int32, no intermediate overflow. */
    if (soc_q <= 0)
        return 0u;
    return (uint8_t)((soc_q * 100L) / SOC_FULL_UNITS);
}


static void soc_publish(uint8_t pct)
{
    EMULATE_EEPROM_Memory[RemainingChargeAddr] = pct;
    soc_last_published = pct;
    soc_publish_countdown = SOC_PUBLISH_TICKS;
}


void SOC_Init(void)
{
    soc_q = 0;
    soc_known = false;
    soc_publish_countdown = 0u;
    soc_last_published = SOC_UNKNOWN;
    soc_dbg_q = 0;
    soc_dbg_last_current = 0;
    soc_dbg_rejected = 0u;

    /* Publish directly rather than through soc_publish(): that would arm the
     * ten-minute countdown, and SOC_UNKNOWN is a state, not a reading. */
    EMULATE_EEPROM_Memory[RemainingChargeAddr] = SOC_UNKNOWN;
}


void SOC_Tick(int16_t current_mA)
{
    uint8_t pct;
    int     delta;

    soc_dbg_last_current = current_mA;

    if (current_mA > SOC_CURRENT_LIMIT_MA || current_mA < -SOC_CURRENT_LIMIT_MA)
    {
        soc_dbg_rejected++;
        return;                     /* glitched read - do not integrate it */
    }

    if (!soc_known)
        return;                     /* no baseline, nothing to decrement */

    /* The whole point of the unit choice: one unit is 1 mA for one tick, so
     * the reading IS the increment. Sign comes from the gauge - negative is
     * discharge. */
    soc_q += current_mA;

    if (soc_q > SOC_FULL_UNITS)
        soc_q = SOC_FULL_UNITS;
    else if (soc_q < 0)
        soc_q = 0;                  /* clamped, but see the header: reaching
                                     * here means the baseline was too high */
    soc_dbg_q = soc_q;

    if (soc_publish_countdown > 0u)
        soc_publish_countdown--;

    pct = soc_percent_now();
    delta = (int)pct - (int)soc_last_published;
    if (delta < 0)
        delta = -delta;

    /* A last_published of SOC_UNKNOWN (255) makes delta large, so the first
     * real estimate after a baseline is published immediately. */
    if (soc_publish_countdown == 0u || delta >= SOC_PUBLISH_DELTA)
        soc_publish(pct);
}


void SOC_SetFull(void)
{
    soc_q = SOC_FULL_UNITS;
    soc_known = true;
    soc_dbg_q = soc_q;
    soc_publish(100u);
}


void SOC_SetBaseline(uint8_t percent)
{
    if (percent > 100u)
        percent = 100u;

    /* 100 * 4,320,000 = 432,000,000, inside int32. */
    soc_q = ((int32_t)percent * SOC_FULL_UNITS) / 100L;
    soc_known = true;
    soc_dbg_q = soc_q;
    soc_publish(percent);
}


bool SOC_IsKnown(void)
{
    return soc_known;
}


uint8_t SOC_Percent(void)
{
    return soc_known ? soc_percent_now() : (uint8_t)SOC_UNKNOWN;
}
