/*
 * bq40z50.c - TI BQ40Z50-R2 battery gauge driver (SMBus on I2C2 master).
 *
 * Transport idiom follows lis2dw12.c: blocking TRB transactions on the
 * shared I2C2 bus, but with bounded timeouts so a wedged bus cannot hang
 * the bring-up jig. Byte sequences mirror bq40z50_setup.py, which is
 * hardware-proven against this pack from the Jetson.
 */

#include "../header/bq40z50.h"
#include "../header/i2c2.h"
#include "../header/uart1.h"
#include <string.h>
#include <xc.h>
#define FCY 16000000UL
#include <libpic30.h>

/* Inter-transaction settle times. The Python reference used 50 ms/200 ms;
 * the gauge needs far less, but stay generous - this is a jig, not a
 * control loop. */
#define BQ_T_CMD_MS        10
#define BQ_T_DF_WRITE_MS   200
/* 100 us ticks. A whole transaction at 50 kHz is ~1 ms and the SMBus slave
 * bus-timeout is 35 ms max, so 100 ms is ample headroom while still failing
 * fast enough that retries stay responsive. */
#define BQ_T_PENDING_MAX   1000

/* A gauge waking from SLEEP can NACK the transaction that wakes it, so
 * every bus operation is retried (per the MCC driver's own guidance for
 * busy slaves). */
#define BQ_RETRY_MAX       5
#define BQ_T_RETRY_MS      10

/* MAC block responses: 1 count byte + 2 echo bytes + up to 32 data bytes */
#define BQ_BLOCK_RAW_MAX   37

static void bq_delay_ms(uint16_t ms)
{
    while (ms--)
    {
        __delay32(FCY / 1000ul);
        ClrWdt();
    }
}

/* ---------------- SMBus transport ---------------- */

/* Debugger aid: final I2C2_MESSAGE_STATUS of the most recent transaction.
 * 0=FAIL 1=PENDING(timed out) 2=COMPLETE 3=STUCK_START 4=ADDRESS_NO_ACK
 * 5=DATA_NO_ACK 6=LOST_STATE */
volatile uint8_t bq_last_i2c_status;

static bool bq_wait(volatile I2C2_MESSAGE_STATUS *status)
{
    uint16_t t;
    for (t = 0; *status == I2C2_MESSAGE_PENDING; t++)
    {
        if (t >= BQ_T_PENDING_MAX)
            break;
        __delay32(FCY / 10000ul);   /* 100 us */
        ClrWdt();
    }
    bq_last_i2c_status = (uint8_t)*status;
    return (*status == I2C2_MESSAGE_COMPLETE);
}

volatile uint16_t bq_dbg_bus_recoveries;   /* how often the bus needed resetting */

/* Guard: the unwedge verifies itself with a real read, and a failing read
 * escalates to an unwedge - without this they would recurse. It also marks
 * recoveries as "expected settling" rather than genuine bus faults. */
static bool bq_in_unwedge = false;

/* Did the last failure leave the bus/driver broken, as opposed to the slave
 * simply answering "no"? A clean NACK means the transaction ran to completion
 * and the driver is healthy - retrying immediately is fine. A timeout, FAIL,
 * stuck start or lost state means the peripheral never finished. */
static bool bq_needs_recovery(void)
{
    switch (bq_last_i2c_status)
    {
        case I2C2_MESSAGE_PENDING:   /* our timeout fired: TRB still queued */
        case I2C2_MESSAGE_FAIL:
        case I2C2_STUCK_START:
        case I2C2_LOST_STATE:
            return true;
        default:
            return false;
    }
}

/* Recover after a wedged transaction. Critically, when our timeout fires the
 * abandoned TRB is still owned by the MCC driver: left alone, successive
 * retries fill its queue, it reports "full", and then EVERY later transaction
 * fails instantly - one bad transaction poisoning the whole run (observed as
 * i2c=1 followed by a string of i2c=0).
 *
 * I2C2_Initialize() clears the queue and the state machine and re-inits the
 * peripheral (preserving the 50 kHz BRG). The delay then allows a slave that
 * is holding the line down its SMBus bus-timeout period (25-35 ms per spec)
 * to release by itself. */
static void bq_bus_recover(void)
{
    /* Don't count settling inside the unwedge itself: its verification read
     * routinely needs a second attempt just after the bus has been poked, and
     * counting that would make "Bus resets" non-zero on every healthy run,
     * hiding the real wedges it exists to report. */
    if (!bq_in_unwedge)
        bq_dbg_bus_recoveries++;
    I2C2_Initialize();
    bq_delay_ms(50);
}

/* Bounded spin on a self-clearing I2C2CON bit. Returns false if the bus is
 * so stuck that the bit never clears, which is the one case where poking the
 * peripheral by hand could otherwise hang us. */
static bool bq_wait_bit_clear(volatile uint16_t *reg, uint16_t mask)
{
    uint16_t t;

    for (t = 0; (*reg & mask) != 0; t++)
    {
        if (t >= 2000)              /* ~20 ms at 10 us/spin */
            return false;
        __delay32(FCY / 100000ul);  /* 10 us */
        ClrWdt();
    }
    return true;
}

volatile uint8_t bq_dbg_unwedge_result;   /* 0=not run 2=bus usable after 3=still unusable */

static bool bq_read_word(uint8_t cmd, uint16_t *value);   /* defined below */

