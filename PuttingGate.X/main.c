
//#pragma config FWDTEN = OFF      // Watchdog Timer Enable (WDT disabled in hardware)
//#pragma config WINDIS = ON       // Windowed WDT disabled (optional)

#include "../CommonFiles/header/Events.h"
#include "../CommonFiles/header/pin_CustomISR.h"

#include "../CommonFiles/header/system.h"
#include "../CommonFiles/header/clock.h"
#include "../CommonFiles/header/interrupt_manager.h"
#include "../CommonFiles/header/i2c2.h"
#include "../CommonFiles/header/i2c1.h"
#include "../CommonFiles/header/tmr4.h"
#include "../CommonFiles/header/tmr2.h"
#include "../CommonFiles/header/pin_manager.h"
#include "../CommonFiles/header/lis2dw12.h"
#include "../CommonFiles/header/i2c2_helpers.h"
#include "../CommonFiles/header/lis2dw12_i2c2.h"
#include "../CommonFiles/header/power_control.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>     /* abs(), used on the pitch/roll values */
#include "../CommonFiles/header/i2c_write_queue.h"
#include "../CommonFiles/header/address_block_lookup.h"
#include "../CommonFiles/header/job_queue.h"
#include <xc.h>

#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>
#include "../CommonFiles/header/pitchandroll.h"
#include "../CommonFiles/header/persist_store.h"
#include "firmware_version.h"
#include "../CommonFiles/header/EEpromBlockLabels.h"
#include "../CommonFiles/header/InitEEpromVals.h"
#include "../CommonFiles/header/ArrayUtils.h"
/* bq40z50.c IS in this project's build, and has been since the boot-time pack
 * configuration went in. It did not used to be: the comment here said so for a
 * while after it changed, which is worth knowing if you are reading old notes.
 *
 * The driver is heavily instrumented with UART reporting the field application
 * neither initialises nor has the flash to spare for, so this project compiles
 * it with -DBQ_VERBOSE=0 (set in the project's XC16 preprocessor macros, and
 * bq40z50.c has an #error if it is left undefined). That turns the print
 * helpers into ((void)0) macros - macros specifically, so the string literals
 * are dropped too rather than merely unreferenced - and guards the reporting
 * functions out altogether. It saves about 10.8 kB, which is the difference
 * between fitting and not.
 *
 * What this project uses from it: BQ40Z50_I2C_ADDRESS, BQ_CMD_VOLTAGE and
 * BQ_CMD_CURRENT for the plain SBS reads in GetBattVolts(), and the config
 * stamp, golden image and sense-gain calls for the boot-time setup. */
#include "../CommonFiles/header/bq40z50.h"
#include "../CommonFiles/header/soc_voltage.h"


//accelerometer specific stuff....
// to be removed if we ever implement a proper .c/.h set up

//commented out here, copied to top, but preserved for moving to header file
/* ---- LIS2DW12 / LIS2DW1TR basics ---- */



#define ButtonDelay 5    // The number of cycles of the button hold to return 'true)
                         // NOT debounce, this is the long (ish)user press and hold

#define On 1
#define Off 0

////////////////////////////////////////////////////
// Round robin to move to seperate c and h files?
//round robin possible tasks
/* uint16_t, not uint8_t, and that matters. These return CallJetson codes from
 * the bitfield in EEpromBlockLabels.h, which is 16 bits wide, as are
 * CallJetsonCode in the emulated EEPROM and WarnCodeToJetson() itself. While
 * this hop was uint8_t everything from 0x0100 up - Spare3 onwards - was
 * silently truncated between a task and the Jetson: the bit would be set,
 * tested true inside the task, and then simply not arrive. Nothing hit it
 * because every code in use was in the low byte, and PowerOff_10_min at
 * 0x0080 was the last one that would have fitted. */
uint16_t GetBattVolts(void);
uint16_t GetAccel(void);

typedef uint16_t (*TaskFn)(void);
TaskFn Task[]={GetAccel,GetBattVolts};

#define NUM_Tasks (sizeof(Task)/sizeof(Task[0]))

uint8_t TaskIndex;
uint16_t TaskWarning;   /* 16 bits to match the CallJetson bitfield - see above */
void HandleTaskWarning(uint16_t code);  // handler for any errors/warnings on routine tasks

////////////////////////////////////////////////
void AllLightsOn (void);
void AllLightsOff (void);
void AllLightsRestore (void);
void AllPowerDown (void);
uint8_t CopyLightState; // to allow the lasers etc to be put back as we found them
void WarnCodeToJetson(uint16_t WarnCode);
void ClearWarnCodeToJetson(uint16_t WarnCode);



// accelerometer prototypes
//void LIS2DW12_SetAddress_I2C2(uint8_t addr);
uint8_t QuickAcellerometerGrabber(void);

//end accelerometer prototypes

void CallJetsonBall(void);
void CallJetsonJob(void);

//bool LIS2DW12_Configure(void);
void PowerDown(bool ForcePowerDown);

//Just for use with the above
#define ForcePwrDwn 1
#define ButtonPwrDwn 0


/* The power button, cold/warm start, charger detection, ring LED and the
 * power-off countdown live in CommonFiles power_control.c, shared with
 * RGS_BringUp so both images behave identically. See power_control.h. */

// PWM on RB11 via OC3/T3
#define PWM_RB11_PERIOD   159   // PR3 value: 100kHz at FCY=16MHz (16000000/100000 - 1)
void PWM_RB11_Init(void);
void PWM_RB11_Enable(void);
void PWM_RB11_Disable(void);
void PWM_RB11_SetDuty(uint8_t duty);

// power management
// queuepanic is set when JobQueue_Push fails and is currently never read -
// a queue overflow is recorded and then ignored. Left in place because the
// fix is to ACT on it, not to delete it.
bool queuepanic;


I2C_WriteJob_t LoadJobFromEEprom;
 
 
 int16_t xcal;
 int16_t ycal;
 int16_t zcal;
 
 //battery management levels and control variables

/* ---- The voltage ratchet: RETIRED 2026-11-05, replaced by soc_voltage.c ----
 *
 * Kept here, commented, rather than deleted. These six thresholds were picked
 * in the field and this repository is not under version control, so deleting
 * them would destroy the only record of them.
 *
 *     static const uint16_t VoltageThresholds[]={14300,14100,14000,13800,13400,13300};
 *     #define NumVoltLevels 5  // includes 0, so six items
 *     #define CriticalVoltage VoltageThresholds[NumVoltLevels]
 *     static uint8_t VoltageThresholdNow;
 *
 * Read on the measured discharge curve in soc_voltage.c they come out at
 * 31.4 / 21.2 / 16.9 / 10.1 / 0.0 / 0.0 percent. That 13800 lands on 10.1% is
 * why SOCV_WARN_PCT is 10 - the hand-picked last warning and the integrated
 * curve agree to within 5 mV, which is the main reason for trusting the swap.
 *
 * What the ratchet DID: advance one level per reading that fell below the
 * current threshold, warn on each step, and at level 5 (13300 mV) count four
 * readings before asserting PowerOff_1_min. It only ever recovered through the
 * "above 14300 having passed at least two levels" escape, so it was a one-way
 * latch with a coarse reset, and its first warning fired at 31% of pack.
 *
 * SOCV_Update() does the same job from the same 13300 mV stop, with a
 * 3-reading debounce and 200 mV of hysteresis applied to the clearing side.
 */

 static const uint8_t ChargeThresholds[]={25,20,15,10,5};  // charge as percent
