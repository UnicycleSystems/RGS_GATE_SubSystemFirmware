#ifndef ARRAYUTILS_H
#define ARRAYUTILS_H

#include <stdint.h>     /* int16_t / uint8_t used below - without this the
                         * compiler does not know they are types and reports
                         * "expected ')' before 'value'" on the first
                         * prototype. A header must be able to compile on its
                         * own, not rely on whoever includes it first. */

/* Pack/unpack a 16-bit value in the register file's byte order.
 *
 * Every 16-bit field in the map is stored LSB FIRST: the _LSB_Addr label is
 * the LOWER address and _MSB_Addr the one above it. Pass the address of the
 * LSB byte:
 *
 *      MAP_PackInt16(x, &EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]);
 *      x = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]);
 *
 * Writing the pair by hand is easy to get wrong in one place and right in
 * another - the accelerometer Z pair was packed big-endian while X and Y were
 * little-endian, and the only symptom was one axis reading nonsense.
 */
void    MAP_PackInt16(int16_t value, uint8_t *lsb);
int16_t MAP_UnpackInt16(const uint8_t *lsb);

#endif /*ARRAYUTILS_H*/
