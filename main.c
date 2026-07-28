
//#pragma config FWDTEN = OFF      // Watchdog Timer Enable (WDT disabled in hardware)
//#pragma config WINDIS = ON       // Windowed WDT disabled (optional)

#include "Events.h"
#include "pin_CustomISR.h"

#include "RGS_MCC_Copies/system.h"
#include "RGS_MCC_Copies/clock.h"
#include "RGS_MCC_Copies/interrupt_manager.h"
#include "RGS_MCC_Copies/i2c2.h"
#include "RGS_MCC_Copies/i2c1.h"
#include "RGS_MCC_Copies/tmr4.h"
#include "RGS_MCC_Copies/tmr2.h"
#include "RGS_MCC_Copies/pin_manager.h"
#include "RGS_MCC_Copies/uart1.h"
#include "lis2dw12.h"
#include "bq40z50.h"

#include <stdbool.h>
#include <stdint.h>
#include "i2c_write_queue.h"
#include "address_block_lookup.h"
#include "job_queue.h"
#include <xc.h>

#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>
#include "pitchandroll.h"
#include "firmware_version.h"
#include "EEpromBlockLabels.h"


//accelerometer specific stuff....
// to be removed if we ever implement a proper .c/.h set up

//commented out here, copied to top, but preserved for moving to header file
/* ---- LIS2DW12 / LIS2DW1TR basics ---- */

#define REG_WHO_AM_I        0x0F    /* expect 0x44 */
#define REG_CTRL1           0x20
#define REG_CTRL2           0x21
#define REG_CTRL6           0x25
#define REG_OUT_X_L         0x28    /* then X_H, Y_L, Y_H, Z_L, Z_H */

#define CTRL2_BDU           (1u << 3)
#define CTRL2_IF_ADD_INC    (1u << 2)

#define LIS_ADDR_0 0x18
#define LIS_ADDR_1 0x19
#define ButtonDelay 5    // The number of cycles of the button hold to return 'true)
                         // NOT debounce, this is the long (ish)user press and hold

#define On 1
#define Off 0

//round robin possible tasks
void GetBattVolts(void);
void GetAccel(void);
void DummyTask(void);

///Test functions switches




// round robin tasks
//only one of these should be active
//#define Standard

//only one of these should be active
//#define Test1
//#define Test2
#define TestNewBattBoard



// Task handler functions as needed, increment NUM_Tasks 
#ifdef Test1
#define NUM_Tasks 2
void Test1PatternA(void);
void Test1PatternB(void);
void (*Task[NUM_Tasks])(void)={Test1PatternA,Test1PatternB};
#endif

#ifdef Test2
#define NUM_Tasks 2
void Test2PatternA(void);
void Test2PatternB(void);
void (*Task[NUM_Tasks])(void)={Test2PatternA,Test2PatternB};

#endif


#ifdef Standard
#define NUM_Tasks 2
void (*Task[NUM_Tasks])(void)={GetAccel,GetBattVolts};

#endif

#ifdef TestNewBattBoard
#define NUM_Tasks 2
void (*Task[NUM_Tasks])(void)={GetAccel,GetAccel};
#endif

// these are the 'ticker' tasks, worked through once per second,
// rather than every pass of the loop.
// executed in a 'round robin' , one task executed per second (approx)
// time is based on TMR2 interrupt, sets 'DoTask ' flag.
// so to add another task, just add a task handler, 
// reference it in the array, below, and increment NUM_Tasks.
//...oh.. and actually write the code that does the task!
//void (*Task[NUM_Tasks])(void)={GetBattVolts,GetAccel};

uint8_t TaskIndex;

////////////////////////////////////////////////




static uint8_t s_addr = LIS_ADDR_1;
void LIS2DW12_SetAddress_I2C2(uint8_t addr) { s_addr = addr; }
static bool i2c2_wait_done(volatile I2C2_MESSAGE_STATUS *st, uint16_t timeout_ms);
static bool i2c2_write_u8(uint8_t dev7, uint8_t reg, uint8_t val);
static bool i2c2_read_regs(uint8_t dev7, uint8_t start_reg, uint8_t *dst, uint8_t n);
//end accelerometer specific defines