bool BQ40Z50_BusUnwedge(void)
{
    uint16_t dummy = 0;
    uint8_t i;
    bool usable;

    bq_in_unwedge = true;

    /* Known-good peripheral state; also drops any TRB the MCC driver still
     * thinks it owns. */
    I2C2_Initialize();
    bq_delay_ms(5);

    /* Clock a slave through the rest of its byte and STOP. RCEN is only
     * actioned while the master is in a transaction, so a START must come
     * first - without it the bit never self-clears (which is what made the
     * first version of this always report failure).
     *
     * Every step is best-effort: if a line really is held, some of these will
     * time out, and that is fine - we care about the clocks that DO get out,
     * not about completing a tidy transaction. */
    I2C2CONbits.SEN = 1;
    (void)bq_wait_bit_clear(&I2C2CON, 1u << 0);             /* SEN */

    for (i = 0; i < 9; i++)
    {
        I2C2CONbits.RCEN = 1;                               /* 8 clocks */
        if (!bq_wait_bit_clear(&I2C2CON, 1u << 3))           /* RCEN */
            break;
        (void)I2C2RCV;                                      /* discard */

        I2C2CONbits.ACKDT = 1;                              /* NACK */
        I2C2CONbits.ACKEN = 1;
        if (!bq_wait_bit_clear(&I2C2CON, 1u << 4))           /* ACKEN */
            break;
    }

    I2C2CONbits.PEN = 1;                                    /* STOP -> idle */
    (void)bq_wait_bit_clear(&I2C2CON, 1u << 2);             /* PEN */

    I2C2_Initialize();
    bq_delay_ms(5);

    /* Judge success by whether the bus can actually carry a transaction, not
     * by how the peripheral's control bits behaved - that is the only test
     * that means anything to the caller. Voltage() is legal in every gauge
     * security mode, so it is a fair probe. */
    usable = bq_read_word(0x09, &dummy);
    bq_dbg_unwedge_result = usable ? 2 : 3;
    bq_in_unwedge = false;
    return usable;
}

/* Between retries: reset only when the bus actually needs it. Escalates to a
 * full unwedge, because a slave holding SDA is exactly the case a peripheral
 * reset alone cannot fix - and that is the failure we actually see. */
static void bq_retry_pause(void)
{
    if (bq_needs_recovery())
    {
        bq_bus_recover();
        if (!bq_in_unwedge)                 /* never recurse into ourselves */
            (void)BQ40Z50_BusUnwedge();
    }
    else
        bq_delay_ms(BQ_T_RETRY_MS);
}

/* Plain write of raw bytes to the gauge, with wake/busy retries */
static bool bq_write(uint8_t *data, uint8_t len)
{
    uint8_t attempt;

    for (attempt = 0; attempt < BQ_RETRY_MAX; attempt++)
    {
        volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;
        I2C2_MasterWrite(data, len, BQ40Z50_I2C_ADDRESS, (I2C2_MESSAGE_STATUS *)&status);
        if (bq_wait(&status))
            return true;
        bq_retry_pause();
    }
    return false;
}

/* SBS word read: write [cmd], repeated-start read 2 bytes */
static bool bq_read_word(uint8_t cmd, uint16_t *value)
{
    uint8_t attempt;

    for (attempt = 0; attempt < BQ_RETRY_MAX; attempt++)
    {
        I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
        volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;
        uint8_t buf[2];

        I2C2_MasterWriteTRBBuild(&trb[0], &cmd, 1, BQ40Z50_I2C_ADDRESS);
        I2C2_MasterReadTRBBuild(&trb[1], buf, 2, BQ40Z50_I2C_ADDRESS);
        I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS *)&status);
        if (bq_wait(&status))
        {
            *value = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);
            return true;
        }
        bq_retry_pause();
    }
    return false;
}

/* SBS word write: [cmd, lo, hi] */
static bool bq_write_word(uint8_t cmd, uint16_t value)
{
    uint8_t buf[3];
    buf[0] = cmd;
    buf[1] = (uint8_t)(value & 0xFF);
    buf[2] = (uint8_t)(value >> 8);
    return bq_write(buf, 3);
}

/* MAC subcommand via ManufacturerAccess() 0x00 (no data returned) */
static bool bq_mac_command(uint16_t subcmd)
{
    if (!bq_write_word(BQ_CMD_MANUFACTURER_ACCESS, subcmd))
        return false;
    bq_delay_ms(BQ_T_CMD_MS);
    return true;
}

/* SMBus block write to ManufacturerBlockAccess(): [0x44, count, payload...].
 * The count byte is part of the SMBus block protocol - the Linux kernel
 * inserted it for the Python tool; here it is explicit. */
static bool bq_mac_block_write(const uint8_t *payload, uint8_t len)
{
    uint8_t buf[2 + 32];

    if (len > 32)
        return false;
    buf[0] = BQ_CMD_MANUFACTURER_BLOCK_ACCESS;
    buf[1] = len;
    memcpy(&buf[2], payload, len);
    return bq_write(buf, (uint8_t)(len + 2));
}

/* Read the response block of a MAC subcommand: block-write the subcommand
 * to 0x44, then write [0x44] + repeated-start read. First byte received is
 * the SMBus count, then the echoed subcommand, then the payload. Returns
 * payload with the echo stripped, exactly like the Python mac_block_read. */
static BQ_STATUS bq_mac_block_read(uint16_t subcmd, uint8_t *out,
                                   uint8_t out_max, uint8_t *out_len)
{
    uint8_t cmd = BQ_CMD_MANUFACTURER_BLOCK_ACCESS;
    uint8_t raw[BQ_BLOCK_RAW_MAX];
    uint8_t sub[2];
    uint8_t count, n, attempt;
    bool done = false;

    sub[0] = (uint8_t)(subcmd & 0xFF);
    sub[1] = (uint8_t)(subcmd >> 8);
    if (!bq_mac_block_write(sub, 2))
        return BQ_ERR_I2C;
    bq_delay_ms(BQ_T_CMD_MS);

    for (attempt = 0; attempt < BQ_RETRY_MAX && !done; attempt++)
    {
        I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
        volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;

        I2C2_MasterWriteTRBBuild(&trb[0], &cmd, 1, BQ40Z50_I2C_ADDRESS);
        I2C2_MasterReadTRBBuild(&trb[1], raw, BQ_BLOCK_RAW_MAX, BQ40Z50_I2C_ADDRESS);
        I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS *)&status);
        done = bq_wait(&status);
        if (!done)
            bq_retry_pause();
    }
    if (!done)
        return BQ_ERR_I2C;

    count = raw[0];
    if (count < 2 || count > (BQ_BLOCK_RAW_MAX - 1))
        return BQ_ERR_BAD_ECHO;
    if (raw[1] != sub[0] || raw[2] != sub[1])
        return BQ_ERR_BAD_ECHO;

    n = (uint8_t)(count - 2);
    if (n > out_max)
        n = out_max;
    memcpy(out, &raw[3], n);
    if (out_len != NULL)
        *out_len = n;
    return BQ_OK;
}

