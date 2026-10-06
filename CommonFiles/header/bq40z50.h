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
#define BQ_MAC_GAUGING_STATUS     0x0056  /* WHETHER the gauge is learning at
                                           * all, and how far it has got. */

/* GaugingStatus (MAC 0x0056) flags. THREE bytes, like ChargingStatus.
 * Bit map from the BQ40Z50-R2 TRM, SLUUBK0B section 14.1.42.
 * Bits 23-21 and bits 14, 9 are reserved.
 *
 * QEN is the one that decides whether a learning cycle is worth running at all:
 * with it clear, Impedance Track is off and NEITHER Qmax NOR Ra will update,
 * however perfectly the cycle is performed. Note it is NOT the same thing as
 * GAUGE_EN in ManufacturingStatus.
 *
 * The rest are the progress markers through a learning cycle, in the order they
 * should appear: REST and VOK after a relaxation, VDQ through the discharge,
 * EDV at the bottom, then the QMAX and RX toggles when the updates land. */
#define BQ_GAUGE_OCVFR  0x100000ul  /* OCV in flat region during RELAX     */
#define BQ_GAUGE_LDMD   0x080000ul  /* load mode: 1 = constant power       */
#define BQ_GAUGE_RX     0x040000ul  /* toggles after every Ra update       */
#define BQ_GAUGE_QMAX   0x020000ul  /* toggles after every Qmax update     */
#define BQ_GAUGE_VDQ    0x010000ul  /* discharge qualified for learning    */
#define BQ_GAUGE_NSFM   0x008000ul  /* negative Ra scaling factor          */
#define BQ_GAUGE_SLPQMAX 0x002000ul /* OCV update in SLEEP in progress     */
#define BQ_GAUGE_QEN    0x001000ul  /* IMPEDANCE TRACK ENABLED             */
#define BQ_GAUGE_VOK    0x000800ul  /* voltages OK - a DOD was saved       */
#define BQ_GAUGE_R_DIS  0x000400ul  /* 1 = resistance updates DISABLED     */
#define BQ_GAUGE_REST   0x000100ul  /* OCV reading taken during RELAX      */
#define BQ_GAUGE_CF     0x000080ul  /* MaxError too high - cycle needed    */
#define BQ_GAUGE_DSG    0x000040ul  /* 1 = charging NOT detected           */
#define BQ_GAUGE_EDV    0x000020ul  /* termination voltage reached         */
#define BQ_GAUGE_BAL_EN 0x000010ul  /* cell balancing permitted            */
#define BQ_GAUGE_TC     0x000008ul  /* terminate charge                    */
#define BQ_GAUGE_TD     0x000004ul  /* terminate discharge                 */
#define BQ_GAUGE_FC     0x000002ul  /* fully charged                       */
#define BQ_GAUGE_FD     0x000001ul  /* fully discharged                    */

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

/* Gauging and protection data flash. Addresses taken from SLUUBK0B Table 15-1,
 * the Data Flash Table, which is the ONLY place in the TRM that carries
 * addresses - the parameter descriptions in section 15.2 onwards do not.
 *
 * The seven addresses above were already in use and all seven match Table 15-1
 * exactly, which is what gives confidence in the rest of this block.
 *
 * NOTE two addresses in the old comment further down were WRONG: it had OCC at
 * 0x4964 (really inside the OCC2 group) and OCD at 0x496D (past OCD2). Both
 * would have written to the wrong parameter. They are corrected here. */
#define BQ_DF_TERM_VOLTAGE        0x484A  /* 2 bytes, mV - where 0% SoC is   */
#define BQ_DF_QUIT_CURRENT        0x4A8D  /* 2 bytes, mA - relaxation entry  */

#define BQ_DF_CUV_THRESHOLD       0x493C  /* 2 bytes, mV, per cell */
#define BQ_DF_COV_THR_LOW_TEMP    0x4946  /* 2 bytes, mV - FIVE bands, and a */
#define BQ_DF_COV_THR_STD_LOW     0x4948  /* pack is only protected when all */
#define BQ_DF_COV_THR_STD_HIGH    0x494A  /* five are set. Easy to miss the  */
#define BQ_DF_COV_THR_HIGH_TEMP   0x494C  /* last one.                       */
#define BQ_DF_COV_THR_REC_TEMP    0x494E

