#include "../header/job_queue.h"
#include "../header/EEpromBlockLabels.h"
#include "../header/address_block_lookup.h"
#include "../header/pin_manager.h"
#include "../header/i2c1.h"
#include "../header/Events.h"
#include "../header/pin_manager.h"

#define JOB_QUEUE_SIZE 8   // must be a power of 2



static volatile uint8_t queue[JOB_QUEUE_SIZE];
static volatile uint8_t head = 0;   // next write index (producer owns)
static volatile uint8_t tail = 0;   // next read index (consumer owns)


//Job queue
// these are the jobs that are launched by an eeprom write
#define NUM_EEpromJobs 10

//Prototypes for queue job handlers
void SetLasers(void);
void SetIRLevel(void);
void SetBallSpeedCal(void); //allows jetson to calibrate ball speed, with the 'SetTicksPerSecond' propert)
void ChangeMode(void);   // go into other modes - eg survey, self test, etc
void ConfigAccelerometer();
void GenPurpJob();
void InitSelfReset();  // First stage of reset mechanism
void ConfirmSelfReset();// second stage of reset mechanism-- do within 10s of InitSelfReset
void CancelReset(void);
void JetsonCallingSubsys(void);
void JetsonAcknowledgeCall(void);
// the array below is all the function pointers... it's helpful if these are in the same
//order as the #defienes in EEpromBlockLbels.h
void (*EEPromJob[NUM_EEpromJobs])(void)={SetLasers,SetIRLevel,SetBallSpeedCal,ChangeMode,ConfigAccelerometer,GenPurpJob,InitSelfReset,ConfirmSelfReset,JetsonCallingSubsys,JetsonAcknowledgeCall};
uint8_t EEpromJobIndex;


// similarl scheme to 'tasks' however these are not on the ticker, these
// are queued 'RTos' like jobs. attempted every pass of main loop.
/// end job queue
/////////////////////////////////////////////////////////


void JobQueue_Init(void)
{
    head = 0;
    tail = 0;
}

bool JobQueue_Push(uint8_t job_index)
{
    uint8_t next_head = (uint8_t)((head + 1) & (JOB_QUEUE_SIZE - 1));

    if (next_head == tail)
    {
        // queue full, drop the job
        return false;
    }

    queue[head] = job_index;
    head = next_head;
    EventJob.JobWaiting=1;
    return true;
}

bool JobQueue_Pop()
{
  uint8_t job_index_pop;
    if (tail == head)
    {
        // queue empty
        EventJob.JobWaiting=0;
        return false;
    }

    job_index_pop = queue[tail];
    tail = (uint8_t)((tail + 1) & (JOB_QUEUE_SIZE - 1));
    
    if(tail==head)
        EventJob.JobWaiting=0;
    //This actually does the job. 
    EEPromJob[job_index_pop]();
    return true;
    
    
}

bool JobQueue_IsEmpty(void)
{
    return (tail == head);
}

/* See job_queue.h. The one place the lamp pins are driven, and the only writer
 * of the lamp bits in LaserState. */
void LampsApply(uint8_t lamps)
{
    lamps &= LaserState_LampsMask;

    /* OUT OF LEVEL: locked out, nothing may be lit. Note this still lets lamps
     * be switched OFF - lamps becomes 0, which is applied - so a power-down
     * works while locked out. */
    if (EMULATE_EEPROM_Memory[LaserStateAddr] & LaserState_OrientFault)
        lamps = 0;

    //Note logic APPEARS inverted, due to dual transistor drivers
    if (lamps & 0x01)
        FRONT_LASER_PWM_SetLow();
    else
        FRONT_LASER_PWM_SetHigh();

    if (lamps & 0x02)
        REAR_LASER_PWM_SetLow();
    else
        REAR_LASER_PWM_SetHigh();

    if (lamps & 0x04)
        BEAM_SetLow();
    else
        BEAM_SetHigh();
    /* The IR emitter (bit 3) is deliberately NOT driven here. It is on RB11,
     * shared with OC3, and PuttingGate drives that pin itself at start-up. */

    /* Record what was ACTUALLY applied, for the Jetson to read back. Masked, so
     * the lockout and the "lamps off" latch in this byte survive - assigning
     * the whole byte here used to clear them, which let a refused request
     * unlock itself as a side effect of being refused. */
    EMULATE_EEPROM_Memory[LaserStateAddr] =
        (uint8_t)((EMULATE_EEPROM_Memory[LaserStateAddr] & (uint8_t)~LaserState_LampsMask)
                  | lamps);
}

