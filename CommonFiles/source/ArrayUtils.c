#include "../header/ArrayUtils.h"


void MAP_PackInt16(int16_t value, uint8_t *lsb)
{
    uint16_t u = (uint16_t)value;

    lsb[0] = (uint8_t)(u);          /* LSB at the lower address */
    lsb[1] = (uint8_t)(u >> 8);     /* MSB at the next address up */
}

void MAP_PackUInt16(uint16_t u, uint8_t *lsb)
{
    

    lsb[0] = (uint8_t)(u);          /* LSB at the lower address */
    lsb[1] = (uint8_t)(u >> 8);     /* MSB at the next address up */
}

int16_t MAP_UnpackInt16(const uint8_t *lsb)
{
    return (int16_t)((uint16_t)lsb[0] | ((uint16_t)lsb[1] << 8));
}

uint16_t MAP_UnpackUInt16(const uint8_t *lsb)
{
    return (uint16_t)(lsb[0] | (lsb[1] << 8));
}