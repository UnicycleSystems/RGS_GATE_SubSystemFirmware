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
#define BQ_MAC_PF_STATUS          0x0053  /* permanent failure - sticky */
#define BQ_MAC_OPERATION_STATUS   0x0054
#define BQ_MAC_CHARGING_STATUS    0x0055  /* WHY charge is inhibited - see the
                                           * BQ_CHG_* flags below. */

/* ChargingStatus (MAC 0x0055) flags. THREE bytes, not four - reading it with
 * BQ40Z50_ReadMAC32() fails, because that rejects anything shorter than 4.
 *
 * Bit map from the BQ40Z50-R2 TRM, SLUUBK0B section 14.1.41.
 * Bits 23-20 and bit 7 are reserved.
 *
 * IN and SU are the two that mean "this pack will not charge". The voltage
 * region (PV/LV/MV/HV) and temperature band (UT..OT) say why. */
#define BQ_CHG_NCT   0x080000ul   /* near charge termination           */
#define BQ_CHG_CCC   0x040000ul   /* charging loss compensation        */
#define BQ_CHG_CVR   0x020000ul   /* charging voltage rate of change   */
#define BQ_CHG_CCR   0x010000ul   /* charging current rate of change   */
#define BQ_CHG_VCT   0x008000ul   /* charge termination                */
#define BQ_CHG_MCHG  0x004000ul   /* maintenance charge                */
#define BQ_CHG_SU    0x002000ul   /* SUSPEND charge                    */
#define BQ_CHG_IN    0x001000ul   /* charge INHIBIT                    */
#define BQ_CHG_HV    0x000800ul   /* high voltage region               */
#define BQ_CHG_MV    0x000400ul   /* mid voltage region                */
#define BQ_CHG_LV    0x000200ul   /* low voltage region                */
#define BQ_CHG_PV    0x000100ul   /* precharge voltage region          */
#define BQ_CHG_OT    0x000040ul   /* overtemperature                   */
#define BQ_CHG_HT    0x000020ul   /* high temperature                  */
#define BQ_CHG_STH   0x000010ul   /* standard temperature high         */
#define BQ_CHG_RT    0x000008ul   /* recommended temperature           */
#define BQ_CHG_STL   0x000004ul   /* standard temperature low          */
#define BQ_CHG_LT    0x000002ul   /* low temperature                   */
#define BQ_CHG_UT    0x000001ul   /* under temperature                 */
#define BQ_MAC_MANUFACTURING_STATUS 0x0057

#define BQ_DEVICE_TYPE_EXPECTED   0x4500

/* Default unseal key (TRM 11.5.2) */
#define BQ_UNSEAL_KEY_WORD1       0x0414
#define BQ_UNSEAL_KEY_WORD2       0x3672

/* ManufacturingStatus bits */
#define BQ_MFG_GAUGE_EN           (1u << 3)   /* Impedance Track gas gauging */
#define BQ_MFG_FET_EN             (1u << 4)

/* OperationStatus bits (32-bit) */
#define BQ_OP_PRES                (1ul << 0)
#define BQ_OP_DSG                 (1ul << 1)   /* live FET states */
#define BQ_OP_CHG                 (1ul << 2)
#define BQ_OP_PCHG                (1ul << 3)
#define BQ_OP_XDSG                (1ul << 13)
#define BQ_OP_XCHG                (1ul << 14)

/* Remaining OperationStatus flags, TRM SLUUBK0B section 14.1.40.
 * Bits 31-30, 6 and 4 are reserved.
 *
 * FUSE is the one worth shouting about: a latched fuse drive holds every FET
 * off with SafetyStatus completely CLEAR, which reads as "no fault" while
 * nothing works. XCHG likewise - charging disabled with no protection set. */
#define BQ_OP_FUSE                (1ul << 5)    /* latched fuse drive        */
#define BQ_OP_BTP_INT             (1ul << 7)    /* battery trip point intr   */
#define BQ_OP_SEC_MASK            (3ul << 8)    /* 01=full access 10=unsealed
                                                 * 11=sealed                */
