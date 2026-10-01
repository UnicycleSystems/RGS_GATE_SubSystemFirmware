/*
 * File:   power_control.c
 *
 * See power_control.h for the rules. Moved out of PuttingGate.X/main.c, where
 * each piece was developed and bench-tested, so RGS_BringUp can share it.
 */

#include "../header/power_control.h"
#include "../header/pin_manager.h"

/* FCY must be defined before libpic30.h for __delay_ms(). Both main.c files
 * set it to 16 MHz; kept in step here so this file builds standalone. */
#ifndef FCY
#define FCY 16000000UL
#endif
#include <libpic30.h>
#include <xc.h>


/* ==== Ring LED ============================================================ */

static uint16_t s_ringFastMs;       /* time since the last fast-flash toggle   */
static bool     s_ringPulse;        /* "charged" pulse on, waiting to end      */
static uint16_t s_ringPulseStart;   /* TMR2 count when that pulse began        */

bool PWR_ChargerPresent(void)
{
    return (DEBUG_IN_GetValue() == 0);
}

bool PWR_ChargeComplete(void)
{
#if PWR_CHARGED_WHEN_VER0_HIGH
    return (VER_0_GetValue() != 0);
#else
    return (VER_0_GetValue() == 0);
#endif
}

bool PWR_ChargerPresentSettled(void)
{
    uint8_t sample;

    for (sample = 0; sample < 5u; sample++)
    {
        if (!PWR_ChargerPresent())
            return false;               /* any sample high: no charger */
        __delay_ms(1);
        ClrWdt();
    }
    return PWR_ChargerPresent();
}

/* Advance the fast flash by elapsed_ms, toggling every half period. Called from
 * the loops that own the button and the countdown - all of them block, so they
 * can drive the LED directly and need no timer. */
static void ring_fast_step(uint16_t elapsed_ms)
{
    s_ringPulse = false;                /* fast flash overrides the charge pulse */
    s_ringFastMs += elapsed_ms;
    if (s_ringFastMs >= PWR_RING_FAST_HALF_MS)
    {
        s_ringFastMs = 0;
        RED_LED_ON_Toggle();
    }
}

/* Put the ring straight back to what the charger says, when button activity
 * ends. Charged shows as off here; its pulse starts at the next 1 s tick. */
static void ring_show_charge(void)
{
    s_ringFastMs = 0;
    s_ringPulse  = false;
    if (PWR_ChargerPresent() && !PWR_ChargeComplete())
        RED_LED_ON_SetHigh();           /* charging: solid */
    else
        RED_LED_ON_SetLow();
}

void PWR_RingChargeTick(void)
{
    s_ringFastMs = 0;

    if (!PWR_ChargerPresent())
    {
        s_ringPulse = false;
        RED_LED_ON_SetLow();
        return;
    }
    if (!PWR_ChargeComplete())
    {
        s_ringPulse = false;
        RED_LED_ON_SetHigh();           /* charging: solid */
        return;
    }

    RED_LED_ON_SetHigh();               /* charged: start the 100 ms pulse */
    s_ringPulse      = true;
    s_ringPulseStart = TMR2;
}

/* Ends the pulse against TMR2's own count rather than a delay, so the main
 * loop never waits. Elapsed time is measured from where the pulse started, so a
 * tick handled late in the second still gets its full 100 ms. (TMR2 is stopped
 * by the front-sensor interrupt while a ball is in transit; a pulse caught by
 * that simply ends when the timer restarts.) */
void PWR_RingService(void)
{
    uint16_t now;
    uint32_t elapsed;

    if (!s_ringPulse)
        return;

    now = TMR2;
    if (now >= s_ringPulseStart)
        elapsed = (uint32_t)(now - s_ringPulseStart);
    else                                /* TMR2 has wrapped at PR2 */
        elapsed = (uint32_t)now + (uint32_t)PR2 + 1u - (uint32_t)s_ringPulseStart;

    if (elapsed >= PWR_RING_PULSE_TMR2_COUNTS)
    {
        RED_LED_ON_SetLow();
        s_ringPulse = false;
    }
}


/* ==== Power button ======================================================= */

/* POWER_BUTTON is active LOW, with the internal pull-up on CN16, so "pressed"
 * is a LOW reading. Sampling every few ms and restarting on any disagreeing
 * sample outlasts the 1-10 ms of contact bounce, and means a bounce gap part way
 * through a press is not read as a release. */
bool PWR_ButtonStable(bool pressed, uint16_t settle_ms)
{
    uint16_t waited;
    bool     stepped = false;

    for (waited = 0; waited < settle_ms; waited += PWR_BUTTON_SAMPLE_MS)
    {
        if (((POWER_BUTTON_GetValue() == 0) ? true : false) != pressed)
        {
            if (stepped)
                ring_show_charge();     /* a glitch, not a press - undo the flash */
            return false;
        }
        if (pressed)
        {
            ring_fast_step(PWR_BUTTON_SAMPLE_MS);   /* debouncing a press */
            stepped = true;
        }
        __delay_ms(PWR_BUTTON_SAMPLE_MS);
        ClrWdt();
    }
    return (((POWER_BUTTON_GetValue() == 0) ? true : false) == pressed);
}

