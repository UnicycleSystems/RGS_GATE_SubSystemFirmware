#include "../header/InitEEpromVals.h"
#include "../header/EEpromBlockLabels.h"
#include <stdint.h>
#include "../header/MemoryMap.h"

/* Baseline contents of the emulated EEPROM, shared by every program in the
 * suite so they all start from the same table.
 *
 * WHY THE VERSION IS PASSED IN RATHER THAN INCLUDED
 *     firmware_version.h lives in each PROJECT directory and says something
 *     different in each one. A file in CommonFiles cannot include it - the
 *     convention here is explicit relative includes with no -I, so there is no
 *     search path that would reach the right copy. Each main() already
 *     includes its own, so it passes the four bytes in.
 */


/* Firmware-owned values only: the table version, the running firmware version
 * and the tick rate. Every one of these is a property of THIS BUILD or of the
 * hardware, never of the individual unit, so this function is safe to call
 * after PERSIST_LoadToEeprom() has restored a stored block - and should be,
 * so a provisioned board reports the version it is RUNNING rather than the one
 * that was current when it was provisioned.
 *
 * It is idempotent: nothing here reads the table, so calling it twice (once
 * before I2C comes up, once after a restore) costs only the writes.
 *
 * NOTE: it deliberately does NOT touch the accelerometer calibration. Those
 * six bytes used to be set to zero here, which was redundant - the only
 * caller was InitEmulatedEEprom(), where ZeroEmulatedEEProm() had already
 * zeroed all 256 bytes - and would be actively wrong now, because it would
 * wipe the calibration a restore had just brought back. Zeroing belongs with
 * the zeroing, which is the defaults-only path.
 */
void PopulateSelectedEEprom(uint8_t rc, uint8_t minor, uint8_t lsb, uint8_t msb)
{
    /* Table version MUST NOT CHANGE. The table number is not up-issued for
     * purely additive changes. */
    EMULATE_EEPROM_Memory[TableVersionAddr] = TableVersion;

    /* Four bytes, MSB.LSB.Minor with the release candidate alongside; rc is
     * zero for anything that has actually been released. */
    EMULATE_EEPROM_Memory[FirmwareVersionRcAddr]    = rc;
    EMULATE_EEPROM_Memory[FirmwareVersionMinorAddr] = minor;
    EMULATE_EEPROM_Memory[FirmwareVersionLSBAddr]   = lsb;
    EMULATE_EEPROM_Memory[FirmwareVersionMSBAddr]   = msb;

    /* TODO: HARDWARE VERSION COULD GO HERE */

    /* Ticks per second: 16,000,000 = 0x00F42400, derived from the 32MHz XTAL
     * divided by 2 driving the counter. There is (will be) a mechanism to
     * update this, but a hard coded value is appropriate. */
    EMULATE_EEPROM_Memory[TicksPerSecMMSB] = (uint8_t)(0x00);
    EMULATE_EEPROM_Memory[TicksPerSecNMSB] = (uint8_t)(0xF4);
    EMULATE_EEPROM_Memory[TicksPerSecHLSB] = (uint8_t)(0x24);
    EMULATE_EEPROM_Memory[TicksPerSecLLSB] = (uint8_t)(0x00);
}


void ZeroEmulatedEEProm(void)
{
    uint16_t loop;

    for (loop = 0; loop < 256; loop++)
    {
        EMULATE_EEPROM_Memory[loop] = 0;
    }
}


/* The defaults path: wipe the table and lay down the baseline. Only for a unit
 * with nothing stored - a board that has been provisioned must be restored
 * from flash instead, or the zeroing would throw away its calibration.
 *
 * The accelerometer corrections are left at the zero that ZeroEmulatedEEProm()
 * wrote. In the absence of a calibration process those are pretty close.
 */
void InitEmulatedEEprom(uint8_t rc, uint8_t minor, uint8_t lsb, uint8_t msb)
{
    ZeroEmulatedEEProm();
    PopulateSelectedEEprom(rc, minor, lsb, msb);
}