#define NumChrgLevels 4 // includes 0
#define CrticalCharge ChargeThresholds[NumChrgLevels]
static uint8_t ChargeThresholdNow; // thus indicates which to test against

 /* static uint8_t VoltageCriticalCount; - retired with the ratchet above */
 static uint8_t ChargeCriticalCount;

/* Publish the charger state to StatusByte, from the same two pins the ring
 * LED is driven from. Called once a second, immediately before the ring tick.
 *
 * It lives HERE rather than in power_control.c on purpose. That file is shared
 * with RGS_BringUp and deliberately knows nothing but pins - it includes
 * pin_manager.h and its own header, and no part of the EEPROM map. Publishing
 * from there would couple it to the memory layout and oblige BringUp to carry
 * that too, when every other EMULATE_EEPROM write in this application is
 * already made from main.c.
 *
 * Read-modify-write, so the six unused bits of the byte are preserved for
 * whatever claims them next.
 *
 * PWR_ChargeComplete() is only consulted while a charger is present, because
 * VER_0 means nothing without one - see the note in power_control.h. With the
 * charger gone both bits clear together. */
static void PublishChargerStatus(void)
{
    uint8_t status = EMULATE_EEPROM_Memory[StatusByteAddr];

    if (PWR_ChargerPresent())
    {
        status |= StatusChargerPresent;

        if (PWR_ChargeComplete())
            status |= StatusChargeComplete;
        else
            status &= (uint8_t)~StatusChargeComplete;
    }
    else
    {
        status &= (uint8_t)~(StatusChargerPresent | StatusChargeComplete);
    }

    EMULATE_EEPROM_Memory[StatusByteAddr] = status;
}


/* Progress indication while the battery pack is being reconfigured, which
 * takes the best part of ten seconds. Called once per golden-table entry via
 * BQ40Z50_ProgressHook, so it blinks at roughly the rate entries are written.
 *
 * Toggles RED only, leaving GREEN lit: steady green is "running", green with
 * a blinking red is "busy, do not pull the power". Entries already correct
 * are skipped without a 200 ms flash write, so the blink runs fast through
 * those and slow through the ones actually being written - which is a fair
 * representation of what is happening. */
static void BatteryConfigTick(void)
{
    BI_LED_RED_Toggle();
}