// accelerometer prototypes
//void LIS2DW12_SetAddress_I2C2(uint8_t addr);
void QuickAcellerometerGrabber(void);
bool LIS2DW12_Init_I2C2(void);                 // returns true on success
bool LIS2DW12_ReadXYZ_I2C2(int16_t *x, int16_t *y, int16_t *z);
static bool lis_probe_addr(uint8_t addr);

//end accelerometer prototypes

void CallJetsonBall(void);
void CallJetsonJob(void);

void ReadOneByteExample(void);
bool lis2dw12_read_register(uint8_t reg, uint8_t *value);
//bool LIS2DW12_Configure(void);
void ShutdownProcessTemp(void);
void PowerDown(void);

void POST_Routine(void);
void LaunchTest(void);
uint8_t PowerButton (bool OnOff);

// PWM on RB11 via OC3/T3
#define PWM_RB11_PERIOD   159   // PR3 value: 100kHz at FCY=16MHz (16000000/100000 - 1)
void PWM_RB11_Init(void);
void PWM_RB11_Enable(void);
void PWM_RB11_Disable(void);
void PWM_RB11_SetDuty(uint8_t duty);

 uint8_t testval;
 
// power management
uint32_t SwitchState;
uint32_t ButtonCount;
bool PowerOff;
bool queuepanic;