/* Data flash read: MAC block read with the DF address as the subcommand */
static BQ_STATUS bq_df_read_byte(uint16_t address, uint8_t *value)
{
    uint8_t buf[32];
    uint8_t len = 0;
    BQ_STATUS st = bq_mac_block_read(address, buf, sizeof(buf), &len);

    if (st != BQ_OK)
        return st;
    if (len < 1)
        return BQ_ERR_I2C;
    *value = buf[0];
    return BQ_OK;
}

/* Data flash write: block write [addr_lo, addr_hi, data...] to 0x44 */
static BQ_STATUS bq_df_write_byte(uint16_t address, uint8_t value)
{
    uint8_t payload[3];

    payload[0] = (uint8_t)(address & 0xFF);
    payload[1] = (uint8_t)(address >> 8);
    payload[2] = value;
    if (!bq_mac_block_write(payload, 3))
        return BQ_ERR_I2C;
    bq_delay_ms(BQ_T_DF_WRITE_MS);
    return BQ_OK;
}

static BQ_STATUS bq_df_read_word(uint16_t address, uint16_t *value)
{
    uint8_t buf[32];
    uint8_t len = 0;
    BQ_STATUS st = bq_mac_block_read(address, buf, sizeof(buf), &len);

    if (st != BQ_OK)
        return st;
    if (len < 2)
        return BQ_ERR_I2C;
    *value = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);
    return BQ_OK;
}

static BQ_STATUS bq_df_write_word(uint16_t address, uint16_t value)
{
    uint8_t payload[4];

    payload[0] = (uint8_t)(address & 0xFF);
    payload[1] = (uint8_t)(address >> 8);
    payload[2] = (uint8_t)(value & 0xFF);
    payload[3] = (uint8_t)(value >> 8);
    if (!bq_mac_block_write(payload, 4))
        return BQ_ERR_I2C;
    bq_delay_ms(BQ_T_DF_WRITE_MS);
    return BQ_OK;
}

/* ---------------- UART1 report helpers ---------------- */

/* UART1_Write() spins on a full TX buffer without clearing the watchdog,
 * which becomes a reset loop in the bootloadable build (WDT on, ~8.4 s).
 * Wait for room ourselves, with a bound, and drop the report rather than
 * let a stalled UART take the jig down. */
static void bq_print(const char *s)
{
    while (*s)
    {
        uint16_t guard = 0;
        while (!UART1_IsTxReady())
        {
            if (++guard >= 10000)       /* ~100 ms at 10 us/spin */
                return;
            __delay32(FCY / 100000ul);  /* 10 us */
            ClrWdt();
        }
        UART1_Write((uint8_t)*s++);
    }
}

static void bq_print_line(const char *s)
{
    bq_print(s);
    bq_print("\r\n");
}

static void bq_print_hex(uint32_t value, uint8_t digits)
{
    static const char hex[] = "0123456789ABCDEF";
    int8_t i;

    bq_print("0x");
    for (i = (int8_t)(digits - 1); i >= 0; i--)
        UART1_Write((uint8_t)hex[(value >> (4 * i)) & 0xF]);
}

static void bq_print_u16(uint16_t value)
{
    char buf[6];
    uint8_t i = 5;

    buf[5] = '\0';
    do
    {
        buf[--i] = (char)('0' + (value % 10));
        value /= 10;
    } while (value != 0 && i > 0);
    bq_print(&buf[i]);
}

/* ---------------- Device operations ---------------- */

BQ_STATUS BQ40Z50_Probe(uint16_t *device_type)
{
    uint8_t buf[4];
    uint8_t len = 0;
    BQ_STATUS st = bq_mac_block_read(BQ_MAC_DEVICE_TYPE, buf, sizeof(buf), &len);

    if (st != BQ_OK)
        return st;
    if (len < 2)
        return BQ_ERR_I2C;
    *device_type = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);
    if (*device_type != BQ_DEVICE_TYPE_EXPECTED)
        return BQ_ERR_WRONG_DEVICE;
    return BQ_OK;
}

BQ_STATUS BQ40Z50_ReadMAC32(uint16_t subcmd, uint32_t *value)
{
    uint8_t buf[4];
    uint8_t len = 0;
    BQ_STATUS st = bq_mac_block_read(subcmd, buf, sizeof(buf), &len);

    if (st != BQ_OK)
        return st;
    if (len < 4)
        return BQ_ERR_I2C;
    *value = (uint32_t)buf[0] | ((uint32_t)buf[1] << 8) |
             ((uint32_t)buf[2] << 16) | ((uint32_t)buf[3] << 24);
    return BQ_OK;
}

BQ_SEC_MODE BQ40Z50_SecurityMode(void)
{
    uint32_t op;

    if (BQ40Z50_ReadMAC32(BQ_MAC_OPERATION_STATUS, &op) != BQ_OK)
        return BQ_MODE_UNKNOWN;
    switch ((op >> 8) & 0x3)
    {
        case 0x3: return BQ_MODE_SEALED;
        case 0x2: return BQ_MODE_UNSEALED;
        case 0x1: return BQ_MODE_FULL_ACCESS;
        default:  return BQ_MODE_UNKNOWN;
    }
}

BQ_STATUS BQ40Z50_Unseal(void)
{
    BQ_SEC_MODE mode = BQ40Z50_SecurityMode();

    if (mode == BQ_MODE_UNSEALED || mode == BQ_MODE_FULL_ACCESS)
        return BQ_OK;
    if (mode == BQ_MODE_UNKNOWN)
        return BQ_ERR_I2C;

    /* Both key words must reach the gauge within 4 s (TRM 11.5.2) */
    if (!bq_mac_command(BQ_UNSEAL_KEY_WORD1))
        return BQ_ERR_I2C;
    if (!bq_mac_command(BQ_UNSEAL_KEY_WORD2))
        return BQ_ERR_I2C;
    bq_delay_ms(100);

    mode = BQ40Z50_SecurityMode();
    if (mode == BQ_MODE_UNSEALED || mode == BQ_MODE_FULL_ACCESS)
        return BQ_OK;
    return BQ_ERR_SEALED;
}

