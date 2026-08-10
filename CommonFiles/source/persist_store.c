/**
 * @file    persist_store.c
 * @brief   Two-bank persistent store in program flash. See persist_store.h.
 *
 * On-flash layout, per bank. Two bytes are stored per instruction word (the
 * low 16 bits); the upper byte of each word is left erased. That wastes a
 * third of the space but keeps addressing trivial, and a bank is one 512
 * instruction erase page = 1024 usable bytes, against 528 needed.
 *
 *      offset  size  field
 *      0       2     magic          PERSIST_MAGIC
 *      2       4     sequence       incremented on every commit
 *      6       2     length         payload bytes, always PERSIST_SIZE
 *      8       2     crc            CRC-16/CCITT-FALSE over the payload
 *      10      6     reserved       erased
 *      16      512   payload
 *
 * A bank counts as valid only when magic, length and CRC all agree, so a
 * commit interrupted part way through can never be mistaken for a good one.
 */

#include "../header/persist_store.h"
#include "../header/flash.h"
#include "../header/MemoryMap.h"      /* EMULATE_EEPROM_Memory + its size */
#include <string.h>

/* The mirror must fit the store, and the store's view of the register file
 * must match the register file's own. EMULATE_EEPROM_SIZE is unfortunately
 * defined in two places (MemoryMap.h and i2c1.h) - if they ever disagree this
 * is where it would silently corrupt, so fail the build instead. */
#if (PERSIST_MIRROR_FIRST + PERSIST_MIRROR_BYTES) > PERSIST_SIZE
#error "persist mirror span does not fit PERSIST_SIZE"
#endif
#if PERSIST_MIRROR_BYTES != EMULATE_EEPROM_SIZE
#error "PERSIST_MIRROR_BYTES disagrees with EMULATE_EEPROM_SIZE"
#endif

#define PERSIST_MAGIC        0xA5C3u
#define PERSIST_HEADER_SIZE  16u
#define PERSIST_IMAGE_SIZE   (PERSIST_HEADER_SIZE + PERSIST_SIZE)   /* 528 */

/* Row writes move 64 instructions at a time = 128 bytes at 2 bytes/word. */
#define PERSIST_BYTES_PER_ROW (FLASH_WRITE_ROW_SIZE_IN_INSTRUCTIONS * 2u)
#define PERSIST_ROWS          ((PERSIST_IMAGE_SIZE + PERSIST_BYTES_PER_ROW - 1u) \
                               / PERSIST_BYTES_PER_ROW)             /* 5 */

static uint8_t  shadow[PERSIST_SIZE];
static uint32_t liveBank;        /* flash address of the bank currently live */
static uint32_t liveSequence;    /* its sequence number */
static bool     shadowValid;     /* a good bank was loaded                   */
static uint16_t shadowCrc;       /* CRC of the shadow as last read/written   */

/* CRC-16/CCITT-FALSE: init 0xFFFF, poly 0x1021, no reflection, no final xor. */
static uint16_t Crc16(const uint8_t *data, uint16_t length)
{
    uint16_t crc = 0xFFFFu;
    uint16_t i;
    uint8_t  bit;

    for (i = 0; i < length; i++)
    {
        crc ^= (uint16_t)data[i] << 8;
        for (bit = 0; bit < 8u; bit++)
        {
            if (crc & 0x8000u)
                crc = (uint16_t)((crc << 1) ^ 0x1021u);
            else
                crc = (uint16_t)(crc << 1);
        }
    }
    return crc;
}

/* Two payload bytes live in each instruction word, so byte offset n sits in
 * the word at bankAddress + (n & ~1), which is 2 PC units per word pair. */
static uint16_t ReadWord(uint32_t bankAddress, uint16_t byteOffset)
{
    return FLASH_ReadWord16(bankAddress + byteOffset);
}

/* Read one bank's header and payload into caller storage.
 * Returns true only if magic, length and CRC all check out. */