int main(void)
{
    /* ---- Cold start vs warm reset (REVIEW) --------------------------------
     * RCONbits.POR is set by the silicon ONLY on a genuine power-on; software
     * resets (bootloader handoff, firmware-update reset, InitSelfReset) and
     * the watchdog leave it clear -- PROVIDED we clear it once per power
     * cycle, which happens below at the point power-on is complete.
     *
     *   warmBoot == true : we were already running before this reset (e.g.
     *                      just came back from a firmware update). Re-latch
     *                      our own supply AND keep the Jetson's 5V alive
     *                      immediately -- microseconds after reset, before
     *                      SYSTEM_Initialize can let anything sag.
     *   warmBoot == false: genuine cold start. Touch nothing here; the
     *                      Jetson stays OFF and power-on follows the normal
     *                      charger-loop / button-hold flow.
     */
    /* POR and BOR both tested - a brown-out is a cold start. Must be the first
     * thing main() does, before anything touches RCON. */
    bool warmBoot = PWR_IsWarmBoot();

    PWR_EarlyRailHold(warmBoot);

    /* Lay down the firmware-owned part of the emulated EEPROM BEFORE
     * SYSTEM_Initialize(), because I2C1_Initialize() is inside it: from that
     * point the Jetson can read the table, and it must not be able to read a
     * table of zeros. Writing to EMULATE_EEPROM_Memory is just RAM, so it is
     * safe this early.
     *
     * Only the firmware-owned values - table version, running firmware
     * version, tick rate. Nothing per-unit is touched, so this cannot
     * interfere with the restore further down. */
    PopulateSelectedEEprom(FIRMWARE_RC, FIRMWARE_REV_MINOR,
                           FIRMWARE_REV_LSB, FIRMWARE_REV_MSB);

    SYSTEM_Initialize();
  
 

    LedOn=0;
    FrontSense=0;
    RearSense=0;
    TransitTime=0;
    GateTimeout=0;
    TaskIndex=0;
     
    /* The requested lamp state is set AFTER PERSIST_LoadToEeprom() further
     * down - the restore writes all 256 bytes, so setting it here would be
     * overwritten by whatever the jig stored (which is zero). */
    PWM_RB11_Init();
    PWM_RB11_Enable();
    PWM_RB11_SetDuty(10);
    I2C_WriteQueue_Init();
    // Explicit changes for new versions
    POWER_BUTTON_SetDigitalInput();
    
    /* PIN_MANAGER_Initialize (inside SYSTEM_Initialize) bulk-writes the
     * latches, momentarily dropping both rails; the external FET gates ride
     * through on capacitance. Re-assert them for this boot type. */
    PWR_RailsAfterInit(warmBoot);

    /* Cold start: button first, then a settled /ACOK - see power_control.c.
     * Returns powered and running. A warm boot - normally the hand-over after
     * a firmware upgrade - is already running, Jetson included, so it only
     * shows the three green flashes. */
    if (!warmBoot)
        PWR_ColdStartPowerOn();
    else
        PWR_ShowWarmRestart();

    /* Both paths are now "powered and running": show green. */
    BI_LED_GREEN_SetHigh();//Turn on Green LED
    BI_LED_RED_SetLow();//Turn off Red LED

    /* Power-on is complete: later resets in this power cycle read as warm. */
    PWR_MarkPowerOnComplete();

    /* The accelerometer cal values are pulled in further down, AFTER
     * PERSIST_LoadToEeprom(). They used to be read here, which was 55 lines
     * too early: the table had not been restored yet, so a calibrated unit
     * read back zeros and ran uncorrected. Nothing between here and there
     * uses them - first use is in the main loop. */

    FrontSensorOff;
    RearSensorOff;
    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;
    INTERRUPT_TO_JETSON_SetDigitalOutput();
 INTERRUPT_TO_JETSON_SetLow();
    
 //initialise the voltage and charge thresholds for battery manangement
 /* VoltageThresholdNow and VoltageCriticalCount went with the ratchet - see
  * the note beside their declarations. SOCV_Init() takes their place, and must
  * run before the first GetBattVolts(): its debounce counters and the latched
  * shutdown flag are file statics that have to start from a known state. */
 SOCV_Init();
 ChargeThresholdNow=0;
 ChargeCriticalCount=0;
 
 
 
 
    ClrWdt();

    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;
    INTERRUPT_GlobalEnable();   // this is an inline, in the interrupt manager header, so not a function call as such!
    PWM_RB11_Init();
    
  
    LightingUpdate=0;
    uint8_t bugout;
  
    char LastOnOff;
    LedOn=0;
    LastOnOff=0;
    uint32_t DebugTime;
  
    /* Ticks per second and the table/firmware version are set by
     * PopulateSelectedEEprom(), called before SYSTEM_Initialize() above. The
     * hand-written copies that used to sit here have gone: two places setting
     * the same bytes is how they drift apart. */

    /* Restore the configuration saved by the factory bring-up jig. Placed
     * BEFORE the PopulateSelectedEEprom() call below - the whole 256-byte
     * block is mirrored, so the firmware version is in it, and a unit must
     * report the version it is RUNNING, not the one current when the block was
     * saved.
     *
     * Returns false on a blank device (never brought up), leaving the values
     * from the early call in place. That is not an error, and there is nothing
     * useful to do about it here - this application has no console to report
     * it on - so the result is deliberately discarded. */
    PERSIST_LoadToEeprom();

    /* Re-assert the firmware-owned values over whatever the restore brought
     * back. Identical to the early call and to what RGS_BringUp does; it
     * touches nothing per-unit, so the restored calibration survives. */
    PopulateSelectedEEprom(FIRMWARE_RC, FIRMWARE_REV_MINOR,
                           FIRMWARE_REV_LSB, FIRMWARE_REV_MSB);

    /* The REQUESTED lamp state, until the Jetson says otherwise. All three on
     * is the gate's working default, and it has to be set because the
     * orientation recovery re-applies this byte: left at zero, the first return
     * to level would "restore" darkness. It drives nothing by itself - only a
     * dispatched SetLasers() job or AllLightsRestore() acts on it.
     *
     * Set HERE, after the restore, not up with the other start-up state: the
     * whole 256-byte block is mirrored, so an earlier write is overwritten by
     * the stored value - and the jig stores zero, which is exactly the "restore
     * darkness" case above. The coded default therefore wins at every boot and
     * the Jetson's request stays runtime state. */
    EMULATE_EEPROM_Memory[ConfigLasersAddr] = LaserState_LampsMask;

    /* Start the status byte from a known zero, and for the same reason as the
     * lamp default above: PERSIST_LoadToEeprom() mirrors the whole 256-byte
     * block, so this byte comes back as whatever the bring-up jig happened to
     * store - and the stored blocks predate the byte existing.
     *
     * It matters more than a stray bit usually would. A restored 0xFF would
     * have StatusChargeComplete set, and GetBattVolts() forces RemainingCharge
     * to 100% while that bit is up, so the gauge would read full until the
     * first charger sample corrected it. Zero here means "no charger, not
     * charged", which is the safe reading of an unknown state. */
    EMULATE_EEPROM_Memory[StatusByteAddr] = 0u;

    /* The temperature field, for exactly the same PERSIST reason: the stored
     * blocks predate it, so it comes back as whatever the jig happened to hold
     * and a restored 0xFFFF would publish 6553.5 K. Zero is this field's own
     * "not read yet" sentinel - impossible as a real temperature - which is
     * precisely what it is until GetBattVolts() first runs. */
    MAP_PackUInt16(BatteryTemperatureNotRead,
                   &EMULATE_EEPROM_Memory[Temp_dK_LSBAddr]);

    /* And the charging-voltage request, whose sentinel is 0xFFFF rather than
     * zero - zero is a real reading there, meaning the gauge is refusing
     * charge. Setting it to zero here would publish a refusal the gauge never
     * made, which is the one reading on this field nobody should invent. */
    MAP_PackUInt16(ChargingVoltageNotRead,
                   &EMULATE_EEPROM_Memory[ChargingVoltage_LSBAddr]);

    /* And OperationStatus, whose sentinel is all-ones for a third distinct
     * reason: all-ZEROES is a real and alarming status there, meaning both
     * FETs open. Publishing zero at start-up would report a pack that had shut
     * its FETs when in truth nothing had been read yet. */
    MAP_PackUInt16((uint16_t)OperationStatusNotRead,
                   &EMULATE_EEPROM_Memory[OpStatus_B0Addr]);
    MAP_PackUInt16((uint16_t)(OperationStatusNotRead >> 16),
                   &EMULATE_EEPROM_Memory[OpStatus_B2Addr]);

    /* Pull the accelerometer corrections into the working variables, now that
     * the register file holds the restored block.
     *
     * This MUST stay after the load - the same rule RGS_BringUp follows. Read
     * before it, these come back as zeros on a calibrated unit and the gate
     * runs uncorrected. First use is in the main loop, so here is early
     * enough. */
    xcal = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalX_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalX_LSB_Addr]);
    ycal = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalY_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalY_LSB_Addr]);
    zcal = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalZ_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalZ_LSB_Addr]);
 
   // INTERRUPT_TO_JETSON_SetLow();
    RestoreDetect();

    /* Free I2C2 before its first use. The pack FETs keep every I2C2 device
     * powered through a PIC reset, so one caught mid-transfer by the reset
     * can still be holding SDA low - and will stay that way, restart after
     * restart, until something clocks it out. BringUp does the same. */
    i2c2_bus_unwedge();
    LIS2DW12_Init_I2C2();    // TODO: should ensure it inits, or returns an error

    /* ---- Battery pack configuration ------------------------------------
     * Placed here because i2c2_bus_unwedge() above is the precondition for
     * any I2C2 traffic, and because nothing between here and the main loop
     * depends on the pack.
     *
     * Runs on a WARM boot as well as a cold one. A warm boot is the hand-over
     * after a firmware update, which is exactly when the configuration
     * version may have changed; skipping it there would leave an update that
     * alters battery parameters inert until the next cold start.
     *
     * The common path is cheap: three data flash reads to check the stamp,
     * two more for the gain. A pack whose stamp does not match is fully
     * reconfigured, which takes the best part of ten seconds - 25 entries at
     * BQ_T_DF_WRITE_MS (200 ms) each. That happens once per configuration
     * version per pack. The watchdog survives it because bq_delay_ms() clears
     * it every millisecond, but the user would otherwise see an unexplained
     * pause, so the red LED blinks against the steady green throughout.
     *
     * One attempt, no retry loop - the driver does its own bus recovery. If
     * the pack does not answer, the apply is skipped entirely and the next
     * boot tries again. A gate that will not start because the gauge was
     * asleep is a worse failure than one running on unverified config. */
    {
        bool stamped = false;

        if (BQ40Z50_CheckConfigStamp(&stamped) == BQ_OK && !stamped)
        {
            BQ40Z50_ProgressHook = BatteryConfigTick;
            if (BQ40Z50_ApplyGoldenImage() == BQ_OK)
                BQ40Z50_WriteConfigStamp();   /* stamp LAST, and only if clean */
            BQ40Z50_ProgressHook = NULL;
            BI_LED_RED_SetLow();              /* undo whatever the blink left */
        }

        /* Unconditional, every boot, stamped or not. The gains are table
         * entries too, but the table is only consulted when the stamp
         * mismatches - this is what catches a gain that goes bad on a pack
         * already marked as configured. Two reads, no writes, in the normal
         * case. */
        (void)BQ40Z50_EnsureSenseGain();
    }
  //  uint8_t id = 0x00;

  //BI_LED_RED_SetHigh();BI_LED_RED is RED!!!!!
  BI_LED_GREEN_SetHigh(); //BI_LED_GREEN is green!!!!
   for(bugout=0;bugout<5;bugout++)
            {
                //changes this to flashing red light
                BI_LED_GREEN_Toggle();  
                BI_LED_RED_Toggle();
                __delay_ms(10); 
                BI_LED_GREEN_Toggle();  
                BI_LED_RED_Toggle();
                __delay_ms(30); 
                ClrWdt();
                // restore green light
                BI_LED_GREEN_SetHigh();//Turn on Green LED
                BI_LED_RED_SetLow();//Turn off Red LED
            }
  PWM_IR_SetHigh();

    /* Lamps start OFF, and locked out by bit 6, until the orientation has been
     * READ at least once.
     *
     * The gate may have been powered up already tilted, and PIN_MANAGER_Initialize
     * leaves all three lamp pins driven low - lit, the drivers being inverted - so
     * anything lit here stays lit until the accelerometer task first runs a second
     * or more later. Starting dark means the beams cannot point somewhere they
     * should not during that window.
     *
     * Setting bit 6 arms the existing recovery path: the first reading that is
     * within tolerance clears it and calls AllLightsRestore(), which lights
     * everything. A reading out of tolerance finds bit 6 already set and simply
     * leaves the lamps dark. See GetAccel(). */
    EMULATE_EEPROM_Memory[LaserStateAddr] |= 0x40;
    AllLightsOff();

    while(1)
    {   
       
       /* Ends the ring LED's 100 ms "charged" pulse without blocking. */
       PWR_RingService();

       /* Debounced, so a glitch on the line cannot start a power-down. Costs
        * one sample per loop while the button is idle; while it is pressed the
        * ring LED flashes fast. */
       if(PWR_ButtonStable(true, PWR_BUTTON_SETTLE_MS))
         PowerDown(ButtonPwrDwn);

        if(DoTask) //this is set periodically by the TMR2 interrupt. Nominally 1 second.
            {
                DoTask=0; // this will re-set itself in 1 second
                if (EMULATE_EEPROM_Memory[PowerOffFlag]==ImmediatePowerOff)
                    AllPowerDown();

                /* Once a second: sample the charger, publish it to StatusByte,
                 * and set the ring LED. Both read the same two pins, so they
                 * are kept adjacent - the LED and the published byte should
                 * never disagree about what the charger is doing.
                 *
                 * This runs BEFORE the round-robin task below, which is what
                 * makes the 100% override in GetBattVolts() sound: the status
                 * byte is always current when the battery task reads it. */
                PublishChargerStatus();
                PWR_RingChargeTick();
                if(SelfResetTimeout)// if the first part of reset been issued, it needs to be completed within 10 seconds or is cancelled.
                {
                    /* Post-decrement tested the value BEFORE decrementing, so
                     * the count went 10..1 and then to 0 with the test never
                     * true; on the next tick the outer if was false, so
                     * CancelReset() was unreachable. An armed request therefore
                     * stayed armed for ever - red LED and all - instead of
                     * lapsing after 10 s. Decrement FIRST, cancel on zero. */
                    if(--SelfResetTimeout == 0)
                        CancelReset();
                }
                             
                TaskWarning=Task[TaskIndex](); 
                TaskIndex++;
                if(TaskIndex>=NUM_Tasks)
                    TaskIndex=0;
             }
       if(TaskWarning)
           HandleTaskWarning(TaskWarning);
 //----------------------------------
// -- check to see if an i2c 'write' - ie job load is pending             
        if(EventJob.i2cQueJobWaiting)
        {
            if(I2C_WriteQueue_Pop(&LoadJobFromEEprom)) 
            {
                if(!JobQueue_Push(LoadJobFromEEprom.start_address))
                   queuepanic=1;// TODO: add handle to this to tell jetson last job bombed
                
            }
            
        }    
//------------------------------------

//------------------------------------
//-- check and do if a job is waiting  
    if(EventJob.JobWaiting) 
    {
      JobQueue_Pop();  
    }        
            
       //add power bit...
        if (LedOn)
        {
            if(FrontSense)
            { 
             BI_LED_RED_SetHigh();   //Red LED on        
           //  LOCAL_STATUS_LED_SetHigh();
             BI_LED_GREEN_SetLow();//green LED off
            FrontSense=0;
            }
            
            if(RearSense)
            {
                
               // LOCAL_STATUS_LED_SetLow();
                EMULATE_EEPROM_Memory[0] = (uint8_t)(TransitTime >> 24);  // Most significant byte
                EMULATE_EEPROM_Memory[1] = (uint8_t)(TransitTime >> 16);
                EMULATE_EEPROM_Memory[2] = (uint8_t)(TransitTime>> 8);
                EMULATE_EEPROM_Memory[3] = (uint8_t)(TransitTime);  
                RearSense=0;
                CallJetsonBall();
                // wait a bit....
                // turn off red light, turn on green light
                RestoreDetect();
                TMR2_Start();
                BI_LED_RED_SetLow();   //Red LED off       
           //  LOCAL_STATUS_LED_SetHigh();
             BI_LED_GREEN_SetHigh();//green LED on    
            }
            LedOn=0;
        }
        
        if(GateTimeout)
        {   
            BI_LED_RED_SetLow(); 
            BI_LED_GREEN_SetHigh();//green LED off      

            DebugTime=TransitTime;
            EMULATE_EEPROM_Memory[0] = 255;  // Most significant byte
            EMULATE_EEPROM_Memory[1] = 254;
            EMULATE_EEPROM_Memory[2] = 253;
            EMULATE_EEPROM_Memory[3] = 252; 
            CallJetsonBall();
            GateTimeout=0;
            //Just flashes on board LED, make this external indicator
            for(bugout=0;bugout<10;bugout++)
            {
                //changes this to flashing red light
                BI_LED_GREEN_Toggle();  
                BI_LED_RED_Toggle();
                __delay_ms(50); 
                BI_LED_GREEN_Toggle();  
                BI_LED_RED_Toggle();
                __delay_ms(150); 
                ClrWdt();
                // restore green light
                BI_LED_GREEN_SetHigh();//Turn on Green LED
                BI_LED_RED_SetLow();//Turn off Red LED
            }
            
            GateTimeout=0;
            FrontSense=0;
            RearSense=0;
            TMR4_Initialize ();
            RestoreDetect();
            TMR2_Start();
                      
        }
 
    }
} 