#define BQ_OP_SDV                 (1ul << 10)   /* shutdown, low pack volts  */
#define BQ_OP_SS                  (1ul << 11)   /* any SafetyStatus bit set  */
#define BQ_OP_PF                  (1ul << 12)   /* permanent failure         */
#define BQ_OP_SLEEP               (1ul << 15)   /* SLEEP conditions met      */
#define BQ_OP_SDM                 (1ul << 16)   /* shutdown via command      */
#define BQ_OP_LED                 (1ul << 17)
#define BQ_OP_AUTH                (1ul << 18)   /* authentication running    */
#define BQ_OP_AUTOCALM            (1ul << 19)
#define BQ_OP_CAL                 (1ul << 20)
#define BQ_OP_CAL_OFFSET          (1ul << 21)
#define BQ_OP_XL                  (1ul << 22)   /* 400 kHz SMBus             */
#define BQ_OP_SLEEPM              (1ul << 23)   /* SLEEP via command         */
#define BQ_OP_INIT                (1ul << 24)   /* init after full reset     */
#define BQ_OP_SMBLCAL             (1ul << 25)
#define BQ_OP_SLPAD               (1ul << 26)
#define BQ_OP_SLPCC               (1ul << 27)
#define BQ_OP_CB                  (1ul << 28)   /* cell balancing active     */
#define BQ_OP_EMSHUT              (1ul << 29)   /* emergency FET shutdown    */

/* SBS commands used by the status report. Current() and friends are SIGNED:
 * negative is discharge. */
#define BQ_CMD_VOLTAGE            0x09    /* uint16, mV - TOTAL pack voltage.
                                           * A plain word read, legal in every
                                           * security mode: no unseal, no
                                           * ManufacturerAccess needed.      */
#define BQ_CMD_CURRENT            0x0A    /* int16, mA                       */
#define BQ_CMD_RSOC               0x0D    /* uint16, %                       */
#define BQ_CMD_FULL_CHG_CAPACITY  0x10    /* uint16, mAh                     */
#define BQ_CMD_CHARGING_CURRENT   0x14    /* uint16, mA  - what the gauge is */
#define BQ_CMD_CHARGING_VOLTAGE   0x15    /* uint16, mV    ASKING the charger
                                           * for. Zero here means the pack is
                                           * refusing charge outright.       */
#define BQ_CMD_BATTERY_STATUS     0x16    /* uint16, alarm and status bits   */

/* Advanced Charging Algorithm data flash. Addresses from the R2 TRM
 * SLUUBK0B data flash summary.
 *
 * TEMPERATURES ARE STORED IN 0.1 K, not degrees C - the parameter tables in
 * section 15.4 quote degrees, the address table does not. Convert with
 * (raw - 2732)/10. The hysteresis is a DELTA, so it has no 2732 offset.
 *
 * Nothing in bq_golden[] writes any of these, so a pack that has only been
 * through BringUp is sitting on the factory defaults noted below. */
#define BQ_DF_T1_TEMP             0x4A0B  /* 2732 = 0 C   UT/LT boundary     */
#define BQ_DF_T2_TEMP             0x4A0D  /* 2852 = 12 C  LT/STL             */
#define BQ_DF_T5_TEMP             0x4A0F  /* 2932 = 20 C  STL/RT             */
#define BQ_DF_T6_TEMP             0x4A11  /* 2982 = 25 C  RT/STH             */
#define BQ_DF_T3_TEMP             0x4A13  /* 3032 = 30 C  STH/HT             */
#define BQ_DF_T4_TEMP             0x4A15  /* 3282 = 55 C  HT/OT              */
#define BQ_DF_TEMP_HYSTERESIS     0x4A17  /* 10   = 1.0 C delta              */
#define BQ_DF_CHGV_LOW_TEMP       0x4A19  /* 4000 mV                         */
#define BQ_DF_CHGV_STD_LOW        0x4A21  /* 4200 mV                         */
#define BQ_DF_CHGV_STD_HIGH       0x4A29  /* 4200 mV                         */
#define BQ_DF_CHGV_HIGH_TEMP      0x4A31  /* 4000 mV - BELOW a full cell     */
#define BQ_DF_CHGV_REC_TEMP       0x4A39  /* 4100 mV                         */
#define BQ_DF_PRECHARGE_START_MV  0x4A45  /* 2500 mV                         */
#define BQ_DF_CHG_VOLTAGE_LOW     0x4A47  /* 2900 mV  LV region              */
#define BQ_DF_CHG_VOLTAGE_MED     0x4A49  /* 3600 mV  MV region              */
#define BQ_DF_CHG_VOLTAGE_HIGH    0x4A4B  /* 4000 mV  HV region              */
#define BQ_DF_CHG_VOLTAGE_HYST    0x4A4D  /* 0 mV, ONE byte - no deadband    */

