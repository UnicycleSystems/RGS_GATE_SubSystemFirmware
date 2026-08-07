#ifndef LIS2DW12_H
#define LIS2DW12_H

#include <stdint.h>
#include <stdbool.h>

#define LIS2DW12_I2C_ADDRESS        0x18    // SA0 grounded

// Register addresses
#define LIS2DW12_REG_WHO_AM_I      0x0F
#define LIS2DW12_REG_CTRL1         0x20
#define LIS2DW12_REG_CTRL2         0x21
#define LIS2DW12_REG_CTRL3         0x22
#define LIS2DW12_REG_CTRL4_INT1    0x23
#define LIS2DW12_REG_CTRL5_INT2    0x24
#define LIS2DW12_REG_CTRL6         0x25
#define LIS2DW12_REG_OUT_X_L       0x28

#define LIS2DW12_REG_STATUS_DUP    0x37
#define LIS2DW12_REG_WAKE_UP_SRC   0x38

// WHO_AM_I expected value
#define LIS2DW12_WHO_AM_I_ID       0x44

bool LIS2DW12_Init(void);
bool LIS2DW12_ReadXYZ(int16_t *x, int16_t *y, int16_t *z);
bool LIS2DW12_ClearInterrupt(void);
bool lis2dw12_read_xyz_raw(int16_t *x, int16_t *y, int16_t *z);


#endif