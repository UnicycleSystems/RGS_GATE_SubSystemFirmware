/*
 * File:   power_control.h
 *
 * Power-up, power-down, power button and status-LED behaviour, shared by every
 * application image on this board (PuttingGate, RGS_BringUp) so that they
 * behave the same by construction rather than by copying.
 *
 * The rules this implements:
 *
 *   BI-COLOUR LED - power state. Green means ON, off means OFF. (Ball passage,
 *                   errors and the warm-restart flashes also use it, as they
 *                   always have.)
 *
 *   RING LED      - charging and power transitions ONLY, whether the unit is
 *                   on or off:
 *                     button pressed or being debounced, or powering off
 *                                                   ~10 Hz, 50% - takes priority
 *                     charger in, charging          solid on
 *                     charger in, fully charged     100 ms on, 900 ms off
 *                     no charger                    off
 *
 *   COLD START    - button held: a battery start, the press IS the power-on.
 *                   Button not held: wait for /ACOK to settle; if it says
 *                   charger, release HOLD_PWR and wait for a press with the
 *                   unit "off" (unplug -> genuinely off); otherwise run.
 *
 *   WARM START    - POR and BOR both clear, i.e. restarted without losing
 *                   power (normally the hand-over after a firmware upgrade):
 *                   three quick green flashes, then running, Jetson kept up.
 *
 *   POWER OFF     - a ~330 ms hold, then 60 s with the ring flashing fast and
 *                   the bi-colour still green, then both rails drop. If we are
 *                   still running 15 s later, external power is holding the
 *                   rail, so reset flagged as a cold start.
 *
 * Functions that wait BLOCK, clearing the watchdog as they go. None of this is
 * for use from an interrupt.
 *
 * Depends on TMR2 running at 1:256 from FCY = 16 MHz with PR2 = 62499 - the
 * one-second task tick - for the ring LED's 100 ms "charged" pulse.
 */

#ifndef POWER_CONTROL_H
#define POWER_CONTROL_H

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ---- Timing ------------------------------------------------------------ */

#define PWR_BUTTON_SAMPLE_MS       5    /* gap between samples; bounce is ~1-10 ms */
#define PWR_BUTTON_SETTLE_MS      25    /* agreeing samples needed to call it real */
#define PWR_BUTTON_RELEASE_MS     50    /* longer, to be sure a press is finished  */
#define PWR_BUTTON_HOLD_STEP_MS   30    /* one count of a power-on/off hold        */
#define PWR_BUTTON_HOLD_COUNT     10    /* more than this many steps = ~330 ms     */

#define PWR_ACOK_SAMPLE_MS         5
#define PWR_ACOK_SETTLE_MS        25    /* /ACOK must be low this long to count    */
#define PWR_ACOK_TIMEOUT_MS     2000    /* measured 0-580 ms to assert; ~3.5x that */

#define PWR_RING_FAST_HALF_MS     50    /* 50 ms on, 50 ms off = 10 Hz             */
#define PWR_RING_CHARGED_ON_MS   100    /* "charged" pulse, once a second          */
#define PWR_RING_PULSE_TMR2_COUNTS 6250u /* 100 ms of TMR2 at 62.5 kHz             */

#define PWR_SHUTDOWN_COUNTDOWN_MS 10000u /* ring flashing, before the rails drop  */
#define PWR_SHUTDOWN_HOLDOFF_MS   5000u /* after the rails drop, before reset    */

/* VER_0 (RC7) was re-purposed as the charger's "charged" output. HIGH means
 * charged - confirmed against a unit drawing 700 mA with the Jetson off, which
 * read LOW. Only meaningful while /ACOK says a charger is present. */
#define PWR_CHARGED_WHEN_VER0_HIGH 1

/* ---- Boot ---------------------------------------------------------------- */

/* True when the reset did not lose power: POR and BOR both clear. Read it
 * FIRST in main(), before anything touches RCON. A brown-out sets BOR alone,
 * so testing POR only made a sag look like a warm boot - straight to running,
 * no button, Jetson powered: a unit apparently switching itself on. */
