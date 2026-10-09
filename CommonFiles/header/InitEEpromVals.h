/*
 * File:   InitEEpromVals.h
 * Author: peterbrewster
 *
 * Created on 12 August 2026, 11:21
 *
 * Moved from RGS_BringUp.X into CommonFiles on 2026-10-08 so the application
 * and the bring-up jig initialise the emulated EEPROM the same way.
 *
 * The four version bytes are passed in because firmware_version.h is
 * per-project - see the comment at the top of InitEEpromVals.c.
 */

#ifndef INITEEPROMVALS_H
#define	INITEEPROMVALS_H

#include <stdint.h>

#ifdef	__cplusplus
extern "C" {
#endif

/* Firmware-owned values only - table version, running firmware version, tick
 * rate. Safe to call AFTER a persist restore, and idempotent. Does not touch
 * the accelerometer calibration. */
void PopulateSelectedEEprom(uint8_t rc, uint8_t minor, uint8_t lsb, uint8_t msb);

/* Zero all 256 bytes. The defaults path only - it discards calibration. */
void ZeroEmulatedEEProm(void);

/* ZeroEmulatedEEProm() then PopulateSelectedEEprom(). For a unit with nothing
 * stored in flash; a provisioned board must be restored instead. */
void InitEmulatedEEprom(uint8_t rc, uint8_t minor, uint8_t lsb, uint8_t msb);


#ifdef	__cplusplus
}
#endif

#endif	/* INITEEPROMVALS_H */