I2C_WriteJob_t LoadJobFromEEprom;
uint8_t JobIndex;


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
    bool warmBoot = ((RCONbits.POR == 0));

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
    SwitchState=0; 
    ButtonCount=0;
    PowerOff=false;
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
     * latched, so a misread can never strand a battery boot dead. */
    if (!warmBoot)
    {
        if (DEBUG_IN_GetValue() == 0)      /* /ACOK low -> charger present */
        {
            bool charged;
            charged = 0;
            HOLD_PWR_SetLow();             /* charger holds the rail; unplug-while-idle -> off */

            while(POWER_BUTTON_GetValue()) /* wait for a button press to power on */
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
        /* else: no charger -> battery button-boot -> HOLD_PWR already high,
         * fall straight through to running. Single press. */
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

  // #define RunPOST
#ifdef RunPOST
     POST_Routine();
#endif
   
    
    FrontSensorOff;
    RearSensorOff;
    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;

    
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
  
  // set the 'ticks per second and other defaults.
    
   // in due course, add a bit of non-vol and init all at start up.
   
    EMULATE_EEPROM_Memory[4] = (uint8_t)(0x00);  // Most significant byte
    EMULATE_EEPROM_Memory[5] = (uint8_t)(0xF4);
    EMULATE_EEPROM_Memory[6] = (uint8_t)(0x24);
    EMULATE_EEPROM_Memory[7] = (uint8_t)(0x00);
    
    EMULATE_EEPROM_Memory[FirmwareVersionAddr] = FIRMWARE_REV_LSB;
    EMULATE_EEPROM_Memory[FirmwareVersionAddr-1] = FIRMWARE_REV_MSB;
 
   // INTERRUPT_TO_JETSON_SetLow();
    RestoreDetect();
   
    LIS2DW12_Init_I2C2();    // TODO: should ensure it inits, or returns an error

    /* --- BQ40Z50-R2 battery pack bring-up (report on UART1) --- */
    UART1_Initialize();
    U1BRG = 0x22;            /* MCC file is 9600; 0x22 -> 115200 @ FCY 16 MHz, BRGH=1 */
    BQ40Z50_BringUp();
  //  uint8_t id = 0x00;

  //BI_LED_RED_SetHigh();BI_LED_RED is RED!!!!!
  BI_LED_GREEN_SetHigh(); //BI_LED_GREEN is green!!!!
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
  
//#define PWR_BUTT_LAUNCH_TEST
    while(1)
    {   
       
        
       if(!POWER_BUTTON_GetValue())
#ifdef  PWR_BUTT_LAUNCH_TEST
            LaunchTest();
#else
         
             PowerDown();
#endif
          if(DoTask) //this is set periodically by the TMR2 interrupt. Nominally 1 second.
             {
              if(SelfResetTimeout)
              {
                if(!SelfResetTimeout--)
                    CancelReset();
              }
                
             
              DoTask=0; // clear it straight away, it will re set in due course! 
                Task[TaskIndex](); 
                TaskIndex++;
                if(TaskIndex>=NUM_Tasks)
                    TaskIndex=0;  

             }
 //----------------------------------
// -- check to see if an i2c 'write' - ie job load is pending             
        if(EventJob.i2cQueJobWaiting)
        {
            if(I2C_WriteQueue_Pop(&LoadJobFromEEprom)) 
            {
                if(!JobQueue_Push(LoadJobFromEEprom.start_address))
                   queuepanic=1;
                
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




void ShutdownProcessTemp()

{
    uint8_t delay;
     BI_LED_RED_SetLow();   
    for(delay=0;delay<200;delay++)
    {
         ClrWdt();
        __delay_ms(50);
        RED_LED_ON_Toggle();  
    }
        RED_LED_ON_SetLow();         

   JETSON_5V_ON_SetHigh();//temp flip
        
    ButtonCount=0;
    while(ButtonCount<10)
    {
       
        if(!POWER_BUTTON_GetValue())
            ButtonCount++;
        else
            ButtonCount=0;
        __delay_ms(50);
        ClrWdt();
       
    }
    while(!POWER_BUTTON_GetValue())
    {
        ClrWdt();
        __delay_ms(50);
         BI_LED_GREEN_Toggle();   
    }
       BI_LED_GREEN_SetLow();       
   
     JETSON_5V_ON_SetLow();//tempflip
    
}





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

static bool i2c2_wait_done(volatile I2C2_MESSAGE_STATUS *st, uint16_t timeout_ms)
{
    while (*st == I2C2_MESSAGE_PENDING) {
        __delay_ms(1);
        ClrWdt();
        if (timeout_ms-- == 0) return false;   // timeout
    }
    return true;
}


static bool i2c2_write_u8(uint8_t dev7, uint8_t reg, uint8_t val)
{
    volatile I2C2_MESSAGE_STATUS st = I2C2_MESSAGE_PENDING;
    uint8_t w[2] = { reg, val };
    I2C2_MasterWrite(w, 2, dev7, (I2C2_MESSAGE_STATUS*)&st);
    return i2c2_wait_done(&st, 50) && (st == I2C2_MESSAGE_COMPLETE);
}

/* Proper repeated-start via TRB pair: write(reg) then read(n) */
/* Preferred: repeated-start via TRB pair. Falls back to STOP (write then read). */
static bool i2c2_read_regs(uint8_t dev7, uint8_t start_reg, uint8_t *dst, uint8_t n)
{
    volatile I2C2_MESSAGE_STATUS st = I2C2_MESSAGE_PENDING;
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];

    I2C2_MasterWriteTRBBuild(&trb[0], &start_reg, 1, dev7);
    I2C2_MasterReadTRBBuild (&trb[1], dst,        n, dev7);
    I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS*)&st);

    if (i2c2_wait_done(&st, 50) && st == I2C2_MESSAGE_COMPLETE)
        return true;

    // Fallback: STOP between write(reg) and read(n)
    st = I2C2_MESSAGE_PENDING;
    I2C2_MasterWrite(&start_reg, 1, dev7, (I2C2_MESSAGE_STATUS*)&st);
    if (!i2c2_wait_done(&st, 50) || st != I2C2_MESSAGE_COMPLETE) return false;

    st = I2C2_MESSAGE_PENDING;
    I2C2_MasterRead(dst, n, dev7, (I2C2_MESSAGE_STATUS*)&st);
    return i2c2_wait_done(&st, 50) && (st == I2C2_MESSAGE_COMPLETE);
}

static bool i2c2_read_u8(uint8_t dev7, uint8_t reg, uint8_t *val)
{
    return i2c2_read_regs(dev7, reg, val, 1);
}

/* ---- High-level sensor ops ---- */

static bool lis_probe(void)
{
    uint8_t id = 0;
    if (!i2c2_read_u8(s_addr, REG_WHO_AM_I, &id)) return false;
    return (id == 0x44);
}

bool LIS2DW12_Init_I2C2(void)
{
    EMULATE_EEPROM_Memory[30] = 0xA1;     // entered init

    s_addr=0x18;

    EMULATE_EEPROM_Memory[31] = s_addr;
    
    
// Explicitly enter power-down
    if (!i2c2_write_u8(s_addr, REG_CTRL1, 0x00))
    {
        EMULATE_EEPROM_Memory[33] = 0xC0;
        return false;
    }
    
    if (!i2c2_write_u8(s_addr, REG_CTRL2, 0x0C))
        { EMULATE_EEPROM_Memory[32] = 0xC2; return false; }

   
    
    if (!i2c2_write_u8(s_addr, REG_CTRL6, 0xC4))   // ~100 Hz, FS �2g
        { EMULATE_EEPROM_Memory[33] = 0xC1; return false; }
    
     if (!i2c2_write_u8(s_addr, REG_CTRL1, 0x24))   // ~100 Hz, FS �2g
        { EMULATE_EEPROM_Memory[33] = 0xC1; return false; }

    EMULATE_EEPROM_Memory[34] = 0x00;     // success
    return true;
}

bool LIS2DW12_ReadXYZ_I2C2(int16_t *x, int16_t *y, int16_t *z)
{
    uint8_t raw[6];
    if (!i2c2_read_regs(s_addr, REG_OUT_X_L, raw, 6)) return false;

    *x = (int16_t)((uint16_t)raw[1] << 8 | raw[0]);
    *y = (int16_t)((uint16_t)raw[3] << 8 | raw[2]);
    *z = (int16_t)((uint16_t)raw[5] << 8 | raw[4]);
    *x>>=2;
    *y>>=2;
    *z>>=2;
          
    return true;
}

static bool lis_probe_addr(uint8_t addr)
{
    uint8_t id = 0;
    return i2c2_read_regs(addr, REG_WHO_AM_I, &id, 1) && (id == 0x44);
}

void QuickAcellerometerGrabber(void)
{
    uint8_t AddressStart;
    int16_t pitch;
    int16_t roll;
    
   
        ClrWdt();
        int16_t x, y, z;
        if (LIS2DW12_ReadXYZ_I2C2(&x, &y, &z)) 
        {
        uint16_t ux = (uint16_t)x;
        uint16_t uy = (uint16_t)y;
        uint16_t uz = (uint16_t)z;
       
        
        // Pack as [X_H, X_L, Y_H, Y_L, Z_H, Z_L]
        EMULATE_EEPROM_Memory[10]  = (uint8_t)(ux >> 8);
         EMULATE_EEPROM_Memory[11] = (uint8_t)(ux);
         EMULATE_EEPROM_Memory[12] = (uint8_t)(uy >> 8);
         EMULATE_EEPROM_Memory[13] = (uint8_t)(uy);
         EMULATE_EEPROM_Memory[14] = (uint8_t)(uz >> 8);
         EMULATE_EEPROM_Memory[15] = (uint8_t)(uz);
        
         
         
            /* use raw counts; scale later if needed */
        }
        else // if it fubars, then just fill with 0xFF;
        {
         EMULATE_EEPROM_Memory[10]  = 0xFF;
         EMULATE_EEPROM_Memory[11] = 0xFF;
         EMULATE_EEPROM_Memory[12] = 0xFF;
         EMULATE_EEPROM_Memory[13] =0xFF;;
         EMULATE_EEPROM_Memory[14] =0xFF;
         EMULATE_EEPROM_Memory[15] =0xFF; 
        }
       ComputePitchRoll(x,y,z,&pitch,&roll);
        uint16_t upitch = (uint16_t)pitch;
    uint16_t uroll  = (uint16_t)roll;
    
       EMULATE_EEPROM_Memory[16] = (uint8_t)(upitch >> 8);
       EMULATE_EEPROM_Memory[17] = (uint8_t)(upitch);
       EMULATE_EEPROM_Memory[18] = (uint8_t)(uroll >> 8);
       EMULATE_EEPROM_Memory[19] = (uint8_t)(uroll);
}

//refactor into a general purpose button thing...
void PowerDown(void)
{ 
    uint8_t HoldOffms;
    HoldOffms = 0;
    if (PowerButton(Off))
    {
        JETSON_5V_ON_SetLow();
        HOLD_PWR_SetLow();

        // Give the external power-latch hardware time to actually cut supply
        // before we reset. Without this delay, if the latch hasn't dropped
        // power yet, the MCU reboots while still powered (going through the
        // bootloader) with the button often still held, which re-latches
        // power straight back on instead of turning off.
        
        while(1)
        {
            
            ClrWdt();
            __delay_ms(50);
           
            HoldOffms++;
            if(HoldOffms >=30)
            {
                
              RCONbits.EXTR = 1;
              RCONbits.POR=1;
              RCONbits.BOR=1;
              asm("reset");  
            }
        }
       
    }
    return;
    
}


//returns 1 if Power button held long enough
// or 0 if not....
uint8_t PowerButton (bool OnOff)
{
    uint8_t ButtonPressHold;
    ButtonPressHold=0;
    bool ButtonPassed;
    ButtonPassed=0;
    
    while(!POWER_BUTTON_GetValue())
    {
        ButtonPressHold++;

        // Feed the watchdog: in the field (bootloader-programmed) config the
        // WDT period is only ~1.06s (4.1ms x PS256), and this hold-count runs
        // ~900ms -- without this, the WDT fires mid-count on every power-on
        // hold and the device reset-loops through the flash sequence.
        ClrWdt();

       BI_LED_GREEN_SetHigh();//Turn on Green LED
       BI_LED_RED_SetLow();//Turn off Red LED
      __delay_ms(100);
      BI_LED_RED_SetHigh();//Turn on Red LED
      BI_LED_GREEN_SetLow();//Turn off Green LED
      __delay_ms(50);
      if (ButtonPressHold>5)
      {
          ButtonPassed=1;

          break;
      }

    }
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
        

    __delay_ms(50);
    while(!POWER_BUTTON_GetValue())
    {
        ClrWdt();
       __delay_ms(50);    
    }
    
    __delay_ms(50);
    
     while(!POWER_BUTTON_GetValue())
    {
         ClrWdt();
         __delay_ms(50);    
    }
    
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

 void GetBattVolts(void)
 {
   
    uint8_t dst[2];
     BI_LED_GREEN_SetLow();//Turn off Green LED
     BI_LED_RED_SetHigh();//Turn on Red LED
     ClrWdt();
     i2c2_read_regs(0x36, 0x09, dst, 2);
      ClrWdt(); 
      
     EMULATE_EEPROM_Memory[8]=dst[1];
     EMULATE_EEPROM_Memory[9]=dst[0];
     BI_LED_GREEN_SetHigh();//Turn off Green LED
     BI_LED_RED_SetLow();//Turn on Red LED
 }

void GetAccel(void)
{
    BI_LED_GREEN_SetLow();//Turn off Green LED
    BI_LED_RED_SetHigh();//Turn on Red LED
    QuickAcellerometerGrabber();
    BI_LED_GREEN_SetHigh();//Turn off Green LED
    BI_LED_RED_SetLow();//Turn on Red LED
}



#ifdef Test1
void Test1PatternA(void)
{
  BI_LED_RED_SetHigh();//Turn on Red LED
  BI_LED_GREEN_SetLow();//Turn off Green LED
  FRONT_LASER_PWM_SetHigh();
  REAR_LASER_PWM_SetHigh();
}
void Test1PatternB(void)
{
  BI_LED_RED_SetLow();//Turn off Red LED
  BI_LED_GREEN_SetLow();//Turn off Green LED
  FRONT_LASER_PWM_SetLow();
  REAR_LASER_PWM_SetLow(); 
}


#endif

#ifdef Test2
void Test2PatternA(void)
{
  BI_LED_RED_SetLow();//Turn on Red LED
  BI_LED_GREEN_SetHigh();//Turn off Green LED
  FRONT_LASER_PWM_SetHigh();
  REAR_LASER_PWM_SetLow(); 
   BEAM_Toggle(); 
    
}
void Test2PatternB(void)
{
  BI_LED_RED_SetLow();//Turn on Red LED
  BI_LED_GREEN_SetLow();//Turn off Green LED
  FRONT_LASER_PWM_SetLow();
  REAR_LASER_PWM_SetHigh(); 
  BEAM_Toggle();  
    
}
#endif


void DummyTask(void)
{
    return;
}
 