///End of int main(void)    


///functions, TBD other headers etc

void CallJetsonBall(void)
{
    
     BALL_DETECT_INT_SetHigh();
    __delay_ms(10);
    BALL_DETECT_INT_SetLow();
  //  __delay_ms(10);
   // BALL_DETECT_INT_SetHigh();
  //  __delay_ms(10);
 //   BALL_DETECT_INT_SetLow();
  //  __delay_ms(10);  
}
#define powerdowntest
#ifdef powerdowntest
void CallJetsonJob(void)
{
    FrontSensorOff;
    RearSensorOff;
    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;

    LOCAL_STATUS_LED_SetLow(); //turn the LED off 
    INTERRUPT_TO_JETSON_SetHigh();
    __delay_ms(10);
    INTERRUPT_TO_JETSON_SetLow();
    //ensure Jetson heartbeat is high
    while(!JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(10);
        ClrWdt();
    }
    LOCAL_STATUS_LED_SetHigh();  //high again when heartbeat seen
    while(JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(100);
        ClrWdt();
        BI_LED_GREEN_Toggle();
    };
    BI_LED_GREEN_SetLow();
    //we should have had the jetson acknowledge by now, so turn off
  //  JETSON_5V_ON_SetLow();
   
    while(!JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(100);
        ClrWdt();
        BI_LED_GREEN_Toggle();
    };
       
       RestoreDetect();
}
#endif