#define BQ_DF_OCC1_THRESHOLD      0x495E  /* 2 bytes, mA, positive */
#define BQ_DF_OCC2_THRESHOLD      0x4961
#define BQ_DF_OCD1_THRESHOLD      0x4967  /* 2 bytes, mA, NEGATIVE */
#define BQ_DF_OCD2_THRESHOLD      0x496A

#define BQ_DF_OTC_THRESHOLD       0x497F  /* 2 bytes, 0.1 K - see the note */
#define BQ_DF_OTC_RECOVERY        0x4982  /* above about temperature units */
#define BQ_DF_UTD_THRESHOLD       0x4993
#define BQ_DF_UTD_RECOVERY        0x4996

/* Gas Gauging / State. Qmax is DELIBERATELY not in bq_golden[] - see the
 * seeding note in bq40z50.c. */
#define BQ_DF_QMAX_CELL1          0x4306  /* 2 bytes each, mAh */
#define BQ_DF_QMAX_CELL2          0x4308
#define BQ_DF_QMAX_CELL3          0x430A
#define BQ_DF_QMAX_CELL4          0x430C
#define BQ_DF_QMAX_PACK           0x430E
#define BQ_DF_UPDATE_STATUS       0x4312  /* 1 byte */

/* Calibration gains. F4 = IEEE754 single, little endian (TRM 15.1.3), holding
 * the sense resistance in mOhm. NOT in bq_golden[] - they are repaired rather
 * than enforced; see bq_repair_gain_if_implausible(). */
#define BQ_DF_CC_GAIN             0x4006  /* 4 bytes */
#define BQ_DF_CAPACITY_GAIN       0x400A  /* 4 bytes */

/* Temperatures are stored in 0.1 K. 2732 = 0 C, so 45 C is 3182. */
#define BQ_DEGC_TO_01K(c)         ((uint16_t)(((int16_t)(c) * 10) + 2732))

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
 * cWh = capacity in centi-watt-hours = (mAh x Design Voltage mV) / 10000.
 * For 4 series cells, Design Voltage is nominal cell voltage x 4
 * (3600 mV x 4 = 14400 mV for typical Li-ion).
 */
/* 4S1P: series cells raise voltage, not capacity, so pack capacity is the
 * single-cell figure. (If the pack is ever built with parallel pairs this
 * must double.)
 *
 * Cell: BAK N18650COP, spec P/PR03/PB-D-N18650COP-ZZ rev B/00 (2023-08-02).
 *
 * This is the cell's RATED capacity (2400 mAh), deliberately NOT its typical
 * capacity (2500 mAh). Rated is the minimum a cell is guaranteed to deliver, so
 * a pack built from weaker-but-in-spec cells can still reach 100%. Configured
 * the other way round, the gauge promises capacity the cells may not have and
 * reads short of full at the top of every charge.
 *
 * Changed from 2500 on 2026-10-02, BEFORE characterisation - this value is what
 * state-of-charge is computed against, so changing it after a learning cycle
 * invalidates the learning. */
#define BQ_PACK_DESIGN_CAPACITY_MAH   2400

/* ASSUMPTION: 3.6 V nominal per cell x 4 = 14400 mV, which is also TI's own
 * 4-series default. Change to 14800 if these cells are specified at 3.7 V
 * nominal - it shifts the energy figure below by ~3%. */
#define BQ_PACK_DESIGN_VOLTAGE_MV     14400

/* Energy in CENTI-watt-hours = mAh x mV / 10000: 2400 x 14400 / 10000 = 3456,
 * i.e. 34.56 Wh.
 *
 * Cross-checks against the cell datasheet, which states rated energy as 8.64 Wh
 * per cell: 4 x 8.64 = 34.56 Wh. That agreement is also what confirms the field
 * really is centi-watt-hours.
 *
 * WAS 360, from dividing by 100000. Ten times low, and confirmed wrong against
 * the part itself on 2026-10-02: bqStudio's Data Memory export of a provisioned
 * pack reads
 *
 *   "Gas Gauging","Design","Design Capacity cWh","360","cWh"
 *
 * - TI's own units column says cWh, so 36 Wh is 3600. The parameter is named
 * "Design Capacity cWh" in the tool, NOT "Design Energy".
 *
 * Every pack ApplyGoldenImage() touched before this was told it held 3.6 Wh.
 * It matters whenever a host reads capacity in energy units rather than mAh -
 * check Sbs Gauging Configuration (0x04 on the pack examined) for the CAPM
 * bit, which selects exactly that. */
#define BQ_PACK_DESIGN_CAPACITY_CWH   3456