bool PWR_IsWarmBoot(void);

/* Before SYSTEM_Initialize(): on a warm boot, re-latch both rails at once so
 * the Jetson does not see its supply dip during the reset. Cold: nothing. */
void PWR_EarlyRailHold(bool warmBoot);

/* After SYSTEM_Initialize(), which bulk-writes the latches and drops both
 * rails: HOLD_PWR back high on BOTH boot types (on battery it is the only thing
 * holding 3V3 up), and the Jetson rail high on a warm boot, low on a cold one
 * until power-on completes. */
void PWR_RailsAfterInit(bool warmBoot);

/* The whole cold-start sequence - see the header comment. Returns powered and
 * running: HOLD_PWR latched, Jetson rail on, bi-colour green, button released.
 * On a charger start it does not return until the user asks to power on. */
void PWR_ColdStartPowerOn(void);

/* Three quick green flashes. Call on a warm boot, before showing green. */
void PWR_ShowWarmRestart(void);

/* Clear POR and BOR once power-on is complete, so every later reset in this
 * power cycle reads as warm. Deliberately AFTER the button hold: a crash or
 * watchdog reset during power-on is then still treated as a cold start. */
void PWR_MarkPowerOnComplete(void);

/* ---- Power button ---------------------------------------------------------- */

/* True only when the button has read `pressed` continuously for settle_ms;
 * false the moment a sample disagrees, so polling an idle button costs one
 * sample. While it is debouncing a press the ring LED flashes fast. */
bool PWR_ButtonStable(bool pressed, uint16_t settle_ms);

/* Block until the button has been released and stayed released. The ring LED
 * keeps flashing while it is held; the caller decides what it shows next. */
void PWR_ButtonWaitReleased(void);

/* Delay up to ms, returning EARLY if the button goes down - for slow display
 * loops. Only cuts the wait short; PWR_ButtonStable() is still the press test. */
void PWR_DelayUnlessPressed(uint16_t ms);

/* Count a press-and-hold. True if it lasted ~330 ms, false if released sooner.
 *   on == true  : on a qualifying hold, latch both rails and show green.
 *   on == false : a power-off request - the rails are left alone and the ring
 *                 keeps flashing, for the countdown that follows.
 * A qualifying hold waits for release before returning, so the same press is
 * never seen twice. A too-short press changes nothing but the ring LED. */
bool PWR_ButtonHold(bool on);

/* ---- Charger and ring LED ------------------------------------------------------ */

bool PWR_ChargerPresent(void);                  /* /ACOK low                */
bool PWR_ChargeComplete(void);                  /* VER_0, charger-present only */

/* Several samples of /ACOK, all of which must agree, for decisions worth more
 * than one reading of an open-collector line - notably refusing to drop into
 * the bootloader, which cannot flash anything without a charger. Takes a few
 * milliseconds; not for use from an interrupt. */
bool PWR_ChargerPresentSettled(void);

/* Poll /ACOK for a low that holds PWR_ACOK_SETTLE_MS, up to timeout_ms. It
 * asserts late on a charger-powered start - measured 0 to 580 ms - so a single
 * early sample decides the session wrongly. */
bool PWR_AcokWaitPresent(uint16_t timeout_ms);

/* Call once a second from the task tick: samples /ACOK and VER_0 and sets the
 * ring LED - solid while charging, a 100 ms pulse when charged, off without a
 * charger. */
void PWR_RingChargeTick(void);

/* Call on every pass of the main loop: ends the 100 ms "charged" pulse without
 * blocking. Costs nothing when no pulse is running. */
void PWR_RingService(void);

/* ---- Power off -------------------------------------------------------------------- */

/* The 60 s countdown, both rails down, and the still-powered failsafe. Never
 * returns: either the supply dies, or it resets flagged as a cold start. Turn
 * off anything application-specific (lasers etc) BEFORE calling. */
void PWR_ShutdownCountdownAndOff(void);

#ifdef __cplusplus
}
#endif

#endif /* POWER_CONTROL_H */