//void LIS2DW12_SetAddress_I2C2(uint8_t addr)
//{
    
//}

/* ---- Low-level helpers using ONLY your TRB API ---- */

/* Proper repeated-start via TRB pair: write(reg) then read(n) */
/* Preferred: repeated-start via TRB pair. Falls back to STOP (write then read). */
/* ---- High-level sensor ops ---- */

uint8_t QuickAcellerometerGrabber(void)
{
    int16_t pitch;
    int16_t roll;
    
   
        ClrWdt();
        int16_t x, y, z;

        /* Re-align the sensor to the frame ComputePitchRoll() expects:
         *      x = sensorY,  y = sensorX,  z = -sensorZ
         *
         * The accelerometer is on the underside of the PCB, so it sits
         * upside down with its Y toward the rear and X to the right - hence
         * the swapped arguments below.
         *
         * The Z negation is not cosmetic. The sensor reads about -1g on Z
         * with the board level, while atan2(y, z) needs z POSITIVE when
         * level. It also keeps the frame right-handed: the X/Y swap on its
         * own has determinant -1, a mirror rather than a rotation, which
         * reads correctly while level (both swapped axes ~0) and goes wrong
         * as soon as the board is tilted. Swap plus one negation is
         * determinant +1, a real rotation.
         *
         * MUST match RGS_BringUp's copy of this function - same sensor, same
         * board. There was a `roll_deg += 180` inside ComputePitchRoll()
         * compensating for the missing remap here; it has been removed, so
         * without this PuttingGate would read roll near +/-180 when level. */
        if (LIS2DW12_ReadXYZ_I2C2(&y, &x, &z))
        {

            /* Mounting-tilt cancellation, horizontal components only.
             *
             * ADDED, not subtracted. RGS_BringUp computes the stored value as
             * xcal = xcal - x while sitting level, so it already carries the
             * sign needed to cancel the offset. Subtracting it here applied
             * the correction BACKWARDS - doubling the mounting error instead
             * of removing it, so a calibrated unit read worse than an
             * uncalibrated one. Must stay in step with RGS_BringUp's copy.
             *
             * Z is deliberately NOT corrected. It carries the 1g reference
             * that pitch and roll are measured against, so offsetting it makes
             * atan2(y, z) ill-conditioned - roll flips to +/-180 on noise once
             * z nears zero - and the accumulated offset runs into the int16
             * limit. Nulling X and Y is enough to make a level board read zero
             * on both angles. zcal is stored only so it can be read back and
             * inspected; it is not applied. */
            x=x+xcal;
            y=y+ycal;

        z = (int16_t)(-z);
        uint16_t ux = (uint16_t)x;
        uint16_t uy = (uint16_t)y;
        uint16_t uz = (uint16_t)z;
       // raw values
        
        // Pack as [X_H, X_L, Y_H, Y_L, Z_H, Z_L]
        EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]  = (uint8_t)(ux >> 8);
         EMULATE_EEPROM_Memory[Accl_X_MSB_Addr] = (uint8_t)(ux);
         EMULATE_EEPROM_Memory[Accl_Y_LSB_Addr] = (uint8_t)(uy >> 8);
         EMULATE_EEPROM_Memory[Accl_Y_MSB_Addr] = (uint8_t)(uy);
         EMULATE_EEPROM_Memory[ Accl_Z_LSB_Addr] = (uint8_t)(uz >> 8);
         EMULATE_EEPROM_Memory[Accl_Z_MSB_Addr] = (uint8_t)(uz);
        

            /* use raw counts; scale later if needed */
        }
        else // if it fubars, then just fill with 0xFF;
        {
        EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]  = 0xFF;
         EMULATE_EEPROM_Memory[Accl_X_MSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[Accl_Y_LSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[Accl_Y_MSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[ Accl_Z_LSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[Accl_Z_MSB_Addr] = 0xFF;
        }
        
        
       ComputePitchRoll(x,y,z,&pitch,&roll);
        uint16_t upitch = (uint16_t)pitch;
    uint16_t uroll  = (uint16_t)roll;
 
    
       EMULATE_EEPROM_Memory[PitchLSB_Addr] = (uint8_t)(upitch >> 8);
       EMULATE_EEPROM_Memory[PitchMSB_Addr] = (uint8_t)(upitch);
       EMULATE_EEPROM_Memory[RollLSB_Addr] = (uint8_t)(uroll >> 8);
       EMULATE_EEPROM_Memory[RollMSB_Addr] = (uint8_t)(uroll);
       
       if ((abs(pitch)>455)||(abs(roll)>455))
       {
           if (!(EMULATE_EEPROM_Memory[LaserStateAddr]&0x40))
           {
               EMULATE_EEPROM_Memory[LaserStateAddr]|=0x40;
               AllLightsOff();
           }
           return(1);  // indicates unacceptable orientation
       }
           // indicates unacceptable orientation
       else
       {
           if (EMULATE_EEPROM_Memory[LaserStateAddr]&0x40)
           {
             EMULATE_EEPROM_Memory[LaserStateAddr]&=0xBF;
             AllLightsRestore();
           }
            
       }
           
       return(0); 
       
       
         
         //TODO: Note-- this is a blocker, just testing 
#ifdef waitack
       while((EMULATE_EEPROM_Memory[JetsonAcknowledgeCall_Addr]!=GateInvalidOrientation))
         {
             BI_LED_RED_SetHigh();
             BI_LED_GREEN_SetLow();
             
             ClrWdt();
             __delay_ms(100);
         }
         EMULATE_EEPROM_Memory[JetsonCallingCode_Addr]= 0;
         EMULATE_EEPROM_Memory[JetsonAcknowledgeCall_Addr]= 0;
#endif 
       
 
       
       
}

//refactor into a general purpose button thing...
void PowerDown(bool ForcePowerDown)
{ 
  
    
    if (!ForcePowerDown)  // we could be here from a direct call or button push.... 
        if (!PWR_ButtonHold(Off))          /* released too soon: nothing happens */
        {
            return;
        }

        //AllPowerDown(); -- use the handler rather than direct call
        HandleTaskWarning(PowerOff_1_min);


    /* Not reached in practice: HandleTaskWarning(PowerOff_1_min) runs
     * AllPowerDown(), which never returns, and a too-short hold returned above.
     * Left as AMBER in case that ever changes, so a rogue state is visible. */
    BI_LED_GREEN_SetHigh();
    BI_LED_RED_SetHigh();
    return;

}



 
// ---- PWM on RB11 via OC3 / T3 ----
// T3 runs at 100kHz (PR3=159, FCY=16MHz, prescaler 1:1)
// OC3 in PWM mode (no fault), OCTSEL=1 (T3)
// RB11 already mapped to OC3 in pin_manager.c

void PWM_RB11_Init(void)
{
    // T3: 16-bit, 1:1 prescaler, 100kHz
    TMR3  = 0x0000;
    PR3   = PWM_RB11_PERIOD;
    T3CON = 0x8000;         // TON=1, TCKPS=1:1, internal clock

    // OC3: PWM mode without fault, timer source = T3 (OCTSEL=1)
    OC3R   = 0;             // initial duty = 0
    OC3RS  = 0;             // shadow register = 0
    OC3CON = 0x0000;        // disabled until PWM_RB11_Enable() called
}

void PWM_RB11_Enable(void)
{
    OC3CON = 0x000E;        // OCM=110 (PWM no fault), OCTSEL=1 (T3)
}

void PWM_RB11_Disable(void)
{
    OC3CON = 0x0000;        // OCM=000, output disabled
}

void PWM_RB11_SetDuty(uint8_t duty)
{
    // in this implementation, we have 0-160 as our range, so 0.625% per bit
    if (duty > 160) duty = 160;
    OC3RS = (uint16_t)duty;
    
}

// ---- End PWM RB11 ----
// round robin tasks ...
/// normal tasks list, 'Standard'
/// alternative, test builds are 'Test1' and 'Test2'

/* The round-robin tasks flick the bi-colour LED red while they run, as a sign
 * of life - deliberately brief, and only visible if you look for it.
 *
 * They used to finish by setting it back to GREEN unconditionally, which quietly
 * destroyed whatever state the rest of the system had put there: within a second
 * of InitSelfReset() showing red for an armed reset request, a task tick wiped
 * it. That made the LED useless as a state indicator and made the loader's
 * "verify LED is RED" prompt lie. Save the state on entry, restore it on every
 * exit, and the flick costs nothing it does not own. */
static uint8_t LedStateSave(void)
{
    return (uint8_t)((BI_LED_GREEN_GetValue() ? 0x01u : 0x00u)
                   | (BI_LED_RED_GetValue()   ? 0x02u : 0x00u));
}

static void LedStateRestore(uint8_t state)
{
    if (state & 0x01u)
        BI_LED_GREEN_SetHigh();
    else
        BI_LED_GREEN_SetLow();

    if (state & 0x02u)
        BI_LED_RED_SetHigh();
    else
        BI_LED_RED_SetLow();
}

/* Read a two-byte SBS word from the gauge and publish it LSB-first at `addr`.
 * Returns false, and leaves the two published bytes ALONE, if the gauge will
 * not answer: a dropped transaction then shows as a stale figure rather than a
 * fabricated zero. The caller raises BatteryPackCommsFailure, which is what
 * says the published figures may be old.
 *
 * Used by the temperature and charging-voltage reads, and deliberately NOT by
 * the pack voltage and current reads above them. Those two differ in ways that
 * matter: the voltage read returns early on failure, because nothing further
 * down GetBattVolts() may run without a real voltage, and the current read
 * leaves its result in `raw` for SOCV_Update() to unpack. Folding either into
 * this would change proven behaviour in a function that has had subtle bugs
 * before - see the parked RSOC note - for no gain.
 *
 * Its own buffer, so a value it reads can never be left in a caller's. That is
 * the whole trap the RSOC note describes.
 */
static bool PublishGaugeWord(uint8_t cmd, uint8_t addr)
{
    uint8_t buf[2];

    if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, cmd, buf, 2))
    {
        i2c2_bus_unwedge();
        if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, cmd, buf, 2))
            return false;
    }

    EMULATE_EEPROM_Memory[addr]     = buf[0];   /* LSB */
    EMULATE_EEPROM_Memory[addr + 1] = buf[1];   /* MSB */
    return true;
}