/* Single-register provisioning test. DA Configuration (DF 0x4A7D) carries
 * both markers this jig writes: CC1:CC0 = 4 cell, and NR = 1. A factory part
 * reads 0x12 (3 cell, removable), so the low three bits being set is a
 * reliable "already provisioned" signal. Masked rather than == 0x17 so the
 * unrelated bits of that byte stay free to differ.
 *
 * Deliberately does NOT unseal or write anything - it is a read-only probe,
 * cheap enough to run on every boot.
 *
 * Wakes the gauge first. DA Configuration leaves SLEEP enabled, so an idle
 * gauge naps and NACKs whatever transaction wakes it - and a data flash read
 * (ManufacturerBlockAccess) is the least forgiving kind to lead with. A plain
 * SBS word read is legal in every state, so spend one on waking up before
 * asking the real question. BringUp() opens the same way for the same reason. */
volatile uint8_t bq_dbg_prov_da;        /* DA Config byte this check read */

BQ_PROVISIONED BQ40Z50_IsProvisioned(void)
{
    uint8_t da = 0;
    uint16_t wake = 0;

    (void)bq_read_word(0x09, &wake);     /* SBS Voltage() - wake, result unused */
    bq_delay_ms(BQ_T_CMD_MS);

    if (bq_df_read_byte(BQ_DF_DA_CONFIGURATION, &da) != BQ_OK)
        return BQ_PROV_UNKNOWN;

    bq_dbg_prov_da = da;
    return ((da & (BQ_DA_CELL_COUNT_4S | BQ_DA_NR)) ==
            (BQ_DA_CELL_COUNT_4S | BQ_DA_NR)) ? BQ_PROV_YES : BQ_PROV_NO;
}

BQ_STATUS BQ40Z50_EnsureDAConfig(uint8_t *da_config_out)
{
    uint8_t current, target, readback;
    BQ_STATUS st = bq_df_read_byte(BQ_DF_DA_CONFIGURATION, &current);

    if (st != BQ_OK)
        return st;

    target = (uint8_t)((current & ~BQ_DA_CELL_COUNT_MASK) |
                       BQ_DA_CELL_COUNT_4S | BQ_DA_NR);
    if (da_config_out != NULL)
        *da_config_out = target;
    if (target == current)
        return BQ_OK;

    st = bq_df_write_byte(BQ_DF_DA_CONFIGURATION, target);
    if (st != BQ_OK)
        return st;
    st = bq_df_read_byte(BQ_DF_DA_CONFIGURATION, &readback);
    if (st != BQ_OK)
        return st;
    if (readback != target)
        return BQ_ERR_DF_VERIFY;
    return BQ_OK;
}

BQ_STATUS BQ40Z50_EnableFETs(uint32_t *op_status_out)
{
    uint8_t buf[2];
    uint8_t len = 0;
    uint16_t mfg;
    BQ_STATUS st = bq_mac_block_read(BQ_MAC_MANUFACTURING_STATUS, buf,
                                     sizeof(buf), &len);

    if (st != BQ_OK)
        return st;
    if (len < 2)
        return BQ_ERR_I2C;
    mfg = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);

    if (!(mfg & BQ_MFG_FET_EN))
    {
        /* MAC 0x0022 is a toggle - only send when FET_EN is clear */
        if (!bq_mac_command(BQ_MAC_FET_CONTROL))
            return BQ_ERR_I2C;
        bq_delay_ms(100);

        st = bq_mac_block_read(BQ_MAC_MANUFACTURING_STATUS, buf, sizeof(buf), &len);
        if (st != BQ_OK)
            return st;
        mfg = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);
        if (!(mfg & BQ_MFG_FET_EN))
            return BQ_ERR_FET;
    }

    if (op_status_out != NULL)
        return BQ40Z50_ReadMAC32(BQ_MAC_OPERATION_STATUS, op_status_out);
    return BQ_OK;
}

/* BENCH ONLY: no thermistors fitted on prototype packs, so the factory
 * Temperature Enable (TS1+TS2) reads open inputs as frozen and latches
 * under-temperature protection (SafetyStatus[UTD]), holding DSG off.
 * Point the gauge at its internal die sensor instead - protections then
 * work from a real temperature. Rewrite for production thermistors. */
BQ_STATUS BQ40Z50_EnsureTempConfigBench(void)
{
    uint8_t v;
    BQ_STATUS st = bq_df_read_byte(BQ_DF_TEMPERATURE_ENABLE, &v);

    if (st != BQ_OK)
        return st;
    if (v != BQ_TEMP_ENABLE_BENCH)
    {
        st = bq_df_write_byte(BQ_DF_TEMPERATURE_ENABLE, BQ_TEMP_ENABLE_BENCH);
        if (st != BQ_OK)
            return st;
        st = bq_df_read_byte(BQ_DF_TEMPERATURE_ENABLE, &v);
        if (st != BQ_OK)
            return st;
        if (v != BQ_TEMP_ENABLE_BENCH)
            return BQ_ERR_DF_VERIFY;
    }

    st = bq_df_read_byte(BQ_DF_TEMPERATURE_MODE, &v);
    if (st != BQ_OK)
        return st;
    if (v != BQ_TEMP_MODE_BENCH)
    {
        st = bq_df_write_byte(BQ_DF_TEMPERATURE_MODE, BQ_TEMP_MODE_BENCH);
        if (st != BQ_OK)
            return st;
        st = bq_df_read_byte(BQ_DF_TEMPERATURE_MODE, &v);
        if (st != BQ_OK)
            return st;
        if (v != BQ_TEMP_MODE_BENCH)
            return BQ_ERR_DF_VERIFY;
    }
    return BQ_OK;
}

