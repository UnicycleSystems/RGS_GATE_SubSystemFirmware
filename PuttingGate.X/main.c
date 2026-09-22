
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

#include <stdbool.h>
#include <stdint.h>
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


uint8_t PowerButton (bool OnOff);

/* Debounced power-button reads. See the definitions above PowerButton().
 * Every test of the button goes through these: a single GetValue() sample
 * cannot tell a press from contact bounce or a noise glitch, and on this
 * board that decides whether the unit powers up or shuts down. */
#define BUTTON_SAMPLE_MS   5    /* gap between samples; bounce is ~1-10 ms */
#define BUTTON_SETTLE_MS  25    /* agreeing samples needed to call it real */
#define BUTTON_RELEASE_MS 50    /* longer, to be sure a press is finished  */
static bool ButtonStable(bool pressed, uint16_t settle_ms);
static void ButtonWaitReleased(void);

/* /ACOK (RA7) settling - see AcokWaitPresent(). Generous timeout for now; the
 * measured settle time is recorded in EEPROM byte 19 so it can be set from
 * data rather than guesswork. */
#define ACOK_SAMPLE_MS     5
#define ACOK_SETTLE_MS    25
#define ACOK_TIMEOUT_MS 2000
static bool AcokWaitPresent(uint16_t timeout_ms);

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
 bool charged;
 
 
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
    /* BOR is tested as well as POR. A brown-out sets BOR and leaves POR clear,
     * so with POR alone a sagging rail read as a WARM boot: no button check,
     * straight to running with the Jetson rail raised - a unit apparently
     * powering itself on. A brown-out is a cold start, so treat it as one.
     * Pressing the power button appears to dip the rail on this hardware
     * (it switches the regulator's input), which makes this reachable. */
    bool warmBoot = ((RCONbits.POR == 0) && (RCONbits.BOR == 0));

    /* TEMPORARY DIAGNOSTIC - remove with bytes 17-19. The reset-cause register
     * as found, before anything below clears a bit of it. Low byte at 20:
     * bit0 POR, bit1 BOR, bit2 IDLE, bit3 SLEEP, bit4 WDTO, bit5 SWDTEN,
     * bit6 SWR, bit7 EXTR. High byte at 21 carries TRAPR and IOPUWR. */
    EMULATE_EEPROM_Memory[20] = (uint8_t)(RCON & 0xFF);
    EMULATE_EEPROM_Memory[21] = (uint8_t)(RCON >> 8);
    
