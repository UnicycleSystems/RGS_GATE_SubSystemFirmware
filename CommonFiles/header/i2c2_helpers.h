/*
 * File:   i2c2_helpers.h
 *
 * Blocking register-level access over I2C2, shared by every project on this
 * board.
 *
 * NOT accelerometer-specific despite where the code came from: PuttingGate's
 * GetBattVolts() uses i2c2_read_regs() to reach the BQ40Z50 gauge, and any
 * other I2C2 device can use the same primitives.
 *
 * Lifted verbatim from the copies that were duplicated in PuttingGate.X and
 * RGS_BringUp.X main.c - the two were byte-identical, so this is a move, not
 * a rewrite. Behaviour is unchanged.
 *
 * All of these BLOCK, clearing the watchdog while they wait, and give up after
 * 50 ms. Do not call them from an interrupt.
 */

#ifndef I2C2_HELPERS_H
#define I2C2_HELPERS_H

#include <stdint.h>
#include <stdbool.h>
#include "i2c2.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Spin until a transaction finishes, times out, or fails.
 * Returns false only on timeout - the caller must still check *st. */
bool i2c2_wait_done(volatile I2C2_MESSAGE_STATUS *st, uint16_t timeout_ms);

/* Write one byte to one register. dev7 is the 7-bit device address. */
bool i2c2_write_u8(uint8_t dev7, uint8_t reg, uint8_t val);

/* Read n bytes starting at start_reg.
 *
 * Tries a repeated-START transfer first, then falls back to a STOP between
 * the register write and the read - some devices on this bus need the second
 * form, so the fallback is load-bearing, not belt-and-braces. */
bool i2c2_read_regs(uint8_t dev7, uint8_t start_reg, uint8_t *dst, uint8_t n);

/* Read a single register. */
bool i2c2_read_u8(uint8_t dev7, uint8_t reg, uint8_t *val);

/* Clock out any device holding SDA low, then reset the driver - which also
 * empties its queue of transfers abandoned by a timeout. Call before the
 * first I2C2 access after reset, and after a read that fails.
 *
 * Takes ~15 ms on a healthy bus. Every step is capped at ~20 ms, so a line
 * that is truly stuck cannot hang it. Reports nothing: follow it with a real
 * read to find out whether the bus is usable. */
void i2c2_bus_unwedge(void);

#ifdef __cplusplus
}
#endif

#endif /* I2C2_HELPERS_H */
