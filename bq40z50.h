/*
 * bq40z50.h - TI BQ40Z50-R2 battery gauge driver (SMBus on I2C2 master).
 *
 * Production bring-up port of the hardware-proven Jetson tool
 * bq40z50_setup.py. All register/command facts are from the bq40z50-R2
 * Technical Reference Manual, TI SLUUBK0B:
 *   - Unseal: two key words to ManufacturerAccess() 0x00, second within 4 s
 *   - DA Configuration: data flash 0x4A7D (CC1:CC0 bits 1:0, NR bit 2)
 *   - FET Control: MAC 0x0022 toggles ManufacturingStatus[FET_EN]
 *   - Data flash access via ManufacturerBlockAccess() 0x44
 *   - Cell voltages: SBS 0x3F..0x3C, mV
 */

#ifndef BQ40Z50_H
#define BQ40Z50_H

#include <stdint.h>
#include <stdbool.h>

/* 7-bit SMBus address (I2C2 TRB API shifts it) */
#define BQ40Z50_I2C_ADDRESS       0x0B

/* SBS commands */
#define BQ_CMD_MANUFACTURER_ACCESS        0x00
#define BQ_CMD_MANUFACTURER_BLOCK_ACCESS  0x44
#define BQ_CMD_CELL_VOLTAGE_1     0x3F    /* mV, word reads */
#define BQ_CMD_CELL_VOLTAGE_2     0x3E
#define BQ_CMD_CELL_VOLTAGE_3     0x3D
#define BQ_CMD_CELL_VOLTAGE_4     0x3C

/* MAC subcommands */
#define BQ_MAC_DEVICE_TYPE        0x0001
#define BQ_MAC_FET_CONTROL        0x0022  /* toggles ManufacturingStatus[FET_EN] */
#define BQ_MAC_SEAL_DEVICE        0x0030
#define BQ_MAC_DEVICE_RESET       0x0041
#define BQ_MAC_SAFETY_STATUS      0x0051
#define BQ_MAC_OPERATION_STATUS   0x0054
#define BQ_MAC_MANUFACTURING_STATUS 0x0057

#define BQ_DEVICE_TYPE_EXPECTED   0x4500

/* Default unseal key (TRM 11.5.2) */
#define BQ_UNSEAL_KEY_WORD1       0x0414
#define BQ_UNSEAL_KEY_WORD2       0x3672

/* ManufacturingStatus bits */
#define BQ_MFG_FET_EN             (1u << 4)

/* OperationStatus bits (32-bit) */
#define BQ_OP_PRES                (1ul << 0)
#define BQ_OP_DSG                 (1ul << 1)   /* live FET states */
#define BQ_OP_CHG                 (1ul << 2)
#define BQ_OP_PCHG                (1ul << 3)
#define BQ_OP_XDSG                (1ul << 13)
#define BQ_OP_XCHG                (1ul << 14)

/* Data flash */
#define BQ_DF_DA_CONFIGURATION    0x4A7D  /* 1 byte */
#define BQ_DF_MFG_STATUS_INIT     0x4600  /* 2 bytes; power-up/seal-time
                                             ManufacturingStatus source -
                                             FET_EN here = FETs persistently
                                             enabled (TRM 15.3.1) */
#define BQ_DF_TEMPERATURE_ENABLE  0x4A7B  /* 1 byte; bit0 TSint, bits1-4 TS1-4 */
#define BQ_DF_TEMPERATURE_MODE    0x4A7C  /* 1 byte; per-sensor cell/FET select */

/* BENCH ONLY - no thermistors fitted: internal die sensor as the sole
 * (cell) temperature source, so under/over-temp protections see a real
 * temperature instead of an open TS input reading "frozen" (UTD trip).
 * Packs with real thermistors need these rewritten to match the design. */
#define BQ_TEMP_ENABLE_BENCH      0x01    /* TSint only */
#define BQ_TEMP_MODE_BENCH        0x00    /* everything = cell temperature */
#define BQ_DA_CELL_COUNT_MASK     0x03
#define BQ_DA_CELL_COUNT_4S       0x03    /* CC1:CC0 = 1,1 = 4 cell */
#define BQ_DA_NR                  (1u << 2) /* non-removable: ignore PRES pin */

typedef enum
{
    BQ_OK = 0,
    BQ_ERR_I2C,           /* bus transaction failed or timed out */
    BQ_ERR_BAD_ECHO,      /* MAC response did not echo the subcommand */
    BQ_ERR_WRONG_DEVICE,  /* device type != 0x4500 */
    BQ_ERR_SEALED,        /* unseal sequence did not take */
    BQ_ERR_DF_VERIFY,     /* data flash readback mismatch */
    BQ_ERR_FET            /* FET_EN did not set */
} BQ_STATUS;

typedef enum
{
    BQ_MODE_UNKNOWN = 0,
    BQ_MODE_SEALED,
    BQ_MODE_UNSEALED,
    BQ_MODE_FULL_ACCESS
} BQ_SEC_MODE;

/* Individual operations (each mirrors a proven bq40z50_setup.py function) */
BQ_STATUS   BQ40Z50_Probe(uint16_t *device_type);
BQ_SEC_MODE BQ40Z50_SecurityMode(void);
BQ_STATUS   BQ40Z50_Unseal(void);
BQ_STATUS   BQ40Z50_EnsureDAConfig(uint8_t *da_config_out);
BQ_STATUS   BQ40Z50_EnableFETs(uint32_t *op_status_out);
BQ_STATUS   BQ40Z50_EnsureFETPersist(uint16_t *mfg_init_out);
BQ_STATUS   BQ40Z50_EnsureTempConfigBench(void);
BQ_STATUS   BQ40Z50_ReadCellVoltages(uint16_t mv[4]);
BQ_STATUS   BQ40Z50_ReadMAC32(uint16_t subcmd, uint32_t *value);
BQ_STATUS   BQ40Z50_Seal(void);   /* production end step - not called by BringUp yet */

/* Full bring-up sequence: probe -> unseal -> DA config -> FETs -> voltages.
 * Progress and results are reported as text on UART1. Returns the first
 * error encountered, BQ_OK if the pack came up fully. */
BQ_STATUS   BQ40Z50_BringUp(void);

#endif /* BQ40Z50_H */