//#define  quickhacktest
    
     

    if (warmBoot)
    {
        HOLD_PWR_SetDigitalOutput();
        HOLD_PWR_SetHigh();
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();

    
    }

    SYSTEM_Initialize();
    REAR_LASER_PWM_SetHigh();
    FRONT_LASER_PWM_SetHigh();
 

    LedOn=0;
    FrontSense=0;
    RearSense=0;
    TransitTime=0;
    GateTimeout=0;
    TaskIndex=0;
     
    //This is a 
    EMULATE_EEPROM_Memory[128] = 0;  //This should cause both lasers off
    PWM_RB11_Init();
    PWM_RB11_Enable();
    PWM_RB11_SetDuty(10);
    I2C_WriteQueue_Init();
    // Explicit changes for new versions
    POWER_BUTTON_SetDigitalInput();
    
    /* PIN_MANAGER_Initialize (inside SYSTEM_Initialize) bulk-writes the
     * latches, momentarily dropping both rails; the external FET gates ride
     * through that dip on capacitance. Re-assert per the boot type:
     *   warm : both rails HIGH -- Jetson must not lose power across a reset.
     *   cold : HOLD_PWR stays HIGH (we MUST keep our own supply latched --
     *          we arrived here from a bootloader handoff-reset, the button is
     *          already released, and on battery there is nothing else holding
     *          3V3 up; dropping HOLD_PWR here powers the device straight off
     *          before the charger loop ever runs). Jetson rail stays OFF so
     *          the charge-indication state is Jetson-dark until power-on
     *          completes via the button.
     */
    HOLD_PWR_SetDigitalOutput();
    JETSON_5V_ON_SetDigitalOutput();
    HOLD_PWR_SetHigh();                  /* keep our own supply latched, both boot types */
    if (warmBoot)
    {
        JETSON_5V_ON_SetHigh();
        ClrWdt();
        
    }
    else
    {
          JETSON_5V_ON_SetLow();
  
    }
    
    
    /* Cold-start power-on. Warm boots (firmware-update resume) skip all of
     * this. The path splits on whether the charger is present, read from
     * /ACOK on RA7 (DEBUG_IN): the charger IC pulls it LOW when AC is
     * present, an external pull-up holds it HIGH otherwise.
     *
     *   NO charger  -> the only way 3V3 came up on battery is a deliberate
     *                  button press, so power straight up and run. HOLD_PWR
     *                  is already latched high -> single press, no charger
     *                  loop, no second press.
     *
     *   Charger present -> the charger forced us on; the user has not asked
     *                  to run yet. RELEASE HOLD_PWR so the charger alone
     *                  holds the rail -- then pulling the charger while still
     *                  idle drops power and the unit goes fully off (no
     *                  latched-on-but-idle limbo). Show charge status and
     *                  wait for a button press; on press, re-latch HOLD_PWR
     *                  and power up. Once latched, unplugging keeps us
     *                  running on battery.
     *
     * Safety: HOLD_PWR is only released when the charger DEFINITELY reads
     * present (RA7 == 0). Any other reading falls through to run-and-stay-
     * latched, so a misread can never strand a battery boot dead.
     *
     * HOW THE TWO ARE TOLD APART, and why it is not a single read of RA7:
     *
     * The BUTTON is asked first. On battery the press is what powers the rail,
     * and it outlasts startup, so the button is still down when we get here -
     * measured on the bench. Nobody is touching it on a charger start. That
     * reading is available immediately and needs no settling.
     *
     * Only when the button is NOT held do we look at /ACOK, and then we WAIT
     * for it: on a charger-powered start the PIC is running before the charger
     * IC has asserted its AC-present output, so the old single sample here read
     * "no charger" while a read moments later read "charger present" - which
     * sent a charger boot down the battery path and left it latched on when the
     * charger was pulled out. AcokWaitPresent() polls for a stable low instead.
     *
     * Waiting costs nothing on a button start, because that case never reaches
     * it. */
    if (!warmBoot)
    {
           
        
        /* ---- TEMPORARY DIAGNOSTIC - remove once the charger-boot question is
         * settled -----------------------------------------------------------
         * Snapshot the two inputs this branch turns on, BEFORE anything acts
         * on them. Address 17 is unused: the low read-only block ends at 16
         * and the high block descends to 109, so nothing in the map moves.
         *
         *   bit 0: /ACOK  (RA7)   0 = charger present
         *   bit 1: button (RB10)  0 = pressed
         *   bit 2: warmBoot
         *
         * Read it from the Jetson with peek.py. */
        EMULATE_EEPROM_Memory[17] = (uint8_t)
                ((DEBUG_IN_GetValue()     ? 0x01 : 0x00) |
                 (POWER_BUTTON_GetValue() ? 0x02 : 0x00) |
                 (warmBoot                ? 0x04 : 0x00));

        /* "not measured" sentinel, so a real 0 in byte 19 can only mean /ACOK
         * was already low - it read 0 once simply because the button-held path
         * never calls AcokWaitPresent() and the array starts zeroed. */
        EMULATE_EEPROM_Memory[19] = 0xFE;

        /* Button held -> the user powered this on, and no amount of waiting
         * for /ACOK changes that. Otherwise something else brought the rail
         * up, so give the charger line time to say whether it was the
         * charger. */
        bool chargerBoot;

        if (ButtonStable(true, BUTTON_SETTLE_MS))
            chargerBoot = false;
        else
            chargerBoot = AcokWaitPresent(ACOK_TIMEOUT_MS);

        if (chargerBoot)                   /* /ACOK low -> charger present */
        {
            uint8_t diagflash;

            charged = 0;
            HOLD_PWR_SetLow();             /* charger holds the rail; unplug-while-idle -> off */

            /* TEMPORARY: two slow GREEN flashes = charger branch taken. Shown
             * with the Jetson still down, unlike the byte above. */
            for (diagflash = 0; diagflash < 2; diagflash++)
            {
                BI_LED_RED_SetLow();
                BI_LED_GREEN_SetHigh();
                __delay_ms(250);
                ClrWdt();
                BI_LED_GREEN_SetLow();
                __delay_ms(250);
                ClrWdt();
            }

            /* Charge display, until a real press asks us to power on. This
             * whole wait belongs to the charger case ONLY: on battery there
             * is nobody to wait for - the press that powers the rail IS the
             * power-on. It used to sit outside this branch, so a battery
             * boot waited here for a second press that the user had no reason
             * to make, with HOLD_PWR latched and the pack draining. */
            while(!ButtonStable(true, BUTTON_SETTLE_MS))
            {
                ClrWdt();
                if(!charged)
                {
                 RED_LED_ON_SetHigh();
                __delay_ms(5);
                RED_LED_ON_SetLow();
                __delay_ms(1000);
                }

                if(VER_0_GetValue())
                {
                    charged=1;
                    BI_LED_GREEN_SetHigh();//Turn on Green LED
                    BI_LED_RED_SetLow();//Turn off Red LED
                }
                else
                {
                    charged=0;
                   BI_LED_RED_SetHigh();//Turn off Red LED
                    BI_LED_GREEN_SetLow();//Turn on Green LED
                }
            }
            // button pressed: take ownership of our own supply and power on
            RED_LED_ON_SetLow();
            HOLD_PWR_SetHigh();
            while(!PowerButton(On))//wait for a 'power on' press and hold to complete
                ClrWdt();
        }
        else
        {
            /* No charger. The 3V3 rail can only have come up because the user
             * is holding the button, so THIS press is the power-on and no
             * second press is asked for. HOLD_PWR was latched high above (and
             * by the bootloader before that), so the unit stays up on release.
             *
             * The Jetson rail has to be raised here: it was dropped above for
             * the cold path, and PowerButton(On) - the only other place that
             * raises it - is on the charger branch.
             *
             * Then wait for a DEBOUNCED release before running. The main loop
             * reads a held button as a power-DOWN request and PowerButton(Off)
             * qualifies after ~330 ms, so entering the loop with this press
             * still held would shut the unit straight back down. */
            uint8_t diagflash;

            /* TEMPORARY: two slow RED flashes = battery branch taken, i.e.
             * /ACOK read HIGH. Seeing this with the charger plugged in is the
             * misread we are hunting. */
            for (diagflash = 0; diagflash < 2; diagflash++)
            {
                BI_LED_GREEN_SetLow();
                BI_LED_RED_SetHigh();
                __delay_ms(250);
                ClrWdt();
                BI_LED_RED_SetLow();
                __delay_ms(250);
                ClrWdt();
            }

            JETSON_5V_ON_SetHigh();
            ButtonWaitReleased();
        }
    }
    /* Both paths are now "powered and running": show green. */
    BI_LED_GREEN_SetHigh();//Turn on Green LED
    BI_LED_RED_SetLow();//Turn off Red LED

    /* Power-on is complete: clear the power-on reset-cause bits so every
     * later reset in this power cycle reads as warm (POR==0). Deliberately
     * placed AFTER the button-hold: if we crash or watchdog out of the
     * charger loop / hold-count above, POR is still set and the retry is
     * correctly treated as another cold start. SWR/WDTO are left untouched
     * for any future reset-cause diagnostics (nothing reads them today). */
    RCONbits.POR = 0;
    RCONbits.BOR = 0;

   //pull in the accelerometer cal values.
     xcal  = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalX_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalX_LSB_Addr]);
     ycal  = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalY_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalY_LSB_Addr]);
     zcal  = (int16_t)(((uint16_t)EMULATE_EEPROM_Memory[Accl_CalZ_MSB_Addr] << 8) | EMULATE_EEPROM_Memory[Accl_CalZ_LSB_Addr]);
       
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
  
  // set the 'ticks per second
 
 
    EMULATE_EEPROM_Memory[TicksPerSecMMSB] = (uint8_t)(0x00);  // Most significant byte
    EMULATE_EEPROM_Memory[TicksPerSecNMSB] = (uint8_t)(0xF4);
    EMULATE_EEPROM_Memory[TicksPerSecHLSB] = (uint8_t)(0x24);
    EMULATE_EEPROM_Memory[TicksPerSecLLSB] = (uint8_t)(0x00);

    /* Restore the configuration saved by the factory bring-up jig. Placed
     * AFTER the hardcoded setters above so the stored values win (those
     * setters become redundant once every unit has been through bring-up),
     * and BEFORE the firmware version stamp below - the whole 256-byte block
     * is mirrored, so FirmwareVersionAddr is in it, and a unit must report the
     * version it is RUNNING, not the one current when the block was saved.
     *
     * Returns false on a blank device (never brought up), leaving the defaults
     * above in place. That is not an error. */
    
    
   // PERSIST_LoadToEeprom();

    EMULATE_EEPROM_Memory[FirmwareVersionAddr] = FIRMWARE_REV_LSB;
    EMULATE_EEPROM_Memory[FirmwareVersionAddr-1] = FIRMWARE_REV_MSB;
 
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

    while(1)
    {   
      
       /* ---- TEMPORARY DIAGNOSTIC - remove along with the byte at 17 -------
        * LIVE pin sample, refreshed every pass, so the charger line can be
        * watched with "peek.py 17 2" while the charger is plugged in and
        * pulled out. 17 is the once-only snapshot taken at the branch; 18 is
        * what the pins read right now.
        *
        *   bit 0: /ACOK    (RA7)   0 = charger present
        *   bit 1: button   (RB10)  0 = pressed
        *   bit 2: HOLD_PWR (RA10)  1 = our own supply latched on
        *   bit 7: always set when written, so a reading of 0x00 means the main
        *          loop has NOT run this boot rather than "all three low"
        */
       EMULATE_EEPROM_Memory[18] = (uint8_t)(0x80 |
               ((DEBUG_IN_GetValue()     ? 0x01 : 0x00) |
                (POWER_BUTTON_GetValue() ? 0x02 : 0x00) |
                (HOLD_PWR_GetValue()     ? 0x04 : 0x00)));

       /* Debounced, so a glitch on the line cannot start a power-down and
        * blank the LEDs on its way through PowerButton(). Costs one sample
        * per loop while the button is idle. */
       if(ButtonStable(true, BUTTON_SETTLE_MS))
         PowerDown(ButtonPwrDwn);

        if(DoTask) //this is set periodically by the TMR2 interrupt. Nominally 1 second.
            {
                DoTask=0; // this will re-set itself in 1 second
                if(SelfResetTimeout)// if the first part of reset been issued, it needs to be completed within 10 seconds or is cancelled.
                {
                    if(!SelfResetTimeout--)
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









/* Provide a tiny delay; replace with your system delay if you have one */
static void small_delay(void)
{
    /* ~1?2 ms software delay; adjust to taste or replace with __delay_ms(1) */
    //for (volatile uint32_t i = 0; i < 8000UL; i++) { __asm__ volatile ("nop"); }
    __delay_ms(1);
}
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
           return(1);  // indicates unacceptable orientation
       else
           return(0); // all good
       
       
         
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
        if (!PowerButton(Off)) 
        {
            return;
        }
     
        //AllPowerDown(); -- use the handler rather than direct call
        HandleTaskWarning(PowerOff_1_min);
        
    
    /* Only reached when the hold was too short - a qualifying hold never
     * returns from the loop above. PowerButton() borrowed the LEDs while
     * counting and left them out, so set to AMBER for rogue state */
    BI_LED_GREEN_SetHigh();
    BI_LED_RED_SetHigh();
    return;

}


/* Debounced read of the power button.
 *
 * Returns true only when the button has read `pressed` continuously for
 * settle_ms, and false the moment a sample disagrees - so a caller can poll
 * it cheaply: asking "is it pressed?" of an idle button costs one sample and
 * returns immediately.
 *
 * POWER_BUTTON is active LOW, with the internal pull-up enabled on CN16, so
 * "pressed" is a LOW reading. Sampling every few milliseconds and restarting
 * the count on any disagreeing sample outlasts the 1-10 ms of contact bounce,
 * and means a bounce gap part-way through a press is not read as a release.
 */
static bool ButtonStable(bool pressed, uint16_t settle_ms)
{
    uint16_t waited;

    for (waited = 0; waited < settle_ms; waited += BUTTON_SAMPLE_MS)
    {
        if (((POWER_BUTTON_GetValue() == 0) ? true : false) != pressed)
            return false;
        __delay_ms(BUTTON_SAMPLE_MS);
        ClrWdt();
    }
    return (((POWER_BUTTON_GetValue() == 0) ? true : false) == pressed);
}

/* Wait for /ACOK to say the charger is present, rather than sampling it once.
 *
 * RA7 is the charger IC's open-collector AC-present output, pulled up to the
 * PIC's own 3V3. On a charger-powered start the PIC is up and running before
 * that output has asserted: measured on the bench, this branch read "no
 * charger" while a read moments later read "charger present" - so one early
 * sample committed the whole session to the wrong path.
 *
 * Polls for a low that holds for ACOK_SETTLE_MS, returning true as soon as one
 * is seen and false if the line stays high for the whole timeout. Called only
 * when the button is not held, so a button power-on never waits.
 *
 * The TEMPORARY write to byte 19 records how long it took, in 10 ms units
 * (0xFF = never asserted), so ACOK_TIMEOUT_MS can be chosen from measurements.
 * Remove it with the rest of the diagnostics.
 */
static bool AcokWaitPresent(uint16_t timeout_ms)
{
    uint16_t waited;
    uint8_t  low_run = 0;                  /* consecutive low samples */

    for (waited = 0; waited < timeout_ms; waited += ACOK_SAMPLE_MS)
    {
        if (DEBUG_IN_GetValue() == 0)
        {
            low_run++;
            if (low_run >= (ACOK_SETTLE_MS / ACOK_SAMPLE_MS))
            {
                uint16_t tens = (uint16_t)(waited / 10u);
                EMULATE_EEPROM_Memory[19] = (uint8_t)((tens > 254u) ? 254u : tens);
                return true;
            }
        }
        else
        {
            low_run = 0;                   /* must be CONTINUOUSLY low */
        }
        __delay_ms(ACOK_SAMPLE_MS);
        ClrWdt();
    }

    EMULATE_EEPROM_Memory[19] = 0xFF;      /* never asserted within the timeout */
    return false;
}

/* Block until the button has been released and stayed released. Used wherever
 * one press must not be seen twice by the code that follows. */
static void ButtonWaitReleased(void)
{
    while (!ButtonStable(false, BUTTON_RELEASE_MS))
    {
        __delay_ms(BUTTON_SAMPLE_MS);
        ClrWdt();
    }
}

//returns 1 if Power button held long enough
// or 0 if not....
uint8_t PowerButton (bool OnOff)
{
    uint8_t ButtonPressHold;
    ButtonPressHold=0;
    bool ButtonPassed;
    ButtonPassed=0;
    
    /* Count for as long as the button is held. Tested with the debounced read
     * so that a bounce gap mid-press is not taken for a release - which used
     * to abort the count and report "released too soon" on a genuine hold. */
    while(!ButtonStable(false, BUTTON_SETTLE_MS))
    {
        ButtonPressHold++;

        // Feed the watchdog: in the field (bootloader-programmed) config the
        // WDT period is only ~1.06s (4.1ms x PS256), and this hold-count runs
        // ~900ms -- without this, the WDT fires mid-count on every power-on
        // hold and the device reset-loops through the flash sequence.
        ClrWdt();

       BI_LED_GREEN_SetHigh();//Turn on Green LED
       BI_LED_RED_SetLow();//Turn off Red LED
      __delay_ms(20);
      BI_LED_RED_SetHigh();//Turn on Red LED
      BI_LED_GREEN_SetLow();//Turn off Green LED
      __delay_ms(10);
      if (ButtonPressHold>10)
      {
          ButtonPassed=1;

          break;
      }

    }
    /* Act only on a qualifying hold. A press that is released too soon leaves
     * the power rails exactly as it found them - the LED activity above was
     * just feedback while counting, so put the LEDs back out and report the
     * failure to the caller. */
    if (ButtonPassed)
    {
        if (OnOff)
        {
             HOLD_PWR_SetHigh();
             JETSON_5V_ON_SetHigh();
             BI_LED_GREEN_SetHigh();//Turn/JETSON_5V_ON_SetHigh(); on Green LED
             BI_LED_RED_SetLow();//Turn off Red LED
        }
        else
        {
          BI_LED_RED_SetHigh();//Turn on Red LED
          BI_LED_GREEN_SetLow();//Turn off Green LED
        }
    }
    else
    {
      BI_LED_GREEN_SetLow();//Released too soon - both LEDs out
      BI_LED_RED_SetLow();

      /* Return straight away. The wait-for-release below must NOT run on this
       * path: the counting loop only exited because the button was already
       * released, so there is nothing to wait for - but if the user presses
       * again while we sit here, that press is consumed as a release-wait and
       * never counted. The caller loops on this function, so a swallowed press
       * means no subsequent press ever powers the unit up. */
      return(ButtonPassed);
    }

    /* Only after a qualifying hold: wait for release so the caller does not
     * see the same press a second time. Replaces two hand-rolled wait loops
     * that each exited on a single high sample. */
    ButtonWaitReleased();

    return(ButtonPassed);
         
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
            BI_LED_GREEN_SetHigh();//Turn on Green LED
            BI_LED_RED_SetLow();//Turn off Red LED
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
            BI_LED_GREEN_SetHigh();//Turn on Green LED
            BI_LED_RED_SetLow();//Turn off Red LED
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
    BI_LED_GREEN_SetHigh();//Turn off Green LED
    BI_LED_RED_SetLow();//Turn on Red LED
    return(warning);
}

uint8_t GetAccel(void)
{
    uint8_t warning;
    warning=0;



    BI_LED_GREEN_SetLow();//Turn off Green LED
    BI_LED_RED_SetHigh();//Turn on Red LED
    if(QuickAcellerometerGrabber())   //returns any non zero for warning
        warning=GateInvalidOrientation;
    BI_LED_GREEN_SetHigh();//Turn off Green LED
    BI_LED_RED_SetLow();//Turn on Red LED
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
        AllLightsOff();
    }

    if (code & GateInvalidOrientation)  /* Tilt greater than TBD X degrees */
    {
        AllLightsOff();
    }
}
    

    


void AllPowerDown (void)
{
    uint8_t HoldOffms;
    HoldOffms = 0;
    uint16_t SecondsCount;
    uint16_t OffTime;
    uint16_t OnTime;
    
    AllLightsOff();
   
     BI_LED_RED_SetHigh();
     BI_LED_GREEN_SetLow();
  //Wait 1 minute with fancy flickering RED LED then do the actual power down   
    for (SecondsCount=0;SecondsCount<60;SecondsCount++)
    {
        OffTime=SecondsCount;
        OffTime=SecondsCount*10;
        OnTime=1000-OffTime;
        
       BI_LED_RED_SetHigh();
       ClrWdt();
       __delay_ms(OnTime);
       BI_LED_RED_SetLow();
       ClrWdt();
       __delay_ms(OffTime);  
    }
          
   //This is the actual power down
        JETSON_5V_ON_SetLow();
        HOLD_PWR_SetLow();

        // Give the external power-latch hardware time to actually cut supply
        // before we reset. Without this delay, if the latch hasn't dropped
        // power yet, the MCU reboots while still powered (going through the
        // bootloader) with the button often still held, which re-latches
        // power straight back on instead of turning off.
        
    //Below: looks a bit overcomplicated now power path behaving ok!  
        // just a simple infinite loop clearing the watchdog should be fine now?
        while(1)
        {
            
            ClrWdt();
            __delay_ms(50);
           
            HoldOffms++;
            if(HoldOffms >=300)//if this happens, the power has not gone down
            {
                
              RCONbits.EXTR = 1;
              RCONbits.POR=1;
              RCONbits.BOR=1;
              asm("reset");  
            }
        }
    
}

void AllLightsOn (void)
{
    FRONT_LASER_PWM_SetLow();
    REAR_LASER_PWM_SetLow();
    BEAM_SetLow();
    EMULATE_EEPROM_Memory[LaserStateAddr]=7;
    RestoreDetect();
}

void AllLightsOff (void)
{   
    
    FrontSensorOff;
    RearSensorOff;
    if(EMULATE_EEPROM_Memory[LaserStateAddr]!=0)
       CopyLightState= EMULATE_EEPROM_Memory[LaserStateAddr]; //back up the current lighting state. but don't accidentally make it zero if this has already been called
    
    EMULATE_EEPROM_Memory[LaserStateAddr]=0;
    FRONT_LASER_PWM_SetHigh();
    REAR_LASER_PWM_SetHigh();
    BEAM_SetHigh();
}

void AllLightsRestore(void) //puts the lights back as we found them 
{
    
     if (CopyLightState&0x01)
      FRONT_LASER_PWM_SetLow();
  else
      FRONT_LASER_PWM_SetHigh();
  
  if (CopyLightState&0x02)
      REAR_LASER_PWM_SetLow();
  else
      REAR_LASER_PWM_SetHigh();
  
   if (CopyLightState&0x04)
      BEAM_SetLow();
  else
      BEAM_SetHigh();
     
   EMULATE_EEPROM_Memory[LaserStateAddr]=CopyLightState; 
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



