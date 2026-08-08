/**
 * @file    persist_store.h
 * @brief   Small block of data held in program flash, preserved across a
 *          firmware update.
 *
 * Not to be confused with EMULATE_EEPROM_Memory, which is the RAM register
 * file behind the I2C slave interface and does not survive a power cycle.
 *
 * The store lives in two erase pages above the application region
 * (BOOT_CONFIG_PERSIST_BANK_A / _B). Those addresses sit outside the
 * bootloader's programmable range, so its IsLegalAddress() refuses to erase
 * or write them and a firmware update cannot disturb the contents. The area
 * changes only when this module writes it.
 *
 * Usage is shadow-and-commit:
 *
 *      PERSIST_Load();                      // flash -> RAM, once at startup
 *      v = PERSIST_GetByte(offset);         // reads are from the shadow
 *      PERSIST_SetByte(offset, v);          // RAM only, cheap
 *      PERSIST_Commit();                    // one flash write for the lot
 *
 * Commit is blocking and takes roughly 30 ms (one page erase plus five row
 * writes). The CPU stalls for the duration of each flash operation, so
 * interrupts -- including the I2C slave -- are not serviced while it runs.
 * Call it at a quiescent point, not mid-transaction.
 */

#ifndef PERSIST_STORE_H
#define	PERSIST_STORE_H

#include <stdint.h>
#include <stdbool.h>

/** Usable payload size in bytes. The bank holds this plus a 16-byte header. */
#define PERSIST_SIZE 512u

/* Bank addresses, in PC units. Each is one 512-instruction erase page.
 *
 * These must sit ABOVE BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH in every
 * project's boot_config.h -- that is what makes the bootloader refuse to
 * erase them. Bank A begins immediately after the application region:
 *
 *      application   0x2400 - 0x9FFE   (BOOT_CONFIG_DOWNLOAD_LOW/HIGH)
 *      bank A        0xA000 - 0xA3FF
 *      bank B        0xA400 - 0xA7FF
 *      reserved      0xA800 - 0xABFA   (contains CONFIG1/CONFIG2 - never erased)
 *
 * If the application region is ever resized, these move with it and all three
 * copies of boot_config.h must be updated to match. */
#define PERSIST_BANK_A     0xA000ul
#define PERSIST_BANK_B     0xA400ul
#define PERSIST_BANK_SIZE  0x400ul

/**
 * Load the newest valid bank into the RAM shadow.
 *
 * Picks whichever bank has a good magic and CRC and the higher sequence
 * number. If neither is valid -- a blank device, or a commit that was cut
 * short before its CRC landed -- the shadow is zeroed and false is returned.
 * A false result is normal on first power-up and is not an error.
 *
 * @return true if a valid bank was found.
 */
bool PERSIST_Load(void);

/** Read a byte from the shadow. Out-of-range offsets return 0. */
uint8_t PERSIST_GetByte(uint16_t offset);

/** Write a byte to the shadow. Out-of-range offsets are ignored. RAM only --
 *  nothing reaches flash until PERSIST_Commit(). */
void PERSIST_SetByte(uint16_t offset, uint8_t value);

/** Copy a run of bytes out of the shadow. Clamped to PERSIST_SIZE. */
void PERSIST_GetBlock(uint16_t offset, uint8_t *dst, uint16_t length);

/** Copy a run of bytes into the shadow. Clamped to PERSIST_SIZE. RAM only. */
void PERSIST_SetBlock(uint16_t offset, const uint8_t *src, uint16_t length);

/**
 * Write the shadow to the spare bank.
 *
 * Erases the bank not currently live, writes the shadow with an incremented
 * sequence number and a CRC, then reads it back and verifies. The previously
 * live bank is left untouched throughout, so a reset at any point leaves at
 * least one bank intact -- either the old contents or the new, never a
 * half-written mixture.
 *
 * @return true if the new bank verified. On false the old bank is still live
 *         and the shadow is unchanged, so the caller may simply retry.
 */
bool PERSIST_Commit(void);

/** True if the shadow differs from what was last loaded or committed.
 *  Lets a caller skip a needless erase/write cycle. */
bool PERSIST_IsDirty(void);

#endif	/* PERSIST_STORE_H */