static bool ReadBank(uint32_t bankAddress, uint8_t *payload, uint32_t *sequence)
{
    uint16_t magic, length, storedCrc;
    uint32_t seqLow, seqHigh;
    uint16_t i, word;

    magic = ReadWord(bankAddress, 0u);
    if (magic != PERSIST_MAGIC)
        return false;

    seqLow   = ReadWord(bankAddress, 2u);
    seqHigh  = ReadWord(bankAddress, 4u);
    length   = ReadWord(bankAddress, 6u);
    storedCrc = ReadWord(bankAddress, 8u);

    if (length != PERSIST_SIZE)
        return false;

    for (i = 0; i < PERSIST_SIZE; i += 2u)
    {
        word = ReadWord(bankAddress, (uint16_t)(PERSIST_HEADER_SIZE + i));
        payload[i]      = (uint8_t)(word & 0x00FFu);
        payload[i + 1u] = (uint8_t)(word >> 8);
    }

    if (Crc16(payload, PERSIST_SIZE) != storedCrc)
        return false;

    *sequence = ((uint32_t)seqHigh << 16) | seqLow;
    return true;
}

bool PERSIST_Load(void)
{
    uint8_t  payloadA[PERSIST_SIZE];
    uint32_t seqA = 0, seqB = 0;
    bool     okA, okB;

    okA = ReadBank(PERSIST_BANK_A, payloadA, &seqA);

    /* Read B straight into the shadow to avoid a second 512-byte buffer;
     * if A turns out to be the newer one it is copied over afterwards. */
    okB = ReadBank(PERSIST_BANK_B, shadow, &seqB);

    if (okA && (!okB || (int32_t)(seqA - seqB) > 0))
    {
        memcpy(shadow, payloadA, PERSIST_SIZE);
        liveBank     = PERSIST_BANK_A;
        liveSequence = seqA;
        shadowValid  = true;
    }
    else if (okB)
    {
        liveBank     = PERSIST_BANK_B;
        liveSequence = seqB;
        shadowValid  = true;
    }
    else
    {
        /* Blank device, or both banks bad. Start from zeros and let the first
         * commit land in bank A. */
        memset(shadow, 0, PERSIST_SIZE);
        liveBank     = PERSIST_BANK_B;   /* so spare == bank A */
        liveSequence = 0;
        shadowValid  = false;
    }

    shadowCrc = Crc16(shadow, PERSIST_SIZE);
    return shadowValid;
}

uint8_t PERSIST_GetByte(uint16_t offset)
{
    return (offset < PERSIST_SIZE) ? shadow[offset] : 0u;
}

void PERSIST_SetByte(uint16_t offset, uint8_t value)
{
    if (offset < PERSIST_SIZE)
        shadow[offset] = value;
}

void PERSIST_GetBlock(uint16_t offset, uint8_t *dst, uint16_t length)
{
    if (offset >= PERSIST_SIZE)
        return;
    if ((uint32_t)offset + length > PERSIST_SIZE)
        length = (uint16_t)(PERSIST_SIZE - offset);
    memcpy(dst, &shadow[offset], length);
}

void PERSIST_SetBlock(uint16_t offset, const uint8_t *src, uint16_t length)
{
    if (offset >= PERSIST_SIZE)
        return;
    if ((uint32_t)offset + length > PERSIST_SIZE)
        length = (uint16_t)(PERSIST_SIZE - offset);
    memcpy(&shadow[offset], src, length);
}

bool PERSIST_IsDirty(void)
{
    return (!shadowValid) || (Crc16(shadow, PERSIST_SIZE) != shadowCrc);
}

bool PERSIST_LoadToEeprom(void)
{
    bool valid = PERSIST_Load();

    /* Only overwrite the register file when there was something real to
     * restore. On a blank device the caller's defaults are worth more than a
     * block of zeros - and the Jetson would otherwise read zeros as if they
     * had been configured. */
    if (valid)
        memcpy(&EMULATE_EEPROM_Memory[PERSIST_MIRROR_FIRST],
               &shadow[PERSIST_MIRROR_FIRST],
               PERSIST_MIRROR_BYTES);

    return valid;
}