/* Read total pack voltage from the BQ40Z50 and publish it for the Jetson.
 *
 * SBS Voltage() (0x09) returns total pack millivolts as a 16-bit word, LSB
 * first. The memory map stores 16-bit values LSB-at-the-lower-address too -
 * the same convention MAP_PackInt16() implements - so the two bytes go
 * straight across without reordering.
 *
 * Read directly rather than through bq40z50.c even though that driver IS in
 * this project's build (with -DBQ_VERBOSE=0): Voltage() needs no unseal and no
 * ManufacturerAccess, so a plain register read is the whole job and going
 * through the driver would buy nothing. The claim that the driver was absent
 * was left over from before it was added, and was the same stale statement
 * already corrected at its include.
 *
 * NOTE: the previous version of this function read a different device (0x36)
 * and wrote the result to EMULATE_EEPROM_Memory[8] and [9] - which are
 * Accl_Z_LSB_Addr and Accl_Z_MSB_Addr. It was overwriting the accelerometer's
 * Z reading with battery data. The destination is now BatteryPackVoltage_Addr,
 * which is what the map reserves for it.
 */
uint16_t GetBattVolts(void)
{
    uint8_t raw[2];
    uint16_t voltagemv;
    /* STATIC, and initialised. The flags are cleared and set across calls -
     * see the BatteryPackCommsFailure clear just below - which only works if
     * the value survives from one call to the next. As a plain local it was
     * whatever the stack happened to hold, so a garbage bit 0 read as
     * PowerOff_1_min and HandleTaskWarning() ran AllPowerDown() within
     * seconds of every boot. */
    static uint16_t warning = 0;
    /* uint8_t FuelGuagePercent; - was the destination for the parked RSOC read
     * below, and never assigned. Restore it with that read if it is revived. */
    uint8_t ledWas = LedStateSave();
    BI_LED_GREEN_SetLow();//Turn off Green LED
    BI_LED_RED_SetHigh();//Turn on Red LED
    ClrWdt();

    
    warning&=~BatteryPackCommsFailure; // Clear the comms error, even if there wasnt' one
    /* Read once; if that fails, free the bus, reset the driver and try again.
     * The unwedge also drops any transfer the failed read left queued, which
     * would otherwise go on making later I2C2 requests fail instantly. */
    if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_VOLTAGE, raw, 2))
    {
        i2c2_bus_unwedge();
        if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_VOLTAGE, raw, 2))
        {
            /* Still no reading. Leave the published voltage as it was - stale
             * is less misleading than a sudden zero, which would read as a
             * flat pack - and skip the thresholds: raw was never filled, so
             * judging it would act on whatever was left on the stack, and
             * could walk the unit towards a false power-off. */
            LedStateRestore(ledWas);
            warning|=BatteryPackCommsFailure;
            return(warning);
        }
    }

    /* Reached only when a read SUCCEEDED - first time, or on the retry after
     * an unwedge. This used to be an else on the outer if, which meant a
     * first read that failed and then RETRIED SUCCESSFULLY skipped the store
     * entirely: the published voltage stayed stale and voltagemv kept
     * whatever was on the stack, which the thresholds below then judged - and
     * a low enough garbage value walks the unit to a false power-off. */
    EMULATE_EEPROM_Memory[BatteryPackVoltage_Addr]     = raw[0];  /* LSB */
    EMULATE_EEPROM_Memory[BatteryPackVoltage_Addr + 1] = raw[1];  /* MSB */
    voltagemv = MAP_UnpackInt16(raw);

    /* The voltage thresholds are judged by SOCV_Update() further down, not
     * here: it needs the pack current as well, which is not read until below.
     * See the retired-ratchet note beside the declarations at the top. */

    /* ---- The gauge's own RSOC read: PARKED 2026-11-05 ----
     *
     * Left commented rather than removed, because it is worth logging the
     * gauge's figure against the voltage estimate once Impedance Track has
     * actually learned something - at which point this becomes the better
     * number and the voltage curve becomes the fallback.
     *
     * As written it was dead twice over: nothing stored the result (raw was
     * reused by the current read below, and FuelGuagePercent was never
     * assigned), and the gauge has learned nothing yet - Update Status reads
     * 0x04, enabled but with no learned data - so RSOC was a voltage guess
     * made by the gauge rather than a measurement.
     *
     * It was not harmless. The early return on a failed read skipped the
     * current read entirely, so a gauge that would not answer RSOC also
     * stopped the pack-current publication at addresses 21/22. If this is
     * ever re-enabled, store the result BEFORE the current read and drop the
     * early return, or that defect comes back with it.
     *
     *   if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_RSOC, raw, 2))
     *   {
     *       i2c2_bus_unwedge();
     *       if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_RSOC, raw, 2))
     *       {
     *           LedStateRestore(ledWas);
     *           warning|=BatteryPackCommsFailure;
     *           return(warning);
     *       }
     *   }
     */

    /* Instantaneous pack current, mA, SIGNED - negative is discharge. Byte
     * order matches the voltage store above: SMBus returns LSB first, so
     * raw[0] goes to the lower address.
     *
     * Same read-unwedge-retry as the voltage read, but it deliberately does
     * NOT return early on failure. An early return would skip the ClrWdt()
     * that follows, and it would also skip SOCV_Update() - which judges the
     * SHUTDOWN, and must not be silenced by a missing current reading it does
     * not even use yet. A failed read leaves the previously published value in
     * place, which is stale rather than wrong, and passes 0 to SOCV below.
     *
     * Reuses raw, so any future RSOC store must happen BEFORE this point. */
    bool gotCurrent = i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_CURRENT, raw, 2);
    if (!gotCurrent)
    {
        i2c2_bus_unwedge();
        gotCurrent = i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_CURRENT, raw, 2);
    }

    if (gotCurrent)
    {
        EMULATE_EEPROM_Memory[Current_mA_LSBAddr] = raw[0];  /* LSB */
        EMULATE_EEPROM_Memory[Current_mA_MSBAddr] = raw[1];  /* MSB */
    }
    else
    {
        warning |= BatteryPackCommsFailure;
    }

    /* ---- The two readings that explain the CHARGING side ----
     *
     * Added 2026-11-05, chasing charge terminating at about 15.8 V. Neither is
     * used by anything on the PIC; both exist so the condition is diagnosable
     * from the Jetson instead of only on the bench with an EV2400.
     *
     * Temperature(), 0.1 K UNSIGNED - and with the golden image's BENCH config
     * (Temperature Enable 0x01, Mode 0x00) it is the gauge's own DIE, reported
     * as the cell temperature. That single figure selects the charge voltage
     * band AND gates OTC and UTC, either of which opens the charge FET, which
     * is why one number is worth two bytes of map. Zero is its "never read"
     * sentinel: 0 K cannot happen.
     *
     * ChargingVoltage(), mV UNSIGNED - what the gauge is actually ASKING the
     * charger for, so 16800 / 16400 / 16000 for the three bands. This is the
     * authoritative form of the question the temperature only lets you infer,
     * because the band table lives in a data flash capture that nothing here
     * can verify. Its sentinel is 0xFFFF, NOT zero: zero is a real reading
     * meaning the pack is refusing charge outright, which is precisely the
     * case worth seeing. See both fields in EEpromBlockLabels.h.
     *
     * Order matters only in that both must come AFTER the current store above,
     * which still owns `raw`. PublishGaugeWord() uses its own buffer, so
     * neither can disturb it.
     */
    if (!PublishGaugeWord(BQ_CMD_TEMPERATURE, Temp_dK_LSBAddr))
        warning |= BatteryPackCommsFailure;

    if (!PublishGaugeWord(BQ_CMD_CHARGING_VOLTAGE, ChargingVoltage_LSBAddr))
        warning |= BatteryPackCommsFailure;

    /* ---- And the one reading that is a FACT rather than an inference ----
     *
     * OperationStatus carries the LIVE FET states. The two reads above let you
     * deduce that charge is not flowing and that the gauge is declining it;
     * only bit 2 here says whether the charge FET is actually open. Added
     * 2026-11-05 after charge current sat below 10 mA for an extended period
     * and the question "is the CHG FET off?" could not be answered from the
     * map at all.
     *
     * NOT a plain register read, unlike everything else in this function. A
     * MAC subcommand means block-WRITING 0x0054 to ManufacturerBlockAccess and
     * then reading the reply, so this is the first periodic write the app makes
     * to the gauge. 0x0054 is a read-only status query - it changes no gauge
     * state, touches no data flash and causes no flash wear - and the same
     * mechanism already runs three times at every boot inside
     * BQ40Z50_CheckConfigStamp(). What is new is only the frequency.
     *
     * Through bq40z50.c rather than i2c2_read_regs(), because the block
     * protocol with its length byte and echoed subcommand is exactly what that
     * driver already implements and RGS_BringUp already exercises. Nominally
     * about 15 ms; the worst case is bounded by BQ_RETRY_MAX and every wait in
     * that path clears the watchdog, so a gauge that will not answer cannot
     * push this function past the ~2.1 s timeout.
     *
     * On failure the published bytes are left ALONE, as with the two reads
     * above: stale beats inventing a status, and inventing this one would mean
     * reporting FET positions that were never measured.
     */
    {
        uint32_t opstat;

        if (BQ40Z50_ReadMAC32(BQ_MAC_OPERATION_STATUS, &opstat) == BQ_OK)
        {
            MAP_PackUInt16((uint16_t)opstat,
                           &EMULATE_EEPROM_Memory[OpStatus_B0Addr]);
            MAP_PackUInt16((uint16_t)(opstat >> 16),
                           &EMULATE_EEPROM_Memory[OpStatus_B2Addr]);
        }
        else
        {
            warning |= BatteryPackCommsFailure;
        }
    }

    /* ---- State of charge, and the battery warnings ----
     *
     * Reached only on a successful VOLTAGE read: both failure paths above
     * returned early, so voltagemv holds a real reading and not whatever was
     * on the stack. That matters more here than it did for the old ratchet,
     * because a low enough garbage value now walks straight to a power-down.
     *
     * soc_voltage.c owns all four battery warning bits from here on, and
     * recomputes them from scratch every call with its own debounce and
     * hysteresis. `warning` is STATIC and latching, so its previous copies of
     * those bits must be cleared before the merge or a bit SOCV has decided to
     * drop would stay asserted for ever - which is precisely the failing the
     * ratchet's coarse ">=14300 having passed two levels" escape existed to
     * work around. Any new SOCV warning bit must be added to that mask too.
     * BatteryPackCommsFailure is deliberately NOT cleared here: it is managed
     * at the top of this function and by the current and temperature reads
     * above.
     *
     * The current is passed for completeness - soc_voltage.c does not use it
     * yet, see the load-compensation note in its header. A failed current read
     * passes 0 rather than skipping the update: the voltage is what the lookup
     * needs, and suppressing the shutdown judgement over a missing current
     * reading would be the dangerous way round. */
    SOCV_Update(voltagemv, gotCurrent ? MAP_UnpackInt16(raw) : 0);

    warning &= ~(LowBatteryWarning | LowBatteryCritical |
                 PowerOff_10_min | PowerOff_1_min);
    warning |= SOCV_Warnings();

    /* A charger reporting "fully charged" overrides the indicator: report
     * 100%, whatever the voltage curve made of it.
     *
     * This has to come AFTER SOCV_Update(), which writes RemainingChargeAddr
     * itself. Setting 100 anywhere earlier - in PublishChargerStatus(), say -
     * would simply be overwritten the next time the battery task ran, and the
     * gauge would alternate between 100 and the curve's reading once every two
     * seconds. Last writer wins, so the last writer has to be this one.
     *
     * The warnings above are deliberately NOT suppressed. They are driven by
     * pack voltage, and a pack sitting on a charger is nowhere near them; if
     * one ever did assert while charging, that is worth knowing rather than
     * hiding. StatusChargeComplete not latching is what keeps this honest -
     * see the bit definitions in EEpromBlockLabels.h. */
    if (EMULATE_EEPROM_Memory[StatusByteAddr] & StatusChargeComplete)
        EMULATE_EEPROM_Memory[RemainingChargeAddr] = 100u;

    ClrWdt();
    LedStateRestore(ledWas);
    return(warning);
}

