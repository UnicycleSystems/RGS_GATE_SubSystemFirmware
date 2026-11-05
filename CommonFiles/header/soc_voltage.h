/*
 * soc_voltage.h - voltage-derived state of charge indicator.
 *
 * Maps pack voltage to a percentage through a lookup table measured on a real
 * unit under operational load, and raises the low-battery warnings.
 *
 * LIVE in PuttingGate since 2026-11-05. SOCV_Init() runs in the init block
 * and SOCV_Update() at the tail of GetBattVolts(), which the round-robin task
 * table reaches every 2 s - the cadence SOCV_DEBOUNCE_COUNT assumes. It
 * replaced the hand-picked VoltageThresholds[] ratchet, whose numbers are
 * preserved in a comment at the top of that file, and it now OWNS all three
 * battery warning bits. soc_estimator.c remains compiled but uncalled.
 *
 * ---- Why voltage rather than coulomb counting ----
 *
 * soc_estimator.c implements the coulomb-counting alternative and is the more
 * accurate instrument in principle, but it needs a trustworthy capacity
 * figure, a baseline to start from, and accounting across sleep. This system
 * draws a fairly constant load throughout its use, which is the one condition
 * under which a voltage lookup is reliable - so it answers the question well
 * enough with no state to drift and nothing to persist.
 *
 * ONLY ONE of the two modules may be wired in at a time: both publish to
 * RemainingChargeAddr. This one is the live one - do not call SOC_Update()
 * from soc_estimator.c without taking this one out first.
 *
 * ---- Where the curve comes from ----
 *
 * EVERY point is measured. The source is a logged discharge of unit spg00071
 * in normal service on 2026-11-02, 17:42:51 to 23:32:03 - 5.82 h, 1281
 * readings of voltage AND current, ending in the unit's own automatic power
 * off at 13311 mV. Kept in bq40z50r2_goldenimages/GaugeCharacterisation/.
 *
 * Charge delivered is the trapezoidal integral of the logged current: 2010 mAh
 * at an average of 345 mA. Percentages are that integral, so the curve is
 * voltage against charge actually taken out of the pack.
 *
 * Integrating matters, because the load is NOT constant current. The main
 * draw is switched-mode buck converters, so power is near constant and the
 * current RISES as the voltage falls - 311 mA at 16.402 V up to 384 mA at
 * 13.311 V. Over the run the power spread is 10% (mean 5.12 W) against a
 * current spread of 24%. An earlier version of this table took elapsed time
 * as a proxy for charge, which quietly understated the charge drawn near the
 * bottom where the current is highest; that is what integrating fixes.
 *
 * ---- Where zero sits ----
 *
 * The table reads 0% at 13500 mV, which is 3.6% of the measured discharge -
 * so the percentages are the measured curve rescaled by 1.037, and there is
 * real pack left below the table's zero. That reserve is what SOCV_MIN_
 * REPORTED_PCT and the shutdown voltage below are spending.
 *
 * ---- Load compensation: deliberately absent ----
 *
 * The curve already embeds the rising current described above, because it was
 * measured under the real load. What it does not cover is a laser switching,
 * and that turns out to be small: the lasers measure about 35 mA front and
 * 31 mA rear, so both together are some 66 mA, which through a pack
 * resistance of roughly 0.37 ohm is about 24 mV - under 1% of indicated
 * charge. Not worth the complexity. If the load profile changes, correct the
 * reading back to the reference load before the lookup:
 *     V_corrected = V_measured - (I_actual - I_reference) * R_pack
 */

#ifndef SOC_VOLTAGE_H
#define SOC_VOLTAGE_H

#include <stdint.h>
#include <stdbool.h>

/* ---- Hard limit ----
 *
 * 13300 mV, matching the existing CriticalVoltage in main.c, so this changes
 * where the gauge READS zero without changing where the unit actually stops.
 * The log of 2026-11-02 shows the unit performing its automatic power off at
 * 13311 mV, so this is proven behaviour rather than a new decision.
 *
 * At 13300 mV the pack is at 3325 mV/cell averaged, and with the 50-60 mV
 * spread measured near the bottom the weakest cell is still around 3270 mV.
 * That is nowhere near anything protective - 470 mV above the gauge's Term
 * Min Cell V floor of 2800, and a whole volt above CUV at 2300. There is a
 * great deal of unused pack below this point; stopping here is a choice about
 * reserve, not a safety limit. */
#define SOCV_SHUTDOWN_MV        13300u  /* force a graceful power-down */

/* Warnings, on indicated percentage. All three land inside the MEASURED part
 * of the curve, and all three trip at 13826 / 13662 / 13551 mV respectively.
 *
 * Those are NOT the table's 10 / 5 / 1 percent crossings, which are 13795 /
 * 13629 / 13526 mV. The comparisons are made on the INTEGER percent, and
 * integer division means pct reads 10 from the moment the true value falls
 * below 10.9%, so each bit fires some 30 mV early. That is the safe direction
 * and it is left alone deliberately - but anyone matching these thresholds
 * against the table will find the 30 mV and should know it is arithmetic
 * rather than a mistake.
 *
 * They are cumulative, not exclusive: by 1% all three are asserted. The
 * Jetson is told "low", then "critical", then "about ten minutes left", and
 * finally PowerOff_1_min at SOCV_SHUTDOWN_MV, which is the one that acts. */
#define SOCV_WARN_PCT              10u
#define SOCV_CRITICAL_PCT           5u
#define SOCV_IMMINENT_PCT           1u

/* Never report 0. The unit still runs below the table's zero, and a gauge
 * reading 0% on a working machine reads as broken.
 *
 * 1% is honest rather than a fudge: the table reaches zero at 13500 mV and
 * the unit stops at 13300 mV, which at the measured ~380 mA of that region is
 * about 15 minutes. Spacing from the first warning down: 10% to 5% is 16 min,
 * 5% to 1% is 13 min, 1% to power off is 15 min - roughly three quarters of
 * an hour of notice in all. */
#define SOCV_MIN_REPORTED_PCT       1u

/* Consecutive qualifying readings before a trigger fires. Readings are 2 s
 * apart, so 3 is 6 seconds. Without this a laser switching on at 13.32 V
 * would sag the pack past 13300 mV for a few hundred milliseconds and power
 * the unit down. */
#define SOCV_DEBOUNCE_COUNT         3u

/* A trigger clears only once the pack recovers this far above its threshold,
 * so a unit sitting on the boundary does not oscillate. */
#define SOCV_HYSTERESIS_MV        200u


void     SOCV_Init(void);

/* One battery reading: pack millivolts, and signed mA for future load
 * compensation (presently unused - see the note above). Call once per
 * reading, which is every 2 s. */
void     SOCV_Update(uint16_t pack_mV, int16_t current_mA);

/* Indicated charge, SOCV_MIN_REPORTED_PCT..100. Also published to
 * RemainingChargeAddr by SOCV_Update(). */
uint8_t  SOCV_Percent(void);

/* Warning bits to be OR-ed into the task warning word: LowBatteryWarning,
 * LowBatteryCritical, PowerOff_10_min, PowerOff_1_min. Debounced, with
 * hysteresis. Recomputed from scratch on every SOCV_Update(), so a caller
 * holding a latched copy must clear all four before merging these in. */
uint16_t SOCV_Warnings(void);

/* True once the pack has been below SOCV_SHUTDOWN_MV for the debounce
 * period - the caller should begin a graceful power-down. */
bool     SOCV_ShutdownRequired(void);

#endif /* SOC_VOLTAGE_H */