/* ---- Protection and gauging limits, from the CELL datasheet ----
 *
 * Cell: BAK N18650COP, controlled spec P/PR03/PB-D-N18650COP-ZZ rev B/00.
 * Derived and proven against a reference pack on 2026-10-02/05; the full
 * reasoning is in bq40z50r2_goldenimages/PACK_PROVISIONING.md.
 *
 * These used to be left at TI's generic defaults, and those defaults were not
 * merely imprecise - two of them were wrong in ways that matter:
 *
 *   COV 4300 mV  - ABOVE the cell's 4.25 V absolute ceiling (Uup), so the
 *                  over-voltage protection could never engage in time.
 *   UTD    0 C   - the cell discharges to -20 C. At 0 C the pack refuses to
 *                  discharge in cold weather: an outdoor unit that will not
 *                  switch on in winter.
 *
 * Note the datasheet has TWO voltage pairs and it is easy to take the wrong
 * one. Ude 2.50 V and Ucl 4.20 V are the OPERATING limits; Udo 2.00 V and
 * Uup 4.25 V are absolute never-exceed. Term Voltage follows the operating
 * cut-off, the protections sit between the two. */
#define BQ_PACK_TERM_VOLTAGE_MV      10000  /* 2.50 V x 4 - where 0% SoC is  */
#define BQ_PACK_CUV_MV                2300  /* below Term V so it does not   */
                                            /* trip during a learning cycle, */
                                            /* 300 mV above the 2.00 V floor */
#define BQ_PACK_COV_MV                4250  /* the 4.25 V absolute ceiling   */

/* Sized to the PRODUCT, not the cell: the cell permits 6 A charge and 30 A
 * discharge, which protects nothing on a unit that charges at 0.9 A and draws
 * 0.6 A. These guard the wiring, FETs and traces. The default 6 s / 3 s delays
 * are what make them safe this tight - a Jetson inrush lasting milliseconds
 * cannot trip them, only a sustained fault can. */
#define BQ_PACK_OCC1_MA               1500  /* ~1.5x the 0.9 A charger       */
#define BQ_PACK_OCC2_MA               2000
#define BQ_PACK_OCD1_MA              (-1500) /* ~2.5x the 0.6 A system draw  */
#define BQ_PACK_OCD2_MA              (-2500)

/* Using-temperature range from the controlled datasheet: charge 0 to 45 C,
 * discharge -20 to 60 C. The marketing datasheet quotes 55 and 75 - those are
 * the maximum SURFACE temperatures, not the operating range, and using them
 * would permit charging 10 C above the cell's limit.
 *
 * Only OTC and UTD are set here; OTD 60 C and UTC 0 C already match the
 * datasheet in TI's defaults.
 *
 * CAVEAT: with no thermistors fitted every one of these is measured by the
 * gauge's INTERNAL die sensor, not the cells. During charge the cells run
 * warmer than the PCB, so treat these as a proxy with an unknown offset. */
#define BQ_PACK_OTC_THRESHOLD_C         45
#define BQ_PACK_OTC_RECOVERY_C          40  /* must cool to <=45 before      */
                                            /* charge resumes, so below OTC  */
#define BQ_PACK_UTD_THRESHOLD_C        (-20)
#define BQ_PACK_UTD_RECOVERY_C         (-15)

/* The gauge only enters RELAXATION - and so only takes the OCV readings a
 * learning cycle depends on - when current falls below this. MEASURED board
 * draw is 26.5 mA with the unit running, so TI's 10 mA default can never be
 * met and no Qmax update would ever happen, on the bench OR in the field.
 *
 * Deliberately NOT solved with Board Offset, which would make the gauge blind
 * to a current that really does flow whenever the unit is on and would drift
 * field SoC optimistic. 40 mA on a 2400 mAh pack is 0.017C - far too small to
 * cause meaningful polarisation error in an OCV reading. */
#define BQ_PACK_QUIT_CURRENT_MA         40