void PWR_ButtonWaitReleased(void)
{
    while (!PWR_ButtonStable(false, PWR_BUTTON_RELEASE_MS))
    {
        ring_fast_step(PWR_BUTTON_SAMPLE_MS);       /* still held */
        __delay_ms(PWR_BUTTON_SAMPLE_MS);
        ClrWdt();
    }
}

void PWR_DelayUnlessPressed(uint16_t ms)
{
    uint16_t waited;

    for (waited = 0; waited < ms; waited += PWR_BUTTON_SAMPLE_MS)
    {
        if (POWER_BUTTON_GetValue() == 0)
            return;
        __delay_ms(PWR_BUTTON_SAMPLE_MS);
        ClrWdt();
    }
}

/* Formerly PowerButton() in PuttingGate's main.c. Press feedback is now the
 * ring LED alone: the bi-colour is left as it was, so a too-short press no
 * longer blanks it. */
bool PWR_ButtonHold(bool on)
{
    uint8_t held   = 0;
    bool    passed = false;

    /* Count for as long as the button is held. The debounced release test means
     * a bounce gap mid-press is not taken for a release. */
    while (!PWR_ButtonStable(false, PWR_BUTTON_SETTLE_MS))
    {
        held++;
        ClrWdt();
        ring_fast_step(PWR_BUTTON_HOLD_STEP_MS);
        __delay_ms(PWR_BUTTON_HOLD_STEP_MS);
        if (held > PWR_BUTTON_HOLD_COUNT)
        {
            passed = true;
            break;
        }
    }

    if (!passed)
    {
        /* Released too soon: change nothing, and return straight away. Waiting
         * for a release here would swallow a second press made meanwhile - and
         * callers loop on this, so a swallowed press means no later press ever
         * powers the unit up. */
        ring_show_charge();
        return false;
    }

    if (on)
    {
        HOLD_PWR_SetHigh();
        JETSON_5V_ON_SetHigh();
        BI_LED_RED_SetLow();
        BI_LED_GREEN_SetHigh();
    }

    /* Wait for release, so the caller does not see this press a second time. */
    PWR_ButtonWaitReleased();

    if (on)
        ring_show_charge();
    /* off: leave the ring flashing - the countdown that follows carries it on. */
    return true;
}


/* ==== Boot ================================================================= */

bool PWR_IsWarmBoot(void)
{
    return ((RCONbits.POR == 0) && (RCONbits.BOR == 0));
}

void PWR_EarlyRailHold(bool warmBoot)
{
    if (warmBoot)
    {
        HOLD_PWR_SetDigitalOutput();
        HOLD_PWR_SetHigh();
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();
    }
}

void PWR_RailsAfterInit(bool warmBoot)
{
    HOLD_PWR_SetDigitalOutput();
    JETSON_5V_ON_SetDigitalOutput();
    HOLD_PWR_SetHigh();                 /* keep our own supply latched, both boot types */
    if (warmBoot)
    {
        JETSON_5V_ON_SetHigh();
        ClrWdt();
    }
    else
    {
        JETSON_5V_ON_SetLow();
    }
    RED_LED_ON_SetDigitalOutput();
}

bool PWR_AcokWaitPresent(uint16_t timeout_ms)
{
    uint16_t waited;
    uint8_t  low_run = 0;               /* consecutive low samples */

    for (waited = 0; waited < timeout_ms; waited += PWR_ACOK_SAMPLE_MS)
    {
        if (DEBUG_IN_GetValue() == 0)
        {
            low_run++;
            if (low_run >= (PWR_ACOK_SETTLE_MS / PWR_ACOK_SAMPLE_MS))
                return true;
        }
        else
        {
            low_run = 0;                /* must be CONTINUOUSLY low */
        }
        __delay_ms(PWR_ACOK_SAMPLE_MS);
        ClrWdt();
    }
    return false;
}

/* Charger start, unit "off": bi-colour off, ring showing charge state, until a
 * real press. The waits end early when the button goes down, so a press does
 * not have to outlast the rest of a one-second cycle.
 *
 * Only reached with the charger present - HOLD_PWR is already released, so if
 * the charger goes, the supply goes with it and this simply stops. */
static void charge_display_until_pressed(void)
{
    BI_LED_GREEN_SetLow();
    BI_LED_RED_SetLow();                /* off means off */

    while (!PWR_ButtonStable(true, PWR_BUTTON_SETTLE_MS))
    {
        ClrWdt();
        if (PWR_ChargeComplete())
        {
            RED_LED_ON_SetHigh();       /* charged: 100 ms pulse */
            PWR_DelayUnlessPressed(PWR_RING_CHARGED_ON_MS);
            RED_LED_ON_SetLow();
            PWR_DelayUnlessPressed(1000u - PWR_RING_CHARGED_ON_MS);
        }
        else
        {
            RED_LED_ON_SetHigh();       /* charging: solid */
            PWR_DelayUnlessPressed(1000u);
        }
    }
}

