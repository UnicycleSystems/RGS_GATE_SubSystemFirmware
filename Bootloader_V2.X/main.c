/**
  Main entry point for the RGS bootloader.
    Generation Information :
        Product Revision  :  PIC24 / dsPIC33 / PIC32MM MCUs - 1.171.5
        Device            :  PIC24FJ64GA004
    The generated drivers are tested against the following:
        Compiler          :  XC16 v2.10
        MPLAB 	          :  MPLAB X v6.05
*/

/* Power and LED behaviour follows the same rules as the two applications (see
 * CommonFiles/header/power_control.h), adapted to the bootloader's own states:
 *
 *   bi-colour LED  steady red            waiting for a flash (JETSON_CALLING)
 *                  red blinking fast     programming - for a moment after
 *                                        each erase or write
 *                  red/green alternating no valid application image
 *   ring LED       the applications' charge rules, and a fast flash while the
 *                  power button is held or the unit is powering off
 *   power button   the same ~330 ms hold and 60 s countdown as the
 *                  applications, then reset as cold if still powered
 *
 * With a valid image and no flash requested, the bootloader hands over within
 * milliseconds, before any of that matters.
 */

/**
  Section: Included Files
*/
#include "mcc_generated_files/system.h"
#include "mcc_generated_files/boot/boot_demo.h"
#include "mcc_generated_files/boot/boot_process.h"
#include "mcc_generated_files/pin_manager.h"
#include <xc.h>
#include <stdbool.h>



#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>

/* Timings and the VER_0 polarity, shared with both applications so the
 * button, the countdown and the ring LED match them exactly. Constants only:
 * power_control.c itself is NOT built into this image - it carries the
 * applications' cold-start and charge-display code, which the bootloader never
 * runs and has no room for. */
#include "../CommonFiles/header/power_control.h"

/* A hold qualifies after the same ~330 ms the applications use. */
#define BL_HOLD_MS          (PWR_BUTTON_HOLD_STEP_MS * (PWR_BUTTON_HOLD_COUNT + 1u))

/* TMR2 runs at 62.5 kHz (1:256 from FCY = 16 MHz) and wraps once a second. */
#define BL_TMR2_PER_SECOND  62500u
#define BL_MS_TO_TMR2(ms)   ((uint16_t)(((uint32_t)(ms) * 625u) / 10u))

static void     led_timebase_init(void);
static uint16_t tmr2_elapsed(uint16_t since);
static bool     charger_present(void);
static bool     charge_complete(void);
static void     ring_show_charge(uint16_t t);
static void     ring_fast(uint16_t ms);
static void     led_service(void);
static void     power_button(void);
static void     shutdown_countdown_and_off(void);
static void     launch_new_application(void);

static uint8_t  progSecondsLeft;        /* "programming" shown until zero */

/*
                         Main application
 */