/* Current-sense gain, as IEEE754 bit patterns so no float arithmetic is needed.
 *
 * The measured sense path on this board is 4.364 mOhm, within 0.1% of TI's
 * factory default of 4.369 - so a pack from the factory is already right and
 * this is a REPAIR value, not a calibration. It is written only when what is
 * stored is implausible.
 *
 * Positive IEEE754 floats order correctly as unsigned integers, so a simple
 * range test catches every corruption seen so far: 0.090 (0x3DB851EC) and 0.175
 * (0x3E333333) fall below 1.0, while infinity (0x7F800000), zero, NaN and any
 * negative value land above 20.0.
 *
 *   4.369f = 0x408BCED9    0.5f = 0x3F000000    20.0f = 0x41A00000
 *
 * The REPAIR band is deliberately WIDE: 0.5 to 20 mOhm. It exists to catch
 * GARBAGE - infinity, 1,069,035, 0.090, 0.175, all of which this project has
 * actually produced - and nothing else.
 *
 * It was briefly narrowed to 3.0-6.0 on 2026-10-05 to catch a stored 1.0, which
 * made one pack read 4.4x high and trip OCC2 and OCD1 on ordinary currents.
 * That was reverted the same day, because the premise turned out to be shaky:
 * two boards measured their sense path as ~4.4 mOhm and ~11.4 mOhm, the second
 * consistent with a 10 mOhm part where the schematic was read as 1 mOhm. With
 * the nominal itself in doubt, a narrow band would overwrite legitimate
 * per-unit calibrations - far worse than failing to catch a wrong one.
 *
 * So: the firmware repairs only what cannot possibly be a calibration, and
 * anything merely suspicious is reported by BQ40Z50_ReportStatus() for a human
 * to judge. UNTIL THE SHUNT VALUE IS SETTLED, treat the nominal below as
 * indicative only - it came from one board's two-point measurement. */
/* NOMINAL = 0.87 mOhm.
 *
 * THE GAIN MULTIPLIES, IT DOES NOT DIVIDE. Established on the bench 2026-10-05
 * by writing two values and reading the current at an unchanged 97 mA load:
 *
 *      CC Gain 3.5842  ->  gauge reported  338 mA
 *      CC Gain 11.38   ->  gauge reported 1266 mA
 *
 * Raising the gain RAISED the reading. Earlier working here assumed the
 * opposite - that the gauge divides by it, as "mOhm" implies - and every value
 * derived on that assumption (4.369 "nominal", 11.38, the 3.0-6.0 band) was
 * therefore corrected in the wrong direction. Do not re-derive them.
 *
 * 0.87 comes from scaling the last measurement: 11.38 x 97/1266. It sits beside
 * the 1 mOhm the schematic shows, which is the first time the schematic and the
 * measurements have agreed. It also explains the very first symptom seen on
 * this project - a resting pack reporting 4 mA while 17-26 mA flowed - as the
 * factory default of 4.369 reading roughly 4x LOW for this board.
 *
 * UNRESOLVED: the reference pack read 423 mA at 99 mA with its gain at 1.0,
 * which a multiplying gain cannot explain. Either that board differs or that
 * measurement is not trustworthy. Worth repeating once this pack is right: if
 * boards genuinely differ, a compiled-in nominal is the wrong idea and every
 * pack needs calibrating against its own board. */
#define BQ_GAIN_NOMINAL_BITS      0x3F5EB852ul   /* 0.87f */

/* Repair band, 0.1 to 5.0 mOhm. Wide on purpose: it catches only what cannot be
 * a calibration at all - infinity, 1,069,035, zero, negatives - and leaves
 * anything arguable to the operator via the report and menu 9. */
#define BQ_GAIN_MIN_BITS          0x3DCCCCCDul   /* 0.1f  */
#define BQ_GAIN_MAX_BITS          0x40A00000ul   /* 5.0f  */

/* "Looks like this board's sense path": +/-10% around nominal. Report-only -
 * nothing is written on the strength of it. */
#define BQ_GAIN_NEAR_MIN_BITS     0x3F47AE14ul   /* 0.78f */
#define BQ_GAIN_NEAR_MAX_BITS     0x3F75C28Ful   /* 0.96f */

/* Qmax seeding. TI ships 4400 mAh, against a real 2400 - an 80% overestimate,
 * well outside Qmax Delta (5%) and Qmax Upper Bound (130%), so the first
 * learning pass may reject its own measurement rather than converge. Seeded
 * ONLY when it still reads this factory value: see bq_seed_qmax_if_default(). */
#define BQ_QMAX_FACTORY_DEFAULT       4400

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
/* Write both current-sense gains to BQ_GAIN_NOMINAL_BITS, unconditionally, and
 * report what each reads back. Needs the pack UNSEALED with FULL ACCESS. The
 * only way to correct a gain from the jig: the repair in ApplyGoldenImage()
 * deliberately ignores values that are wrong but not absurd. */
BQ_STATUS   BQ40Z50_SetSenseGain(void);

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