/* Data flash */
#define BQ_DF_DA_CONFIGURATION    0x4A7D  /* 1 byte */
#define BQ_DF_MFG_STATUS_INIT     0x4600  /* 2 bytes; power-up/seal-time
                                             ManufacturingStatus source -
                                             FET_EN here = FETs persistently
                                             enabled (TRM 15.3.1) */
#define BQ_DF_TEMPERATURE_ENABLE  0x4A7B  /* 1 byte; bit0 TSint, bits1-4 TS1-4 */
#define BQ_DF_TEMPERATURE_MODE    0x4A7C  /* 1 byte; per-sensor cell/FET select */

#define BQ_DF_DESIGN_CAPACITY_MAH 0x48E5  /* 2 bytes, mAh */
#define BQ_DF_DESIGN_CAPACITY_CWH 0x48E7  /* 2 bytes, centi-Wh */
#define BQ_DF_DESIGN_VOLTAGE      0x48E9  /* 2 bytes, mV */

/* ===================================================================
 * PACK-SPECIFIC VALUES - SET THESE FOR THE RGS PACK
 * ===================================================================
 * Left at 0 = "not configured": the golden image skips those entries and
 * says so, rather than writing a plausible-looking wrong number.
 *
 * Design Capacity is what state-of-charge is computed against, so gas
 * gauging (GAUGE_EN) is deliberately NOT enabled until it is set - a gauge
 * running against the factory 4400 mAh default would report SOC that is
 * confidently wrong, which is worse than reporting none.
 *
 * cWh = capacity in centi-watt-hours = (mAh x Design Voltage mV) / 100000.
 * For 4 series cells, Design Voltage is nominal cell voltage x 4
 * (3600 mV x 4 = 14400 mV for typical Li-ion).
 */
/* 4S1P: series cells raise voltage, not capacity, so pack capacity is the
 * single-cell figure. (If the pack is ever built with parallel pairs this
 * must double.) */
#define BQ_PACK_DESIGN_CAPACITY_MAH   2500

/* ASSUMPTION: 3.6 V nominal per cell x 4 = 14400 mV, which is also TI's own
 * 4-series default. Change to 14800 if these cells are specified at 3.7 V
 * nominal - it shifts the energy figure below by ~3%. */
#define BQ_PACK_DESIGN_VOLTAGE_MV     14400

/* Energy = mAh x mV / 100000, in centi-watt-hours: 2500 x 14400 / 100000 */
#define BQ_PACK_DESIGN_CAPACITY_CWH   360

/* Protection thresholds (CUV 0x493C, COV 0x4946.., OCC 0x4964, OCD 0x496D,
 * OT/UT 0x4982..0x4996) are deliberately NOT in the golden image yet. TI's
 * defaults assume generic 4.2 V Li-ion; they must be set from the cell
 * datasheet before this jig is trusted to release packs. */

/* BENCH ONLY - no thermistors fitted: internal die sensor as the sole
 * (cell) temperature source, so under/over-temp protections see a real
 * temperature instead of an open TS input reading "frozen" (UTD trip).
 * Packs with real thermistors need these rewritten to match the design. */
