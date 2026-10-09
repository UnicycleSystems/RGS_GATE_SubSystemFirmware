
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
/* For BQ40Z50_I2C_ADDRESS and BQ_CMD_VOLTAGE only - bq40z50.c is NOT in this
 * project's build. That driver is heavily instrumented with UART reporting,
 * which the field application neither initialises nor has the flash to spare
 * for. The one word we need is a plain SBS read we can do directly. */
#include "../CommonFiles/header/bq40z50.h"


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
uint8_t GetBattVolts(void);
uint8_t GetAccel(void);

typedef uint8_t (*TaskFn)(void);
TaskFn Task[]={GetAccel,GetBattVolts};

#define NUM_Tasks (sizeof(Task)/sizeof(Task[0]))

uint8_t TaskIndex;
uint8_t TaskWarning;
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
 static const uint16_t VoltageThresholds[]={14300,14100,14000,13800,13400,13300}; // voltages in millvolts
#define NumVoltLevels 5  // includes 0, so six items
#define CriticalVoltage VoltageThresholds[NumVoltLevels]
static uint8_t VoltageThresholdNow;  // thus indicates which one to test against
 
 static const uint8_t ChargeThresholds[]={25,20,15,10,5};  // charge as percent
#define NumChrgLevels 4 // includes 0
#define CrticalCharge ChargeThresholds[NumChrgLevels]
static uint8_t ChargeThresholdNow; // thus indicates which to test against

 static uint8_t VoltageCriticalCount;
 static uint8_t ChargeCriticalCount;
 
 

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
 VoltageThresholdNow=0;
 ChargeThresholdNow=0;
 VoltageCriticalCount=0;
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

                /* Once a second: sample the charger and set the ring LED. */
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

/* Read total pack voltage from the BQ40Z50 and publish it for the Jetson.
 *
 * SBS Voltage() (0x09) returns total pack millivolts as a 16-bit word, LSB
 * first. The memory map stores 16-bit values LSB-at-the-lower-address too -
 * the same convention MAP_PackInt16() implements - so the two bytes go
 * straight across without reordering.
 *
 * Read directly rather than through bq40z50.c: that driver is not in this
 * project's build, and Voltage() needs no unseal and no ManufacturerAccess,
 * so a plain register read is the whole job.
 *
 * NOTE: the previous version of this function read a different device (0x36)
 * and wrote the result to EMULATE_EEPROM_Memory[8] and [9] - which are
 * Accl_Z_LSB_Addr and Accl_Z_MSB_Addr. It was overwriting the accelerometer's
 * Z reading with battery data. The destination is now BatteryPackVoltage_Addr,
 * which is what the map reserves for it.
 */
uint8_t GetBattVolts(void) //TODO: extend to check charge ,and determine if critical or not
{
    
   /*static const uint16_t VoltageThresholds[]="14300,14100,14000,13800,13400,13300"; // voltages in millvolts
#define NumVoltLevels 5  // includes 0, so six items
#define CriticalVoltage VoltageThresholds[NumVoltLevels]
static uint8_t VoltageThresholdNow;  // thus indicates which one to test against  */
    uint8_t raw[2];
    uint16_t voltagemv;
    /* STATIC, and initialised. The flags are cleared and set across calls -
     * see the BatteryPackCommsFailure clear just below - which only works if
     * the value survives from one call to the next. As a plain local it was
     * whatever the stack happened to hold, so a garbage bit 0 read as
     * PowerOff_1_min and HandleTaskWarning() ran AllPowerDown() within
     * seconds of every boot. */
    static uint16_t warning = 0;
    uint8_t FuelGuagePercent;
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

    if (voltagemv<(VoltageThresholds[VoltageThresholdNow]))  //12v is a nominal, test figure, 3V per cell
    {
        
        if(VoltageThresholdNow>=5)
        {
           warning|=LowBatteryCritical; 
            
            if(VoltageCriticalCount>=3)
                warning|=PowerOff_1_min;
                
            
            VoltageCriticalCount++;
        }
        else
        {
            warning|=LowBatteryWarning;//May get modified to  critical 
            VoltageThresholdNow++;
        }
           
    }
    
    
    
    
    //Quick sanity check if voltage gone up again recently - ie has previously passed at least two thresholds, but is now above the higher threshold, then call it all off
    if ( (voltagemv>=(VoltageThresholds[0])) && (VoltageThresholdNow>=2) )  
    {
        VoltageThresholdNow=0;
        VoltageCriticalCount=0;
        warning&=~LowBatteryWarning;
        warning&=~LowBatteryCritical;
    }
    
    //copy the voltage code, then edit for charge%
    
      if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_RSOC, raw, 2))
    {
        i2c2_bus_unwedge();
        if (!i2c2_read_regs(BQ40Z50_I2C_ADDRESS, BQ_CMD_RSOC, raw, 2))
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

    /* Same as the voltage read above: reached only when a read succeeded, by
     * either route, so a successful retry is no longer thrown away. */
    EMULATE_EEPROM_Memory[BatteryChargeState_Addr] = raw[0];  /* percent */

    FuelGuagePercent = raw[0];
//#define CheckFuelGuage    
#ifdef CheckFuelGuage
    if (FuelGaugPercent<(ChargeThresholds[VoltageThresholdNow]))  //12v is a nominal, test figure, 3V per cell
    {
        
        if(ChargeThresholdNow>=4)
        {
           warning|=LowBatteryCritical; 
            
            if(ChargeCriticalCount>=3)
                warning|=PowerOff_1_min;
                
            
            ChargeCriticalCount++;
        }
        else
        {
            warning|=LowBatteryWarning;//May get modified to  critical 
            ChargeThresholdNow++;
        }
           
    }
    
    
    
    
    //Quick sanity check if voltage gone up again recently - ie has previously passed at least two thresholds, but is now above the higher threshold, then call it all off
    if ( (FuelGuagePercent>=(ChargeThresholds[0])) && (ChargeThresholdNow>=2) )  
    {
        ChargeThresholdNow=0;
        CriticalCount=0;
        warning&=~LowBatteryWarning;
        warning&=~LowBatteryCritical;
    }
 #endif  
    
    
    
            
    ClrWdt();
    LedStateRestore(ledWas);
    return(warning);
}

uint8_t GetAccel(void)
{
    uint8_t warning;
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



