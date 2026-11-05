/*
 * soc_estimator.h - coulomb-counting state of charge estimate.
 *
 * Integrates the pack current reading the battery task already takes, and
 * publishes a percentage to RemainingChargeAddr in the emulated EEPROM.
 *
 * Not yet wired into main(). Compiled so it stays honest, called later.
 *
 * ---- The arithmetic ----
 *
 * Charge is accumulated in units of "mA sustained for one tick", with a tick
 * being the 2 s between battery readings. That choice makes the per-tick
 * update the RAW READING - no multiply, no divide, no floats:
 *
 *     Q += current_mA;
 *
 * One unit is 2 mA.s, so 2400 mAh is 2400 x 3600 / 2 = 4,320,000 units. An
 * int32 holds that with a factor of 497 to spare, and the percentage
 * conversion (Q x 100) peaks at 432,000,000, still inside int32.
 *
 * Resolution is 0.000556 mAh per unit, so quantisation is irrelevant. Reading
 * whole milliamps costs at most 0.28% over a full discharge, and a dropped
 * reading costs 0.0074%.
 *
 * SIGNED, not unsigned, deliberately. The headroom is ample either way, but a
 * negative Q means the starting estimate was too high - which is information
 * worth having. Unsigned would either wrap catastrophically (100 - 320 reads
 * as 99,421% full) or clamp silently and lose the signal.
 *
 * ---- What limits the accuracy ----
 *
 * Not the arithmetic, which is exact. The gauge's Current register is its own
 * internal integration over a few hundred milliseconds, sampled once per
 * tick - so a reading is treated as the average over 2 s when it is really a
 * snapshot. For the steady ~320 mA this product draws that is equivalent. A
 * load that switches mid-tick is unaccounted until the next reading, bounded
 * at 2 s of error per transition.
 */

#ifndef SOC_ESTIMATOR_H
#define SOC_ESTIMATOR_H

#include <stdint.h>
#include <stdbool.h>

/* Published to RemainingChargeAddr before any estimate exists. Distinct from
 * 0 (genuinely flat) and 100 (genuinely full), so a reader can tell "no
 * estimate yet" from "estimate of nothing left". */
#define SOC_UNKNOWN             0xFFu

/* Readings beyond this are rejected rather than integrated. A glitched
 * transaction returning 0x7FFF would otherwise add 32,767 units - 0.76% of
 * the pack - in a single tick, silently. Must span the CHARGE direction too:
 * the charger delivers 800-900 mA at bulk. */
#define SOC_CURRENT_LIMIT_MA    1000

/* Start in "unknown" and publish SOC_UNKNOWN. Ticks are ignored until a
 * baseline arrives, from SOC_SetFull() or SOC_SetBaseline(). */
void    SOC_Init(void);

/* One battery reading, signed mA, negative discharging. Call exactly once per
 * reading and not otherwise - the 2 s interval is structural, so driving this
 * from the battery task rather than a timer is what keeps it true. A failed
 * read means simply not calling, which costs 2 s of accounting. */
void    SOC_Tick(int16_t current_mA);

/* Charge termination detected: the pack is full. */
void    SOC_SetFull(void);

/* Seed from an external estimate, 0..100. For the voltage-and-current
 * baseline, which is not designed yet. */
void    SOC_SetBaseline(uint8_t percent);

/* False until a baseline has been established. */
bool    SOC_IsKnown(void);

/* 0..100, or SOC_UNKNOWN. */
uint8_t SOC_Percent(void);

#endif /* SOC_ESTIMATOR_H */