#define BQ_TEMP_ENABLE_BENCH      0x01    /* TSint only */
#define BQ_TEMP_MODE_BENCH        0x00    /* everything = cell temperature */
#define BQ_DA_CELL_COUNT_MASK     0x03
#define BQ_DA_CELL_COUNT_4S       0x03    /* CC1:CC0 = 1,1 = 4 cell */
#define BQ_DA_NR                  (1u << 2) /* non-removable: ignore PRES pin */
/* Allow the gauge to enter SLEEP. NOT used by the golden image - see the
 * DA Config entry in bq40z50.c.
 *
 * Set in the R2 factory default (0x12), so leaving it out has to be done
 * explicitly on every pack. FETs remain closed in SLEEP, but the gauge only
 * wakes on load current above a threshold, on bus activity, or on charger
 * insertion - so the small initial draw of a button press may not wake it,
 * and the unit looks dead until it is briefly put on charge (2026-08-11).
 * Named here so the golden value reads as intent rather than a magic 0x10. */
#define BQ_DA_SLEEP               (1u << 4)

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

/* Tri-state on purpose: reading data flash needs ManufacturerBlockAccess,
 * which a SEALED gauge refuses, so "cannot tell" must never be mistaken for
 * "not provisioned". Treat UNKNOWN as "run the bring-up anyway" - every
 * step of it is idempotent. */
typedef enum
{
    BQ_PROV_UNKNOWN = 0,   /* could not read: bus failed, or gauge sealed */
    BQ_PROV_NO,            /* read OK, factory/unprovisioned */
    BQ_PROV_YES            /* read OK, already provisioned */
} BQ_PROVISIONED;

typedef enum
{
    BQ_MODE_UNKNOWN = 0,
    BQ_MODE_SEALED,
    BQ_MODE_UNSEALED,
    BQ_MODE_FULL_ACCESS
} BQ_SEC_MODE;

/* ---- Golden image -------------------------------------------------
 * The curated set of data-flash settings that define an RGS pack. Verify is
 * read-only and returns how many entries differ; Apply writes only what is
 * wrong and re-reads each one to confirm. Entries left unconfigured (see the
 * pack-specific block above) are skipped and counted separately, so an
 * incomplete image can never masquerade as a verified one. */
BQ_STATUS   BQ40Z50_VerifyGoldenImage(uint8_t *mismatches, uint8_t *unset);
BQ_STATUS   BQ40Z50_ApplyGoldenImage(void);
void        BQ40Z50_ReportGoldenImage(void);

/* Cheap "has this pack been through the jig already?" test - one DF read.
 * Lets the caller branch around BQ40Z50_BringUp() when there is nothing to do. */
BQ_PROVISIONED BQ40Z50_IsProvisioned(void);

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

/* Free the I2C2 bus from a slave stuck mid-byte holding SDA low.
 *
 * Needed because the pack FETs stay latched on, so the 3V3 rail and every
 * device on I2C2 keep their power through a PIC reset or a reflash. A plain
 * I2C device (the GPIO port expander) has no SMBus bus-timeout, so once it is
 * knocked out of sync it holds SDA down indefinitely and the condition
 * SURVIVES restarts - resetting our own peripheral cannot clear it. The cure
 * is to clock the slave through the rest of its byte and then STOP.
 *
 * Call at start-up before any gauge access. Returns true if the bus looks
 * usable afterwards. Safe to call when the bus is already healthy. */
bool        BQ40Z50_BusUnwedge(void);

/* Print a status snapshot on UART1: DA Configuration, FET states,
 * temperature and cell voltages. Read-only and self-contained - safe to call
 * from main() on any pass, whether or not bring-up ran. Individual reads that
 * fail are reported as such rather than aborting the report. */
void        BQ40Z50_ReportStatus(void);

/* Full bring-up sequence: probe -> unseal -> DA config -> FETs -> voltages.
 * Progress and results are reported as text on UART1. Returns the first
 * error encountered, BQ_OK if the pack came up fully. */
BQ_STATUS   BQ40Z50_BringUp(void);

#endif /* BQ40Z50_H */