/* Guarantee the FETs stay enabled across gauge resets AND the eventual seal
 * command: both reload ManufacturingStatus from data flash Mfg Status Init
 * (0x4600). MAC 0x0022 is documented to copy FET_EN there when unsealed,
 * but this verifies it and writes the bit explicitly if the copy is not
 * present. */
BQ_STATUS BQ40Z50_EnsureFETPersist(uint16_t *mfg_init_out)
{
    uint16_t init, readback;
    BQ_STATUS st = bq_df_read_word(BQ_DF_MFG_STATUS_INIT, &init);

    if (st != BQ_OK)
        return st;
    if (mfg_init_out != NULL)
        *mfg_init_out = init;
    if (init & BQ_MFG_FET_EN)
        return BQ_OK;

    st = bq_df_write_word(BQ_DF_MFG_STATUS_INIT, init | BQ_MFG_FET_EN);
    if (st != BQ_OK)
        return st;
    st = bq_df_read_word(BQ_DF_MFG_STATUS_INIT, &readback);
    if (st != BQ_OK)
        return st;
    if (!(readback & BQ_MFG_FET_EN))
        return BQ_ERR_DF_VERIFY;
    if (mfg_init_out != NULL)
        *mfg_init_out = readback;
    return BQ_OK;
}

BQ_STATUS BQ40Z50_ReadCellVoltages(uint16_t mv[4])
{
    static const uint8_t cmds[4] = { BQ_CMD_CELL_VOLTAGE_1, BQ_CMD_CELL_VOLTAGE_2,
                                     BQ_CMD_CELL_VOLTAGE_3, BQ_CMD_CELL_VOLTAGE_4 };
    uint8_t i;

    for (i = 0; i < 4; i++)
    {
        if (!bq_read_word(cmds[i], &mv[i]))
            return BQ_ERR_I2C;
        bq_delay_ms(BQ_T_CMD_MS);
    }
    return BQ_OK;
}

BQ_STATUS BQ40Z50_Seal(void)
{
    if (!bq_mac_command(BQ_MAC_SEAL_DEVICE))
        return BQ_ERR_I2C;
    bq_delay_ms(100);
    return (BQ40Z50_SecurityMode() == BQ_MODE_SEALED) ? BQ_OK : BQ_ERR_SEALED;
}

/* ---------------- Bring-up sequence ---------------- */

/* Debugger breadcrumbs: watch these by name with the serial port dead.
 * bq_dbg_step: 1=entered 2=SBS voltage read OK 3=probe OK 4=unsealed
 *              5=DA config OK 6=FETs OK 7=cells read OK 8=complete */
volatile uint8_t  bq_dbg_step;
volatile uint8_t  bq_dbg_result;        /* BQ_STATUS of last completed run */
volatile uint16_t bq_dbg_pack_mv;       /* SBS Voltage() 0x09 - works even SEALED */
volatile uint16_t bq_dbg_cell1_mv;      /* SBS CellVoltage1 0x3F - works even SEALED */
volatile uint16_t bq_dbg_device_type;
volatile uint16_t bq_dbg_mfg_init;      /* DF 0x4600 - bit 4 set = FETs persist */
volatile uint8_t  bq_dbg_da_config;     /* DF 0x4A7D readback (expect 0x17) */
volatile uint32_t bq_dbg_op_status;     /* bit1 DSG, bit2 CHG, bit13 XDSG, bit14 XCHG */
volatile uint32_t bq_dbg_safety_status; /* nonzero = protection active */
volatile uint32_t bq_dbg_pf_status;     /* nonzero = permanent fail latched */
volatile uint16_t bq_dbg_temp_01K;      /* SBS Temperature(), 0.1 K (2950 = 22 C) */

static const char *bq_mode_name(BQ_SEC_MODE mode)
{
    switch (mode)
    {
        case BQ_MODE_SEALED:      return "SEALED";
        case BQ_MODE_UNSEALED:    return "UNSEALED";
        case BQ_MODE_FULL_ACCESS: return "FULL ACCESS";
        default:                  return "UNKNOWN";
    }
}

