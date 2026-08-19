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
#define NUM_EEpromJobs  8

//Prototypes for queue job handlers
void SetLasers();
void SetIRLevel();
void SetBallSpeedCal(); //allows jetson to calibrate ball speed, with the 'SetTicksPerSecond' propert)
void ChangeMode();   // go into other modes - eg survey, self test, etc
void ConfigAccelerometer();
void GenPurpJob();
void InitSelfReset();  // First stage of reset mechanism
void ConfirmSelfReset();// second stage of reset mechanism-- do within 10s of InitSelfReset

// the array below is all the function pointers... it's helpful if these are in the same
//order as the #defienes in EEpromBlockLbels.h
void (*EEPromJob[NUM_EEpromJobs])(void)={SetLasers,SetIRLevel,SetBallSpeedCal,ChangeMode,ConfigAccelerometer,GenPurpJob,InitSelfReset,ConfirmSelfReset};
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

void SetLasers()
{
    
    //Note logic APPEARS inverted, due to dual transistor drivers
  uint8_t LaserState;
 
  
  LaserState=EMULATE_EEPROM_Memory[ConfigLasersAddr];
 
  if (LaserState&0x01)
      FRONT_LASER_PWM_SetLow();
  else
      FRONT_LASER_PWM_SetHigh();
  
  if (LaserState&0x02)
      REAR_LASER_PWM_SetLow();
  else
      REAR_LASER_PWM_SetHigh();
  
   if (LaserState&0x04)
      BEAM_SetLow();
  else
      BEAM_SetHigh();
  /*
   if (LaserState&0x08)
       PWM_IR_SetHigh();
  else
       PWM_IR_SetLow();
  */
  
  
  //update memory Note that this is NOT where it was read from.
  //the purpose is to ensure that the jetson MAY  verify the change.
  EMULATE_EEPROM_Memory[LaserStateAddr]=LaserState;
     
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
    
}


void ChangeMode()   // go into other modes - eg survey, self test, etc
{
    
}
void InitSelfReset()    // First stage of reset mechanism
{
    if(EMULATE_EEPROM_Memory[169]==0x56)
    {
        EMULATE_EEPROM_Memory[169]=0;
        BI_LED_GREEN_SetLow();
        BI_LED_RED_SetHigh();
        SelfResetTimeout=10;
    }
    //TODO: option to add on an error report to jetson
    
}

void ConfirmSelfReset() // second stage of reset mechanism-- do within 10s of InitSelfReset
{
    if(SelfResetTimeout&&(EMULATE_EEPROM_Memory[170]==0x2F))
    {
        asm("reset");
        while(1);
    }
    else
    {
       EMULATE_EEPROM_Memory[169]=0;
       EMULATE_EEPROM_Memory[170]=0;
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
    SelfResetTimeout=0;  //can't assume it must be, as we may somehowe directly call this 
    
}

void ConfigAccelerometer()
{
    
}
void GenPurpJob()
{
    
}