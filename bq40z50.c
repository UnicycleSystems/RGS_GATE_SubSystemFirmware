/*
 * bq40z50.c - TI BQ40Z50-R2 battery gauge driver (SMBus on I2C2 master).
 *
 * Transport idiom follows lis2dw12.c: blocking TRB transactions on the
 * shared I2C2 bus, but with bounded timeouts so a wedged bus cannot hang
 * the bring-up jig. Byte sequences mirror bq40z50_setup.py, which is
 * hardware-proven against this pack from the Jetson.
 */

#include "bq40z50.h"
#include "RGS_MCC_Copies/i2c2.h"
#include "RGS_MCC_Copies/uart1.h"
#include <string.h>
#include <xc.h>
#define FCY 16000000UL
#include <libpic30.h>

/* Inter-transaction settle times. The Python reference used 50 ms/200 ms;
 * the gauge needs far less, but stay generous - this is a jig, not a
 * control loop. */
#define BQ_T_CMD_MS        10
#define BQ_T_DF_WRITE_MS   200
#define BQ_T_PENDING_MAX   5000     /* 100 us ticks -> 500 ms bus timeout */

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

static bool bq_wait(volatile I2C2_MESSAGE_STATUS *status)
{
    uint16_t t;
    for (t = 0; *status == I2C2_MESSAGE_PENDING; t++)
    {
        if (t >= BQ_T_PENDING_MAX)
            return false;
        __delay32(FCY / 10000ul);   /* 100 us */
        ClrWdt();
    }
    return (*status == I2C2_MESSAGE_COMPLETE);
}

/* Plain write of raw bytes to the gauge */
static bool bq_write(uint8_t *data, uint8_t len)
{
    volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;
    I2C2_MasterWrite(data, len, BQ40Z50_I2C_ADDRESS, (I2C2_MESSAGE_STATUS *)&status);
    return bq_wait(&status);
}

/* SBS word read: write [cmd], repeated-start read 2 bytes */
static bool bq_read_word(uint8_t cmd, uint16_t *value)
{
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
    volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;
    uint8_t buf[2];

    I2C2_MasterWriteTRBBuild(&trb[0], &cmd, 1, BQ40Z50_I2C_ADDRESS);
    I2C2_MasterReadTRBBuild(&trb[1], buf, 2, BQ40Z50_I2C_ADDRESS);
    I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS *)&status);
    if (!bq_wait(&status))
        return false;

    *value = (uint16_t)buf[0] | ((uint16_t)buf[1] << 8);
    return true;
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
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];
    volatile I2C2_MESSAGE_STATUS status = I2C2_MESSAGE_PENDING;
    uint8_t cmd = BQ_CMD_MANUFACTURER_BLOCK_ACCESS;
    uint8_t raw[BQ_BLOCK_RAW_MAX];
    uint8_t sub[2];
    uint8_t count, n;

    sub[0] = (uint8_t)(subcmd & 0xFF);
    sub[1] = (uint8_t)(subcmd >> 8);
    if (!bq_mac_block_write(sub, 2))
        return BQ_ERR_I2C;
    bq_delay_ms(BQ_T_CMD_MS);

    I2C2_MasterWriteTRBBuild(&trb[0], &cmd, 1, BQ40Z50_I2C_ADDRESS);
    I2C2_MasterReadTRBBuild(&trb[1], raw, BQ_BLOCK_RAW_MAX, BQ40Z50_I2C_ADDRESS);
    I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS *)&status);
    if (!bq_wait(&status))
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

/* ---------------- UART1 report helpers ---------------- */

static void bq_print(const char *s)
{
    while (*s)
        UART1_Write((uint8_t)*s++);
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

    bq_print_line("");
    bq_print_line("BQ40Z50 bring-up:");

    st = BQ40Z50_Probe(&device_type);
    bq_print("  Device type: ");
    bq_print_hex(device_type, 4);
    bq_print_line(st == BQ_OK ? "" : "  ** PROBE FAILED **");
    if (st != BQ_OK)
        return st;

    bq_print("  Security mode: ");
    bq_print_line(bq_mode_name(BQ40Z50_SecurityMode()));
    st = BQ40Z50_Unseal();
    if (st != BQ_OK)
    {
        bq_print_line("  ** UNSEAL FAILED (non-default key?) **");
        return st;
    }

    st = BQ40Z50_EnsureDAConfig(&da_config);
    bq_print("  DA Configuration: ");
    bq_print_hex(da_config, 2);
    bq_print_line(st == BQ_OK ? " (4 cell, NR)" : "  ** DF WRITE FAILED **");
    if (st != BQ_OK)
        return st;

    st = BQ40Z50_EnableFETs(&op);
    if (st != BQ_OK)
    {
        bq_print_line("  ** FET ENABLE FAILED **");
        return st;
    }
    bq_print("  FETs: CHG=");
    bq_print((op & BQ_OP_CHG) ? "on" : "off");
    bq_print(" DSG=");
    bq_print((op & BQ_OP_DSG) ? "on" : "off");
    bq_print(" PCHG=");
    bq_print_line((op & BQ_OP_PCHG) ? "on" : "off");
    if (!(op & BQ_OP_CHG) || !(op & BQ_OP_DSG))
    {
        BQ40Z50_ReadMAC32(BQ_MAC_SAFETY_STATUS, &safety);
        bq_print("  Note: FET held off, OperationStatus=");
        bq_print_hex(op, 8);
        bq_print(" SafetyStatus=");
        bq_print_hex(safety, 8);
        bq_print_line("");
    }

    st = BQ40Z50_ReadCellVoltages(mv);
    if (st != BQ_OK)
    {
        bq_print_line("  ** CELL VOLTAGE READ FAILED **");
        return st;
    }
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

    bq_print_line("BQ40Z50 bring-up complete.");
    return BQ_OK;
}
