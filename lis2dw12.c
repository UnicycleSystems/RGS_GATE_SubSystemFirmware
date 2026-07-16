#include "lis2dw12.h"
#include "RGS_MCC_Copies/i2c2.h"
#include <string.h>
#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>

static bool lis2dw12_write_register(uint8_t reg, uint8_t value);
static bool lis2dw12_read_register(uint8_t reg, uint8_t *value);
static bool lis2dw12_read_registers(uint8_t start_reg, uint8_t *data, uint8_t len);
bool LIS2DW12_Configure(void);

bool LIS2DW12_Init(void)
{
    uint8_t id = 0;
    if (!lis2dw12_read_register(LIS2DW12_REG_WHO_AM_I, &id))
        return false;
    if (id != LIS2DW12_WHO_AM_I_ID)
        return false;

    // Reset device
    if (!lis2dw12_write_register(LIS2DW12_REG_CTRL2, 0x40))
        return false;

    __delay32((uint32_t)(FCY / 1000ul * 10)); // 10 ms delay

    // CTRL1: ODR = 100Hz, mode = LP mode 1, FS = Â±2g
    if (!lis2dw12_write_register(LIS2DW12_REG_CTRL1, 0x44))
        return false;

    // CTRL3: push-pull interrupt pin
    if (!lis2dw12_write_register(LIS2DW12_REG_CTRL3, 0x00))
        return false;

    // CTRL6: Low-noise, BDU, auto increment enabled
    if (!lis2dw12_write_register(LIS2DW12_REG_CTRL6, 0x10))
        return false;

    return true;
}

bool LIS2DW12_ReadXYZ(int16_t *x, int16_t *y, int16_t *z)
{
    uint8_t buf[6];
    if (!lis2dw12_read_registers(LIS2DW12_REG_OUT_X_L | 0x80, buf, 6)) // 0x80 = auto-increment
        return false;

    *x = (int16_t)((int16_t)buf[1] << 8 | buf[0]);
    *y = (int16_t)((int16_t)buf[3] << 8 | buf[2]);
    *z = (int16_t)((int16_t)buf[5] << 8 | buf[4]);
    return true;
}

bool LIS2DW12_ClearInterrupt(void)
{
    uint8_t src;
    return lis2dw12_read_register(LIS2DW12_REG_WAKE_UP_SRC, &src);
}

static bool lis2dw12_write_register(uint8_t reg, uint8_t value)
{
    uint8_t buf[2] = {reg, value};
    I2C2_MESSAGE_STATUS status;
    I2C2_MasterWrite(buf, 2, LIS2DW12_I2C_ADDRESS, &status);
    while (status == I2C2_MESSAGE_PENDING);
    return status == I2C2_MESSAGE_COMPLETE;
}

static bool lis2dw12_read_register(uint8_t reg, uint8_t *value)
{
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
    I2C2_MESSAGE_STATUS status;

    // Build TRB: write register address, then read one byte
    I2C2_MasterWriteTRBBuild(&trb[0], &reg, 1, LIS2DW12_I2C_ADDRESS);
    I2C2_MasterReadTRBBuild(&trb[1], value, 1, LIS2DW12_I2C_ADDRESS);

    I2C2_MasterTRBInsert(2, trb, &status);
    while (status == I2C2_MESSAGE_PENDING);

    return status == I2C2_MESSAGE_COMPLETE;
}

static bool lis2dw12_read_registers(uint8_t start_reg, uint8_t *data, uint8_t len)
{
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
    I2C2_MESSAGE_STATUS status;

    I2C2_MasterWriteTRBBuild(&trb[0], &start_reg, 1, LIS2DW12_I2C_ADDRESS);
    I2C2_MasterReadTRBBuild(&trb[1], data, len, LIS2DW12_I2C_ADDRESS);

    I2C2_MasterTRBInsert(2, trb, &status);
    while (status == I2C2_MESSAGE_PENDING);

    return status == I2C2_MESSAGE_COMPLETE;
}

bool lis2dw12_read_xyz_raw(int16_t *x, int16_t *y, int16_t *z)
{
    uint8_t rawData[6];
    uint8_t reg = 0x28 | 0x80;  // OUT_X_L with auto-increment
    I2C2_MESSAGE_STATUS status;

    // Write register address
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
    I2C2_MasterWriteTRBBuild(&trb[0], &reg, 1, LIS2DW12_I2C_ADDRESS);
    I2C2_MasterReadTRBBuild(&trb[1], rawData, 6, LIS2DW12_I2C_ADDRESS);
    I2C2_MasterTRBInsert(2, trb, &status);
    
    while (status == I2C2_MESSAGE_PENDING)
        ClrWdt();

    if (status != I2C2_MESSAGE_COMPLETE)
        return false;

    // Combine into 16-bit signed values (little endian)
    *x = (int16_t)((rawData[1] << 8) | rawData[0]);
    *y = (int16_t)((rawData[3] << 8) | rawData[2]);
    *z = (int16_t)((rawData[5] << 8) | rawData[4]);

    return true;
}

bool LIS2DW12_Configure(void)
{
    // Enable block data update, auto-increment, default settings
    if (!lis2dw12_write_register(0x21, 0x00)) return false;  // CTRL2

    // Enable 100Hz ODR, LP Mode 2, ±2g
    if (!lis2dw12_write_register(0x20, 0x42)) return false;  // CTRL1

    // Delay for sensor to stabilize
    __delay_ms(10);

    return true;
}