void SetLasers()
{
    /* The Jetson's request lives in ConfigLasersAddr and STAYS there, whether or
     * not it can be acted on now. If the gate is out of level LampsApply()
     * refuses it, and the orientation recovery re-applies this same byte once
     * the gate is level again - so a command given mid-tilt is deferred, not
     * lost. */
    LampsApply(EMULATE_EEPROM_Memory[ConfigLasersAddr]);
}
void SetIRLevel()
{
   uint8_t IR_level;
   
   IR_level=EMULATE_EEPROM_Memory[SetIRLevelAddr];
   EMULATE_EEPROM_Memory[IRLevelAddr]=IR_level;
   
   /// currently no functional code to update this!
   // just do the write and then see if it reads back 
   //TBD if just on/off or dimmable.
   
   
}
void SetBallSpeedCal() //allows jetson to calibrate ball speed
{
    return;
}


void ChangeMode()   // go into other modes - eg survey, self test, etc
{
    
}
void InitSelfReset()    // First stage of reset or power down
{
   
   //Whatever happens, any call to here will clear the 'confirm reset' and PowerOff states
   EMULATE_EEPROM_Memory[PowerOffFlag]=0;
   EMULATE_EEPROM_Memory[170]=0;
   
   
    if((EMULATE_EEPROM_Memory[169]==0x56)|| (EMULATE_EEPROM_Memory[169]==0x23))
    {
        BI_LED_GREEN_SetLow();
        BI_LED_RED_SetHigh();
        SelfResetTimeout=10;
        
        if(EMULATE_EEPROM_Memory[169]==0x56)//This sets up for a reset
            EMULATE_EEPROM_Memory[169]=0x41;  // set up another guard rail for reset
       
        
    
        if(EMULATE_EEPROM_Memory[169]==0x23)//This sets up for a PowerDown
            EMULATE_EEPROM_Memory[169]=0x42;//set up guard rail for power down
            
    }
    else// any invalid write, cancel anything pending
    {
        SelfResetTimeout=0;
        EMULATE_EEPROM_Memory[169]=0;   
    }
    // Do nothing if no valid value is written in here
    //TODO: option to add on an error report to jetson
    
}


void ConfirmSelfReset() // second stage of reset mechanism or power down -- do within 10s of InitSelfReset
{
    if((SelfResetTimeout)&&(EMULATE_EEPROM_Memory[170]==0x2F))
    {
        
        if(EMULATE_EEPROM_Memory[169]==0x41) // the reset case
        {    
            
        /* This used to refuse the reset unless /ACOK reported a charger, so a
         * unit could not drop into the bootloader with no way to be flashed.
         * It was REMOVED: the refusal was silent - the host saw a PIC that
         * simply would not reset - and it fired even with a charger connected.
         *
         * Nothing is lost by taking it out. The bootloader itself refuses every
         * erase and write without a charger (BOOT_BlockErase / BOOT_BlockWrite
         * in boot_image.c), which is where the image is actually at risk, so a
         * unit that resets without one still cannot damage anything: it waits in
         * the bootloader and a power cycle runs the existing application again. */
            asm("reset");
            while(1);
        }
        
      if(EMULATE_EEPROM_Memory[169]==0x42) // the Power down case
        {       
         EMULATE_EEPROM_Memory[PowerOffFlag]=ImmediatePowerOff;  // this will caues the 
        }  
        
        
    }
    else  // so any 'bad ' confirm will cancel the reset or power down..... 
    {
       EMULATE_EEPROM_Memory[169]=0;
       EMULATE_EEPROM_Memory[170]=0;
       EMULATE_EEPROM_Memory[PowerOffFlag]=0;
       BI_LED_GREEN_SetLow();
       BI_LED_RED_SetHigh(); 
    }
    //TODO: option to add on an error report to jetson
    
    
}

void CancelReset()// if confirm reset not called in time, then clear 
{
    BI_LED_GREEN_SetHigh();
    BI_LED_RED_SetLow();
    EMULATE_EEPROM_Memory[169]=0;
    EMULATE_EEPROM_Memory[170]=0;
    EMULATE_EEPROM_Memory[PowerOffFlag]=0;
    SelfResetTimeout=0;  //can't assume it must be, as we may somehowe directly call this 
    
}





void ConfigAccelerometer()
{
   return; 
}
void GenPurpJob()
{
  return;  
}
void JetsonCallingSubsys()
{
    return;
}
void JetsonAcknowledgeCall()
{
    return;
}