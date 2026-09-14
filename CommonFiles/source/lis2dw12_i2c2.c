/*
 * File:   lis2dw12_i2c2.c
 *
 * See lis2dw12_i2c2.h. Moved verbatim from the identical copies that lived in
 * PuttingGate.X/main.c and RGS_BringUp.X/main.c.
 *
 * The only textual difference between the two was BringUp writing s_addr=0x18
 * where PuttingGate wrote s_addr=LIS_ADDR_0. Same value; the named constant is
 * kept here.
 */

#include "../header/lis2dw12_i2c2.h"
#include "../header/i2c2_helpers.h"
#include "../header/MemoryMap.h"


/* Device address, settable for a board with SA0 high. Init forces it to
 * LIS_ADDR_0, so a SetAddress call must come after Init to take effect. */
static uint8_t s_addr = LIS_ADDR_0;

void LIS2DW12_SetAddress_I2C2(uint8_t addr) { s_addr = addr; }


bool LIS2DW12_Init_I2C2(void)
{
    EMULATE_EEPROM_Memory[30] = 0xA1;     // entered init

    s_addr=LIS_ADDR_0;    // 0x18, SA0 grounded - matches lis2dw12.h

    EMULATE_EEPROM_Memory[31] = s_addr;


// Explicitly enter power-down
    if (!i2c2_write_u8(s_addr, REG_CTRL1, 0x00))
    {
        EMULATE_EEPROM_Memory[33] = 0xC0;
        return false;
    }

    if (!i2c2_write_u8(s_addr, REG_CTRL2, 0x0C))
        { EMULATE_EEPROM_Memory[32] = 0xC2; return false; }

    if (!i2c2_write_u8(s_addr, REG_CTRL6, 0xC4))   // ~100 Hz, FS +/-2g
        { EMULATE_EEPROM_Memory[33] = 0xC1; return false; }

     if (!i2c2_write_u8(s_addr, REG_CTRL1, 0x24))   // ~100 Hz, FS +/-2g
        { EMULATE_EEPROM_Memory[33] = 0xC1; return false; }

    EMULATE_EEPROM_Memory[34] = 0x00;     // success
    return true;
}


bool LIS2DW12_ReadXYZ_I2C2(int16_t *x, int16_t *y, int16_t *z)
{
    uint8_t raw[6];
    if (!i2c2_read_regs(s_addr, REG_OUT_X_L, raw, 6)) return false;

    *x = (int16_t)((uint16_t)raw[1] << 8 | raw[0]);
    *y = (int16_t)((uint16_t)raw[3] << 8 | raw[2]);
    *z = (int16_t)((uint16_t)raw[5] << 8 | raw[4]);
    *x>>=2;
    *y>>=2;
    *z>>=2;

    return true;
}