/* HOW THE TWO STARTS ARE TOLD APART - not by a single read of RA7:
 *
 * The BUTTON is asked first. On battery the press is what powers the rail, and
 * it outlasts startup, so the button is still down when we get here - measured
 * on the bench. Nobody is touching it on a charger start. That reading is
 * available immediately and needs no settling.
 *
 * Only when the button is NOT held is /ACOK consulted, and then we WAIT for it:
 * on a charger-powered start the PIC runs before the charger IC asserts its
 * AC-present output, so a single sample read "no charger" while a read moments
 * later read "charger present". The wait costs a button start nothing, because
 * that case never reaches it.
 *
 * Safety: HOLD_PWR is only released when the charger DEFINITELY reads present.
 * Anything else runs and stays latched, so a misread cannot strand a battery
 * start dead. That is also what makes this safe for the bring-up jig on a bench
 * with no charger: no charger means the battery path, and it stays up. */
void PWR_ColdStartPowerOn(void)
{
    bool chargerBoot;

    if (PWR_ButtonStable(true, PWR_BUTTON_SETTLE_MS))
        chargerBoot = false;
    else
        chargerBoot = PWR_AcokWaitPresent(PWR_ACOK_TIMEOUT_MS);

    if (chargerBoot)
    {
        /* The charger holds the rail, so unplugging while idle turns the unit
         * genuinely off rather than leaving it latched on doing nothing. */
        HOLD_PWR_SetLow();
        charge_display_until_pressed();

        /* Pressed: take ownership of our own supply and power on. (HOLD_PWR is
         * latched here, before the hold below has qualified - unchanged from
         * before; see the power-up analysis, item 2.) */
        RED_LED_ON_SetLow();
        HOLD_PWR_SetHigh();
        while (!PWR_ButtonHold(true))
            ClrWdt();
    }
    else
    {
        /* Battery: this press IS the power-on. HOLD_PWR is already latched, so
         * the unit stays up on release. The Jetson rail was dropped for the cold
         * path and PWR_ButtonHold(true) - the only other place that raises it -
         * is on the charger branch, so raise it here.
         *
         * Then wait for a DEBOUNCED release: the main loop reads a held button
         * as a power-OFF request, and a hold qualifies after ~330 ms, so running
         * with this press still held would shut the unit straight back down. */
        JETSON_5V_ON_SetHigh();
        PWR_ButtonWaitReleased();
        ring_show_charge();
    }
}

void PWR_ShowWarmRestart(void)
{
    uint8_t n;

    BI_LED_RED_SetLow();
    for (n = 0; n < 3; n++)
    {
        BI_LED_GREEN_SetHigh();
        __delay_ms(100);
        BI_LED_GREEN_SetLow();
        __delay_ms(100);
        ClrWdt();
    }
}

void PWR_MarkPowerOnComplete(void)
{
    RCONbits.POR = 0;
    RCONbits.BOR = 0;
}


/* ==== Power off ============================================================ */

void PWR_ShutdownCountdownAndOff(void)
{
    uint16_t ms;

    /* The countdown: the ring LED flashes fast throughout, and the bi-colour
     * stays GREEN - the unit is still on until the rails drop. */
    BI_LED_RED_SetLow();
    BI_LED_GREEN_SetHigh();
    for (ms = 0; ms < PWR_SHUTDOWN_COUNTDOWN_MS; ms += PWR_RING_FAST_HALF_MS)
    {
        RED_LED_ON_Toggle();
        __delay_ms(PWR_RING_FAST_HALF_MS);
        ClrWdt();
    }

    /* The actual power-off. */
    BI_LED_GREEN_SetLow();
    BI_LED_RED_SetLow();
    RED_LED_ON_SetLow();
    JETSON_5V_ON_SetLow();
    HOLD_PWR_SetLow();

    /* On battery the supply dies somewhere in here. Still running means
     * external power - the charger - is holding the rail up. Wait a while, with
     * the ring showing charge state since we are now "off" on a charger, then
     * reset flagged as a COLD start, so we come back in the charge display
     * instead of sitting here dark.
     *
     * The counter used to be a uint8_t compared with 300: it wrapped at 255, the
     * test never came true, and a unit powered off on the charger sat dark here
     * forever. */
    for (ms = 0; ms < PWR_SHUTDOWN_HOLDOFF_MS; ms += 50u)
    {
        if (PWR_ChargerPresent() &&
            (!PWR_ChargeComplete() || (ms % 1000u) < PWR_RING_CHARGED_ON_MS))
            RED_LED_ON_SetHigh();
        else
            RED_LED_ON_SetLow();
        __delay_ms(50);
        ClrWdt();
    }

    RCONbits.EXTR = 1;
    RCONbits.POR  = 1;
    RCONbits.BOR  = 1;
    asm("reset");
    while (1)
    {
        /* not reached */
    }
}