uint16_t GetAccel(void)
{
    uint16_t warning;       /* 16 bits, as returned to TaskWarning */
    uint8_t ledWas;
    warning=0;

    ledWas = LedStateSave();

    BI_LED_GREEN_SetLow();//Turn off Green LED
    BI_LED_RED_SetHigh();//Turn on Red LED
    if(QuickAcellerometerGrabber())   //returns any non zero for warning
        warning=GateInvalidOrientation;
    LedStateRestore(ledWas);
    return(warning);
}


//HandleTaskWarning is maybe not best/exclusive name, as can be used by other bits of system.

void HandleTaskWarning(uint16_t code)

{
    WarnCodeToJetson(code);  // Set warning code and flap interrupt to Jetson

    if (code & PowerOff_1_min)          /* Jetson power removed in 1 minute, shut down */
    {
        AllPowerDown();
        return;  //might as well!
    }
/*
    if (code & LowBatteryWarning)       //
    {
        
    }
    */
/*
    if (code & LowBatteryCritical)      //Warn user, may shut down soon 
    {
        AllPowerDown();
    }*/

    if (code & BallStrike)              /* Impact event, orientation largely unaffected */
    {
        
    }

    if (code & GateMoving)              /* Gate picked up; lasers off until orientation settles */
    {
        //AllLightsOff();
    }

    if (code & GateInvalidOrientation)  /* Tilt greater than TBD X degrees */
    {
        //AllLightsOff();
    }
}
    

    