int main(void)
{
    /* ---- CLEAN-HANDOFF FAST PATH (must stay FIRST in main) ----------------
     * HOLD_PWR is latched straight away, always: on battery it is the only
     * thing holding our own supply up.
     *
     * JETSON_5V_ON only on a WARM boot - restarted without losing power, such
     * as the reset after a firmware update - so the Jetson does not see its
     * supply dip. On a cold start it stays off here: if we hand over, the
     * application decides; if we stay, it is raised once we know (below). It
     * used to be raised on EVERY boot, which gave the Jetson a short power
     * pulse on each cold start before the application dropped it again.
     *
     * POR and BOR are both tested, as the applications do: a brown-out is a
     * cold start. */
    bool warmBoot = ((RCONbits.POR == 0) && (RCONbits.BOR == 0));

    HOLD_PWR_SetDigitalOutput();
    HOLD_PWR_SetHigh();
    if (warmBoot)
    {
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();
    }

    if (RCONbits.SWR && boot_handoff_magic == BOOT_HANDOFF_MAGIC)
    {
        boot_handoff_magic = 0;          /* consume: never replay */

        BOOT_StartApplication();         /* never returns */
    }
    /* Not a handoff boot: make sure no stale/garbage value lingers. */
    boot_handoff_magic = 0;

    SYSTEM_Initialize();

    /* SYSTEM_Initialize rewrites the latches, so re-assert the rails. Its pin
     * manager sets the Jetson rail from JETSON_CALLING; keep that - a Jetson
     * driving the line is a Jetson that wants to stay powered - and also keep
     * it up on a warm boot. Otherwise it is off until we decide to stay. */
    HOLD_PWR_SetDigitalOutput();
    HOLD_PWR_SetHigh();
    JETSON_5V_ON_SetDigitalOutput();
    if (warmBoot || JETSON_CALLING_GetValue())
        JETSON_5V_ON_SetHigh();
    else
        JETSON_5V_ON_SetLow();

    FRONT_LASER_PWM_SetDigitalOutput();
    REAR_LASER_PWM_SetDigitalOutput();

    FRONT_LASER_PWM_SetHigh();
    REAR_LASER_PWM_SetHigh();

    BOOT_DEMO_Initialize();

    RED_LED_ON_SetDigitalOutput();
    RED_LED_ON_SetLow();
    POWER_BUTTON_SetDigitalInput();
    led_timebase_init();

    /* No wait for the button here any more. On a battery start the user is
     * still holding the power-on press, and the application recognises a
     * battery start BY that press - so hand over with it still held.
     *
     * The button only matters here if we STAY, and then it is armed only once
     * it has been seen released for PWR_BUTTON_RELEASE_MS, so the power-on
     * press can never be taken for a power-off. The release is timed against
     * TMR2 rather than a delay, so UART commands keep being serviced. */
    bool     buttonArmed  = false;
    bool     jetsonRaised = false;
    bool     relTiming    = false;
    uint16_t relStart     = 0;
    bool     callTiming   = false;      /* timing JETSON_CALLING low, post-verify */
    uint16_t callStart    = 0;

    while (1)
    {
        /* First pass decides: hand over (never returns) or stay. */
        BOOT_DEMO_Tasks();

        if (BOOT_DEMO_InBootloadMode())
        {
            if (!jetsonRaised)
            {
                /* Staying: it is the Jetson that flashes us, so power it. */
                JETSON_5V_ON_SetHigh();
                jetsonRaised = true;
            }

            led_service();

            /* A complete, verified update: run it. Only once JETSON_CALLING is
             * released and has stayed low - that pin is what asks us to stay,
             * so resetting while it is high would just land back here, and it
             * floats when the Jetson is unpowered, which is why it is timed
             * rather than sampled once.
             *
             * The host's own RESET_DEVICE still does this the moment it
             * arrives; this covers the case where it never does. */
            if (boot_launch_after_verify)
            {
                if (JETSON_CALLING_GetValue())
                    callTiming = false;
                else if (!callTiming)
                {
                    callTiming = true;
                    callStart  = TMR2;
                }
                else if (tmr2_elapsed(callStart) >= BL_MS_TO_TMR2(100u))
                    launch_new_application();      /* never returns */
            }

            if (!buttonArmed)
            {
                if (POWER_BUTTON_PRESSED())
                    relTiming = false;
                else if (!relTiming)
                {
                    relTiming = true;
                    relStart  = TMR2;
                }
                else if (tmr2_elapsed(relStart) >= BL_MS_TO_TMR2(PWR_BUTTON_RELEASE_MS))
                    buttonArmed = true;
            }
            else if (POWER_BUTTON_PRESSED())
            {
                power_button();          /* returns only if released too soon */
            }
        }
        ClrWdt();
    }

    return 1;
}

/* TMR2 exactly as the applications configure it (1:256 from FCY = 16 MHz,
 * PR2 = 62499: one period per second) but polled - its interrupt stays
 * disabled, so the bootloader's own vectors are not involved. Every LED
 * pattern is worked out from the count, so no state has to be kept. */
static void led_timebase_init(void)
{
    T2CON = 0x0000;
    TMR2  = 0;
    PR2   = 62499;
    IFS0bits.T2IF = 0;
    T2CON = 0x8030;
}

/* TMR2 counts since `since`, allowing for one wrap. Valid for under a second,
 * which the fast main loop always is. */
static uint16_t tmr2_elapsed(uint16_t since)
{
    uint16_t now = TMR2;

    if (now >= since)
        return (uint16_t)(now - since);
    return (uint16_t)((uint32_t)now + BL_TMR2_PER_SECOND - since);
}

static bool charger_present(void)
{
    return (PORTAbits.RA7 == 0);        /* /ACOK low */
}

static bool charge_complete(void)
{
#if PWR_CHARGED_WHEN_VER0_HIGH
    return (PORTCbits.RC7 != 0);        /* VER_0 */
#else
    return (PORTCbits.RC7 == 0);
#endif
}

/* The applications' ring rules, at second-phase t (TMR2 counts): solid while
 * charging, the 100 ms pulse when charged, off without a charger. */
static void ring_show_charge(uint16_t t)
{
    if (!charger_present())
        RED_LED_ON_SetLow();
    else if (!charge_complete())
        RED_LED_ON_SetHigh();
    else if (t < BL_MS_TO_TMR2(PWR_RING_CHARGED_ON_MS))
        RED_LED_ON_SetHigh();
    else
        RED_LED_ON_SetLow();
}

/* ~10 Hz, 50%, from a running millisecond count. */
static void ring_fast(uint16_t ms)
{
    if ((ms % (2u * PWR_RING_FAST_HALF_MS)) < PWR_RING_FAST_HALF_MS)
        RED_LED_ON_SetHigh();
    else
        RED_LED_ON_SetLow();
}