BQ_STATUS BQ40Z50_BringUp(void)
{
    uint16_t device_type = 0;
    uint16_t mv[4];
    uint32_t op = 0, safety = 0, total;
    uint8_t da_config = 0;
    uint8_t i;
    BQ_STATUS st;

    BQ_STATUS worst = BQ_OK;   /* first error seen; steps keep going anyway */

    bq_dbg_step = 1;
    bq_dbg_result = 0xFF;
    bq_last_i2c_status = 0xEE;  /* distinguish "never ran" from MESSAGE_FAIL(0) */

    bq_print_line("");
    bq_print_line("BQ40Z50 bring-up:");

    /* SBS sanity first: plain word reads are legal in ALL security modes and
     * never touch ManufacturerBlockAccess. If these fail, the problem is
     * transport/electrical, not sealing. */
    {
        uint16_t v = 0;
        if (bq_read_word(0x09, &v))            /* SBS Voltage(), mV */
        {
            bq_dbg_pack_mv = v;
            if (bq_read_word(BQ_CMD_CELL_VOLTAGE_1, &v))
                bq_dbg_cell1_mv = v;
            bq_dbg_step = 2;
            bq_print("  SBS Voltage: ");
            bq_print_u16(bq_dbg_pack_mv);
            bq_print_line(" mV");
        }
        else
        {
            bq_print_line("  ** SBS WORD READ FAILED (transport) **");
            bq_dbg_result = BQ_ERR_I2C;
            return BQ_ERR_I2C;
        }
    }

    st = BQ40Z50_Probe(&device_type);
    if (st != BQ_OK)
    {
        /* A SEALED gauge rejects ManufacturerBlockAccess (0x44) outright
         * (data NACK), so the probe cannot even ask its security mode. The
         * unseal keys are plain ManufacturerAccess (0x00) word writes, which
         * SEALED mode accepts - send them blind and probe again. Harmless if
         * the part was already unsealed (unknown MAC words are ignored). */
        bq_print_line("  Probe rejected - assuming SEALED, sending unseal keys");
        bq_mac_command(BQ_UNSEAL_KEY_WORD1);
        bq_mac_command(BQ_UNSEAL_KEY_WORD2);
        bq_delay_ms(100);
        st = BQ40Z50_Probe(&device_type);
    }
    bq_dbg_device_type = device_type;
    bq_print("  Device type: ");
    bq_print_hex(device_type, 4);
    bq_print_line(st == BQ_OK ? "" : "  ** PROBE FAILED **");
    if (st != BQ_OK)
    {
        bq_dbg_result = (uint8_t)st;
        return st;
    }
    bq_dbg_step = 3;

    /* Once per jig boot: reset the gauge to drop any latched FUSE drive or
     * stale protection state left from before provisioning (a latched FUSE
     * holds every FET off even with SafetyStatus clear). All our settings
     * reload from data flash, so the reset costs nothing. Safe on the bench:
     * the board is not powered through the pack FETs. */
    {
        static bool gauge_reset_done = false;
        if (!gauge_reset_done)
        {
            gauge_reset_done = true;
            bq_print_line("  Device reset (clearing latched FUSE/protections)...");
            bq_mac_command(BQ_MAC_DEVICE_RESET);
            bq_delay_ms(2000);      /* gauge re-init */
        }
    }

    /* From here on, every step is idempotent and attempted regardless of
     * earlier failures: on this bench the bus drops out intermittently, so
     * aborting a run throws away progress. Each step lands whenever it gets
     * a clean window; 'worst' carries the first error for the caller. */
    bq_print("  Security mode: ");
    bq_print_line(bq_mode_name(BQ40Z50_SecurityMode()));
    st = BQ40Z50_Unseal();
    if (st != BQ_OK)
    {
        bq_print_line("  ** UNSEAL FAILED **");
        if (worst == BQ_OK) worst = st;
    }
    else
        bq_dbg_step = 4;

    st = BQ40Z50_EnsureDAConfig(&da_config);
    bq_dbg_da_config = da_config;
    bq_print("  DA Configuration: ");
    bq_print_hex(da_config, 2);
    bq_print_line(st == BQ_OK ? " (4 cell, NR)" : "  ** DF WRITE FAILED **");
    if (st != BQ_OK)
    {
        if (worst == BQ_OK) worst = st;
    }
    else
        bq_dbg_step = 5;

    st = BQ40Z50_EnsureTempConfigBench();
    bq_print(st == BQ_OK ? "  Temp source: internal (bench, no thermistors)"
                         : "  ** TEMP CONFIG FAILED **");
    bq_print_line("");
    if (st != BQ_OK && worst == BQ_OK)
        worst = st;
    {
        uint16_t t01k = 0;
        if (bq_read_word(0x08, &t01k))       /* SBS Temperature(), 0.1 K */
            bq_dbg_temp_01K = t01k;
    }

    st = BQ40Z50_EnableFETs(&op);
    if (st != BQ_OK)
    {
        bq_print_line("  ** FET ENABLE FAILED **");
        if (worst == BQ_OK) worst = st;
    }
    else
    {
        bq_dbg_step = 6;
        bq_dbg_op_status = op;
        bq_print("  FETs: CHG=");
        bq_print((op & BQ_OP_CHG) ? "on" : "off");
        bq_print(" DSG=");
        bq_print((op & BQ_OP_DSG) ? "on" : "off");
        bq_print(" PCHG=");
        bq_print_line((op & BQ_OP_PCHG) ? "on" : "off");
        if (!(op & BQ_OP_CHG) || !(op & BQ_OP_DSG))
        {
            uint32_t pf = 0;
            if (BQ40Z50_ReadMAC32(BQ_MAC_SAFETY_STATUS, &safety) == BQ_OK)
                bq_dbg_safety_status = safety;
            if (BQ40Z50_ReadMAC32(0x0053, &pf) == BQ_OK)   /* PFStatus */
                bq_dbg_pf_status = pf;
            bq_print("  Note: FET held off, OperationStatus=");
            bq_print_hex(op, 8);
            bq_print(" SafetyStatus=");
            bq_print_hex(safety, 8);
            bq_print(" PFStatus=");
            bq_print_hex(pf, 8);
            bq_print_line("");
        }
    }

    {
        uint16_t mfg_init = 0;
        st = BQ40Z50_EnsureFETPersist(&mfg_init);
        if (st == BQ_OK)
            bq_dbg_mfg_init = mfg_init;
        bq_print("  Mfg Status Init: ");
        bq_print_hex(mfg_init, 4);
        bq_print_line(st == BQ_OK ? " (FET_EN persistent)"
                                  : "  ** FET PERSIST FAILED **");
        if (st != BQ_OK && worst == BQ_OK)
            worst = st;
    }

    st = BQ40Z50_ReadCellVoltages(mv);
    if (st != BQ_OK)
    {
        bq_print_line("  ** CELL VOLTAGE READ FAILED **");
        bq_dbg_result = (uint8_t)((worst == BQ_OK) ? st : worst);
        return (worst == BQ_OK) ? st : worst;
    }
    bq_dbg_step = 7;
    total = 0;
    for (i = 0; i < 4; i++)
    {
        total += mv[i];
        bq_print("  Cell ");
        bq_print_u16((uint16_t)(i + 1));
        bq_print(": ");
        bq_print_u16(mv[i]);
        bq_print_line(" mV");
    }
    bq_print("  Sum: ");
    bq_print_u16((uint16_t)total);
    bq_print_line(" mV");

    bq_print_line(worst == BQ_OK ? "BQ40Z50 bring-up complete."
                                 : "BQ40Z50 bring-up finished WITH ERRORS.");
    if (worst == BQ_OK)
        bq_dbg_step = 8;
    bq_dbg_result = (uint8_t)worst;
    return worst;
}

/* ---------------- Golden image ---------------- */

static void bq_print_fail(void);        /* defined with the status report */

/* Gas gauging is only enabled once Design Capacity is known - see the
 * pack-specific block in bq40z50.h for why. */