bool PERSIST_SaveFromEeprom(void)
{
    /* Nothing new to say -> no erase, no write. Enforced here rather than
     * left to each caller: flash endurance is finite (~10k erase cycles per
     * page), and a host that repeats a save command - or a jig that is power
     * cycled repeatedly - would otherwise burn a cycle rewriting identical
     * data. Reports success because the store already holds what was asked
     * for. A blank device never matches, so first provisioning always writes. */
    if (PERSIST_EepromMatchesStore())
        return true;

    memcpy(&shadow[PERSIST_MIRROR_FIRST],
           &EMULATE_EEPROM_Memory[PERSIST_MIRROR_FIRST],
           PERSIST_MIRROR_BYTES);

    return PERSIST_Commit();
}

bool PERSIST_EepromMatchesStore(void)
{
    /* A blank device has no stored copy, so nothing can match it - say so
     * rather than comparing against the zeroed shadow and reporting a false
     * match on an all-zero register file. */
    if (!shadowValid)
        return false;

    return (memcmp(&shadow[PERSIST_MIRROR_FIRST],
                   &EMULATE_EEPROM_Memory[PERSIST_MIRROR_FIRST],
                   PERSIST_MIRROR_BYTES) == 0);
}

bool PERSIST_Commit(void)
{
    uint32_t spareBank;
    uint32_t newSequence;
    uint16_t rowBuffer[FLASH_WRITE_ROW_SIZE_IN_INSTRUCTIONS];
    uint16_t crc;
    uint16_t row, i, byteIndex;
    uint8_t  verifyPayload[PERSIST_SIZE];
    uint32_t verifySequence = 0;

    spareBank = (liveBank == PERSIST_BANK_A)
                 ? PERSIST_BANK_B
                 : PERSIST_BANK_A;

    newSequence = liveSequence + 1u;
    crc = Crc16(shadow, PERSIST_SIZE);

    FLASH_Unlock(FLASH_UNLOCK_KEY);

    if (!FLASH_ErasePage(spareBank))
    {
        FLASH_Lock();
        return false;
    }

    /* Build and write one row at a time so only 128 bytes of scratch is
     * needed rather than a second copy of the whole image. */
    for (row = 0; row < PERSIST_ROWS; row++)
    {
        for (i = 0; i < FLASH_WRITE_ROW_SIZE_IN_INSTRUCTIONS; i++)
        {
            byteIndex = (uint16_t)((row * PERSIST_BYTES_PER_ROW) + (i * 2u));

            if (byteIndex < PERSIST_HEADER_SIZE)
            {
                switch (byteIndex)
                {
                case 0:  rowBuffer[i] = PERSIST_MAGIC;                        break;
                case 2:  rowBuffer[i] = (uint16_t)(newSequence & 0xFFFFu);    break;
                case 4:  rowBuffer[i] = (uint16_t)(newSequence >> 16);        break;
                case 6:  rowBuffer[i] = PERSIST_SIZE;                         break;
                case 8:  rowBuffer[i] = crc;                                  break;
                default: rowBuffer[i] = 0xFFFFu;                              break;
                }
            }
            else
            {
                uint16_t p = (uint16_t)(byteIndex - PERSIST_HEADER_SIZE);

                if (p < PERSIST_SIZE)
                    rowBuffer[i] = (uint16_t)shadow[p]
                                 | (uint16_t)((uint16_t)shadow[p + 1u] << 8);
                else
                    rowBuffer[i] = 0xFFFFu;      /* tail padding */
            }
        }

        if (!FLASH_WriteRow16(spareBank + (row * PERSIST_BYTES_PER_ROW), rowBuffer))
        {
            FLASH_Lock();
            return false;
        }
    }

    FLASH_Lock();

    /* Read back through the same path a load would use. Only once this passes
     * is the new bank treated as live; until then the old one still is. */
    if (!ReadBank(spareBank, verifyPayload, &verifySequence))
        return false;

    if ((verifySequence != newSequence) ||
        (memcmp(verifyPayload, shadow, PERSIST_SIZE) != 0))
        return false;

    liveBank     = spareBank;
    liveSequence = newSequence;
    shadowValid  = true;
    shadowCrc    = crc;
    return true;
}
