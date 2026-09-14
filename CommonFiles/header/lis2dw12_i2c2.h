/*
 * File:   lis2dw12_i2c2.h
 *
 * LIS2DW12 accelerometer over I2C2, as used on the RGS board.
 *
 * Shared by PuttingGate.X and RGS_BringUp.X, which each carried a byte-for-byte
 * identical copy of this code in main.c. Moved verbatim - behaviour unchanged.
 *
 * NOT the same as lis2dw12.h in this folder. That is an older, parallel
 * implementation (LIS2DW12_Init / LIS2DW12_ReadXYZ, no _I2C2 suffix) which is
 * in NEITHER project's build. The _I2C2 functions here are the ones actually
 * used. Retiring the other one is outstanding.
 *
 * What this deliberately does NOT provide is the axis remap, the calibration,
 * or the packing into EMULATE_EEPROM_Memory. That is QuickAcellerometerGrabber()
 * in each project, and the two versions still differ - PuttingGate publishes
 * big-endian (which is what the Jetson unpacks with struct '>hhh'), BringUp
 * publishes little-endian via MAP_PackInt16(). Until that is settled they stay
 * where they are.
 */

#ifndef LIS2DW12_I2C2_H
#define LIS2DW12_I2C2_H

#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ---- Device registers ---- */
#define REG_WHO_AM_I        0x0F    /* expect 0x44 */
#define REG_CTRL1           0x20
#define REG_CTRL2           0x21
#define REG_CTRL6           0x25
#define REG_OUT_X_L         0x28    /* then X_H, Y_L, Y_H, Z_L, Z_H */

#define CTRL2_BDU           (1u << 3)
#define CTRL2_IF_ADD_INC    (1u << 2)

/* 7-bit addresses. SA0 grounded gives 0x18. */
#define LIS_ADDR_0 0x18
#define LIS_ADDR_1 0x19

/* Override the device address. Init sets it to LIS_ADDR_0, so this is only
 * needed for a board wired with SA0 high. */
void LIS2DW12_SetAddress_I2C2(uint8_t addr);

/* Power-down, then configure for ~100 Hz at FS +/-2g. Returns true on success.
 *
 * Leaves progress markers in EMULATE_EEPROM_Memory[30..34] - scratch addresses
 * outside the published map, used for bring-up debugging. Preserved from the
 * original rather than removed, so behaviour is identical. */
bool LIS2DW12_Init_I2C2(void);

/* Raw sensor axes, already shifted down by 2 to drop the unused low bits.
 * These are DEVICE axes - no board-orientation remap has been applied. */
bool LIS2DW12_ReadXYZ_I2C2(int16_t *x, int16_t *y, int16_t *z);

#ifdef __cplusplus
}
#endif

#endif /* LIS2DW12_I2C2_H */