#if BQ_PACK_DESIGN_CAPACITY_MAH > 0
#define BQ_GOLDEN_MFG_INIT   (BQ_MFG_FET_EN | BQ_MFG_GAUGE_EN)
#else
#define BQ_GOLDEN_MFG_INIT   (BQ_MFG_FET_EN)
#endif

#define BQ_GF_SKIP_IF_ZERO   0x01   /* 0 means "not configured", not a value */

typedef struct
{
    uint16_t    address;
    uint8_t     size;       /* 1 or 2 bytes */
    uint8_t     flags;
    uint16_t    value;
    const char *name;
} bq_golden_entry_t;

/* Absolute values, not read-modify-write: a golden image should leave every
 * pack in an identical, known state rather than inheriting whatever bits
 * happened to be set.
 *
 * Note that "absolute" cuts both ways: Mfg Status Init below is written whole,
 * so bits the pack arrived with but that are not named here are CLEARED. The
 * pack read 0x0310 before provisioning and now gets 0x0018 - GAUGE_EN gained,
 * bits 8 and 9 lost. Deliberate, but worth knowing when a pack behaves
 * differently after bring-up. */
static const bq_golden_entry_t bq_golden[] =
{
    /* SLEEP deliberately NOT set. Policy for this product is that the pack
     * FETs stay closed under as many conditions as possible: the unit is
     * permanently installed (hence NR), and a gauge that has dozed off will
     * not necessarily wake on the small initial load of a button press, which
     * leaves the unit apparently dead until it is put on charge.
     *
     * The cost is standby current: without SLEEP the pack self-discharges
     * faster in storage, which brings the (voltage-triggered) SHUTDOWN
     * threshold closer. That is the trade being made knowingly.
     *
     * 0x07 = 4 cell + non-removable. The R2 factory default 0x12 HAS the sleep
     * bit set, so this must be written explicitly on every pack - it is not
     * something a blank part gives you. */
    { BQ_DF_DA_CONFIGURATION,   1, 0,
      (BQ_DA_CELL_COUNT_4S | BQ_DA_NR),             "DA Config"      },
    { BQ_DF_TEMPERATURE_ENABLE, 1, 0,
      BQ_TEMP_ENABLE_BENCH,                         "Temp Enable"    },
    { BQ_DF_TEMPERATURE_MODE,   1, 0,
      BQ_TEMP_MODE_BENCH,                           "Temp Mode"      },
    { BQ_DF_MFG_STATUS_INIT,    2, 0,
      BQ_GOLDEN_MFG_INIT,                           "Mfg Status Init"},
    { BQ_DF_DESIGN_CAPACITY_MAH, 2, BQ_GF_SKIP_IF_ZERO,
      BQ_PACK_DESIGN_CAPACITY_MAH,                  "Design Cap mAh" },
    { BQ_DF_DESIGN_CAPACITY_CWH, 2, BQ_GF_SKIP_IF_ZERO,
      BQ_PACK_DESIGN_CAPACITY_CWH,                  "Design Cap cWh" },
    { BQ_DF_DESIGN_VOLTAGE,      2, BQ_GF_SKIP_IF_ZERO,
      BQ_PACK_DESIGN_VOLTAGE_MV,                    "Design Voltage" },
};

#define BQ_GOLDEN_COUNT  (sizeof(bq_golden) / sizeof(bq_golden[0]))

volatile uint8_t bq_dbg_golden_mismatch;
volatile uint8_t bq_dbg_golden_unset;

static BQ_STATUS bq_golden_read(const bq_golden_entry_t *e, uint16_t *actual)
{
    uint8_t b = 0;
    BQ_STATUS st;

    if (e->size == 1)
    {
        st = bq_df_read_byte(e->address, &b);
        *actual = b;
        return st;
    }
    return bq_df_read_word(e->address, actual);
}

BQ_STATUS BQ40Z50_VerifyGoldenImage(uint8_t *mismatches, uint8_t *unset)
{
    uint16_t actual;
    uint8_t i, bad = 0, skipped = 0;
    BQ_STATUS st, worst = BQ_OK;

    for (i = 0; i < BQ_GOLDEN_COUNT; i++)
    {
        if ((bq_golden[i].flags & BQ_GF_SKIP_IF_ZERO) && bq_golden[i].value == 0)
        {
            skipped++;
            continue;
        }
        st = bq_golden_read(&bq_golden[i], &actual);
        if (st != BQ_OK)
        {
            if (worst == BQ_OK)
                worst = st;
            bad++;                      /* unreadable counts as not verified */
            continue;
        }
        if (actual != bq_golden[i].value)
            bad++;
    }

    bq_dbg_golden_mismatch = bad;
    bq_dbg_golden_unset = skipped;
    if (mismatches != NULL)
        *mismatches = bad;
    if (unset != NULL)
        *unset = skipped;
    return worst;
}

BQ_STATUS BQ40Z50_ApplyGoldenImage(void)
{
    uint16_t actual;
    uint8_t i;
    BQ_STATUS st, worst = BQ_OK;

    for (i = 0; i < BQ_GOLDEN_COUNT; i++)
    {
        const bq_golden_entry_t *e = &bq_golden[i];

        if ((e->flags & BQ_GF_SKIP_IF_ZERO) && e->value == 0)
            continue;

        st = bq_golden_read(e, &actual);
        if (st == BQ_OK && actual == e->value)
            continue;                   /* already correct */

        st = (e->size == 1) ? bq_df_write_byte(e->address, (uint8_t)e->value)
                            : bq_df_write_word(e->address, e->value);
        if (st != BQ_OK)
        {
            if (worst == BQ_OK) worst = st;
            continue;
        }

        /* Re-read: a write that silently did not take is the failure mode
         * that matters most here. */
        st = bq_golden_read(e, &actual);
        if (st != BQ_OK)
        {
            if (worst == BQ_OK) worst = st;
        }
        else if (actual != e->value && worst == BQ_OK)
            worst = BQ_ERR_DF_VERIFY;
    }
    return worst;
}