void AllPowerDown (void)
{
    /* The application's part: lasers and lighting off. The countdown, the
     * rails and the still-powered failsafe are shared with RGS_BringUp - see
     * power_control.c. Never returns. */
    AllLightsOff();
    PWR_ShutdownCountdownAndOff();
}

void AllLightsOn (void)
{
    EMULATE_EEPROM_Memory[LaserStateAddr] &= (uint8_t)~LaserState_LampsOff;
    LampsApply(LaserState_LampsMask);   // all three - refused if locked out
    RestoreDetect();
}

void AllLightsOff (void)
{

    FrontSensorOff;
    RearSensorOff;
    EMULATE_EEPROM_Memory[LaserStateAddr] |= LaserState_LampsOff;
    LampsApply(0);               // always permitted, lockout or not
}

/* Puts the lights back ON after an excursion - unconditionally.
 *
 * It used to drive each lamp from bits 0-2 of LaserState, but nothing in this
 * application ever SETS those bits: the only writer is SetLasers() in
 * job_queue.c, which runs on a Jetson write to address 128. On a unit the
 * Jetson had not configured lighting for, the bits read zero and "restore"
 * switched everything off - the ball-detect beam went out on the first tilt and
 * never came back.
 *
 * "All on" is the default this gate wants, so restore now simply does that.
 * The trade is deliberate: lighting the Jetson had turned off before an
 * excursion comes back on when the gate returns to level. */
void AllLightsRestore(void)
{
    /* DEFERRED, not discarded. Re-applies the REQUEST in ConfigLasersAddr, so
     * the gate returns either to the state it was in before the excursion or to
     * whatever the Jetson asked for WHILE it was out of level - a request
     * LampsApply() refused at the time but left recorded in that byte.
     *
     * The caller must have cleared LaserState_OrientFault already, or
     * LampsApply() will refuse this too. The orientation check does. */
    EMULATE_EEPROM_Memory[LaserStateAddr] &= (uint8_t)~LaserState_LampsOff;
    LampsApply(EMULATE_EEPROM_Memory[ConfigLasersAddr]);
    RestoreDetect();
}

void WarnCodeToJetson(uint16_t WarnCode)
{
    uint16_t CurrentStatus;
    
    
      // Set the code to inform the something has changed.
    // jetson then knows where to look by reading EMULATE_EEPROM_Memory[CallJetsonCode_Addr]
       CurrentStatus= MAP_UnpackUInt16(&EMULATE_EEPROM_Memory[CallJetsonCode_LSB]);  // get the current status
       CurrentStatus |= WarnCode;// TODO: Do we want to check if this is already set? set the bit
       MAP_PackUInt16(CurrentStatus,&EMULATE_EEPROM_Memory[CallJetsonCode_LSB]); //write it back
       
        // Interrupt the jetson - it should read the read the code and know what to do.
        INTERRUPT_TO_JETSON_SetHigh();
        __delay_ms(10);
        INTERRUPT_TO_JETSON_SetLow();   
}

void ClearWarnCodeToJetson(uint16_t WarnCode)
{
    uint16_t CurrentStatus;
      // Set the code to inform the something has changed.
    // jetson then knows where to look by reading EMULATE_EEPROM_Memory[CallJetsonCode_Addr]
    
       CurrentStatus= MAP_UnpackUInt16(&EMULATE_EEPROM_Memory[CallJetsonCode_LSB]);  // get the current status
       CurrentStatus &= ~WarnCode;// TODO: Do we want to check if this is already set?   Clear the bit if set.
       MAP_PackUInt16(CurrentStatus,&EMULATE_EEPROM_Memory[CallJetsonCode_LSB]); //write it back
               
        // Interrupt the jetson - it should read the read the code and know what to do.
        INTERRUPT_TO_JETSON_SetHigh();
        __delay_ms(10);
        INTERRUPT_TO_JETSON_SetLow();   
}