static void led_service(void)
{
    uint16_t t = TMR2;                  /* 0..62499 through each second */
    bool fast = ((t % BL_MS_TO_TMR2(2u * PWR_RING_FAST_HALF_MS))
                                    < BL_MS_TO_TMR2(PWR_RING_FAST_HALF_MS));

    /* "Programming" lasts two second-wraps after the last erase or write, so
     * it shows steadily through a flash rather than flickering per packet. */
    if (boot_programming_activity)
    {
        boot_programming_activity = 0;
        progSecondsLeft = 2;
    }
    if (IFS0bits.T2IF)
    {
        IFS0bits.T2IF = 0;
        if (progSecondsLeft)
            progSecondsLeft--;
    }

    if (progSecondsLeft)                /* programming: red blinking fast */
    {
        BI_LED_GREEN_SetLow();
        if (fast)
            BI_LED_RED_SetHigh();
        else
            BI_LED_RED_SetLow();
    }
    else if (BOOT_DEMO_NoValidImage())  /* no application: red/green alternating */
    {
        if (t < BL_MS_TO_TMR2(500u))
        {
            BI_LED_GREEN_SetLow();
            BI_LED_RED_SetHigh();
        }
        else
        {
            BI_LED_RED_SetLow();
            BI_LED_GREEN_SetHigh();
        }
    }
    else                                /* waiting for a flash: steady red */
    {
        BI_LED_GREEN_SetLow();
        BI_LED_RED_SetHigh();
    }

    ring_show_charge(t);
}

/* A press while staying in the bootloader. Counts the hold with the ring
 * flashing fast; a release that lasts PWR_BUTTON_SETTLE_MS ends it as too
 * short (a bounce gap does not). A qualifying hold waits for a clean release,
 * then powers off and never returns. */
static void power_button(void)
{
    uint16_t held = 0;
    uint16_t released = 0;

    while (held < BL_HOLD_MS)
    {
        if (POWER_BUTTON_PRESSED())
            released = 0;
        else
        {
            released += PWR_BUTTON_SAMPLE_MS;
            if (released >= PWR_BUTTON_SETTLE_MS)
                return;                 /* too short: nothing happens */
        }
        held += PWR_BUTTON_SAMPLE_MS;
        ring_fast(held);
        __delay_ms(PWR_BUTTON_SAMPLE_MS);
        ClrWdt();
    }

    /* Qualified. Wait for a clean release, still flashing, so the press is
     * over before the countdown starts. */
    released = 0;
    while (released < PWR_BUTTON_RELEASE_MS)
    {
        if (POWER_BUTTON_PRESSED())
            released = 0;
        else
            released += PWR_BUTTON_SAMPLE_MS;
        held += PWR_BUTTON_SAMPLE_MS;
        ring_fast(held);
        __delay_ms(PWR_BUTTON_SAMPLE_MS);
        ClrWdt();
    }

    shutdown_countdown_and_off();
}

/* Start the freshly written application, the same way a host RESET_DEVICE
 * does: the reset returns every peripheral to its datasheet state, and the
 * boot that follows verifies the image and hands over.
 *
 * POR and BOR are cleared so the application sees a WARM start - it has just
 * been updated, the Jetson is powered and running, and it should resume rather
 * than wait for a button. That matches ResetDevice()'s behaviour after a
 * programmed session. */
static void launch_new_application(void)
{
    boot_launch_after_verify = 0;

    RCONbits.POR = 0;
    RCONbits.BOR = 0;
    asm("reset");
    while (1)
    {
        /* not reached */
    }
}

/* The applications' power-off: 60 s with the ring flashing fast, then both
 * rails down. On battery the supply dies; if we are still running, external
 * power - the charger - is holding the rail up, so wait with the ring showing
 * charge state, then reset flagged as COLD so the application comes back up in
 * its charge display. Never returns. */
static void shutdown_countdown_and_off(void)
{
    uint16_t ms;

    BI_LED_GREEN_SetLow();
    BI_LED_RED_SetHigh();               /* still on, in the bootloader */
    for (ms = 0; ms < PWR_SHUTDOWN_COUNTDOWN_MS; ms += PWR_RING_FAST_HALF_MS)
    {
        RED_LED_ON_Toggle();
        __delay_ms(PWR_RING_FAST_HALF_MS);
        ClrWdt();
    }

    BI_LED_RED_SetLow();
    BI_LED_GREEN_SetLow();
    RED_LED_ON_SetLow();
    JETSON_5V_ON_SetLow();
    HOLD_PWR_SetLow();

    for (ms = 0; ms < PWR_SHUTDOWN_HOLDOFF_MS; ms += 50u)
    {
        ring_show_charge(BL_MS_TO_TMR2(ms % 1000u));
        __delay_ms(50);
        ClrWdt();
    }

    RCONbits.POR  = 1;
    RCONbits.BOR  = 1;
    RCONbits.EXTR = 1;
    asm("reset");
    while (1)
    {
        /* not reached */
    }
}
/**
 End of File
*/