void BQ40Z50_ReportGoldenImage(void)
{
    uint16_t actual, sbs = 0;
    uint8_t i;
    BQ_STATUS st;

    bq_print_line("");
    bq_print_line("Golden image:");

    for (i = 0; i < BQ_GOLDEN_COUNT; i++)
    {
        const bq_golden_entry_t *e = &bq_golden[i];

        bq_print("  ");
        bq_print(e->name);
        bq_print(" @");
        bq_print_hex(e->address, 4);
        bq_print(" : ");

        if ((e->flags & BQ_GF_SKIP_IF_ZERO) && e->value == 0)
        {
            bq_print_line("NOT SET - pack value required");
            continue;
        }

        st = bq_golden_read(e, &actual);
        if (st != BQ_OK)
        {
            bq_print_fail();
            continue;
        }
        bq_print_hex(actual, (uint8_t)(e->size * 2));
        if (actual == e->value)
            bq_print_line("  ok");
        else
        {
            bq_print("  MISMATCH, want ");
            bq_print_hex(e->value, (uint8_t)(e->size * 2));
            bq_print_line("");
        }
    }

    /* Byte-order sanity check. Multi-byte DF fields are only meaningful if we
     * store them the way the gauge reads them, and Design Capacity is the one
     * field we can cross-check: SBS DesignCapacity() (0x18) reports the gauge's
     * own interpretation of DF 0x48E5. If these disagree, every multi-byte
     * entry above is suspect. */
    if (bq_df_read_word(BQ_DF_DESIGN_CAPACITY_MAH, &actual) == BQ_OK &&
        bq_read_word(0x18, &sbs))
    {
        bq_print("  Byte order  : DF ");
        bq_print_u16(actual);
        bq_print(" mAh vs SBS ");
        bq_print_u16(sbs);
        bq_print_line(actual == sbs ? " mAh  ok" : " mAh  MISMATCH");
    }
}

/* ---------------- Status report ---------------- */

/* Read-only snapshot for main() to call on any pass. Each item is reported
 * independently: on this bus a single transaction can fail without the rest
 * being unavailable, and "read failed" against one line is far more useful
 * than losing the whole report. */
/* Report WHY a read failed, so the serial log is self-diagnosing without a
 * debugger attached. Codes are I2C2_MESSAGE_STATUS: 0=FAIL 1=timed out
 * 2=COMPLETE 3=STUCK_START 4=ADDRESS_NO_ACK 5=DATA_NO_ACK 6=LOST_STATE. */
static void bq_print_fail(void)
{
    bq_print("read failed (i2c=");
    bq_print_u16((uint16_t)bq_last_i2c_status);
    bq_print_line(")");
}

void BQ40Z50_ReportStatus(void)
{
    uint16_t v = 0;
    uint16_t mv[4];
    uint32_t op = 0;
    uint32_t total;
    int16_t  tenthsC;
    uint8_t  da = 0;
    uint8_t  i;
    bool     awake;

    /* Wake first: a napping gauge NACKs whatever transaction rouses it, and
     * a plain SBS read is legal in every security mode. Voltage() is also the
     * simplest possible read, so its result tells us whether the bus works at
     * all before any of the heavier transactions are attempted. */
    awake = bq_read_word(0x09, &v);
    bq_delay_ms(BQ_T_CMD_MS);

    bq_print_line("");
    bq_print_line("BQ40Z50 status:");

    bq_print("  Voltage   : ");
    if (awake)
    {
        bq_print_u16(v);
        bq_print_line(" mV");
    }
    else
        bq_print_fail();

    bq_print("  DA Config : ");
    if (bq_df_read_byte(BQ_DF_DA_CONFIGURATION, &da) == BQ_OK)
    {
        bq_dbg_da_config = da;
        bq_print_hex(da, 2);
        bq_print((da & BQ_DA_CELL_COUNT_MASK) == BQ_DA_CELL_COUNT_4S
                 ? "  4 cell" : "  NOT 4 cell");
        bq_print_line((da & BQ_DA_NR) ? ", non-removable" : ", REMOVABLE");
    }
    else
        bq_print_fail();

    bq_print("  FETs      : ");
    if (BQ40Z50_ReadMAC32(BQ_MAC_OPERATION_STATUS, &op) == BQ_OK)
    {
        bq_dbg_op_status = op;
        bq_print("CHG=");
        bq_print((op & BQ_OP_CHG) ? "on" : "off");
        bq_print(" DSG=");
        bq_print((op & BQ_OP_DSG) ? "on" : "off");
        bq_print(" PCHG=");
        bq_print((op & BQ_OP_PCHG) ? "on" : "off");
        bq_print("   OperationStatus=");
        bq_print_hex(op, 8);
        bq_print_line("");
    }
    else
        bq_print_fail();

    bq_print("  Temp      : ");
    if (bq_read_word(0x08, &v))          /* SBS Temperature(), 0.1 K */
    {
        bq_dbg_temp_01K = v;
        tenthsC = (int16_t)((int16_t)v - 2732);   /* 0.1 K -> 0.1 degC */
        if (tenthsC < 0)
        {
            bq_print("-");
            tenthsC = (int16_t)(-tenthsC);
        }
        bq_print_u16((uint16_t)(tenthsC / 10));
        bq_print(".");
        bq_print_u16((uint16_t)(tenthsC % 10));
        bq_print_line(" C");
    }
    else
        bq_print_fail();

    if (BQ40Z50_ReadCellVoltages(mv) == BQ_OK)
    {
        total = 0;
        for (i = 0; i < 4; i++)
        {
            total += mv[i];
            bq_print("  Cell ");
            bq_print_u16((uint16_t)(i + 1));
            bq_print("    : ");
            bq_print_u16(mv[i]);
            bq_print_line(" mV");
        }
        bq_print("  Pack sum  : ");
        bq_print_u16((uint16_t)total);
        bq_print_line(" mV");
    }
    else
        { bq_print("  Cells     : "); bq_print_fail(); }

    /* Non-zero means the bus wedged and had to be reset - worth knowing even
     * when every read above succeeded, since it is the early warning. */
    if (bq_dbg_bus_recoveries != 0)
    {
        bq_print("  Bus resets: ");
        bq_print_u16(bq_dbg_bus_recoveries);
        bq_print_line("");
    }
}
