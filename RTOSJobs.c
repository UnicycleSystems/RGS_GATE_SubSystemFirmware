
#include "mcc_generated_files/mcc.h"
#include "RTOSJobs.h"
#include "Events.h"
#include "MemoryMap.h"
#include "MultiJobConfig.h"

typedef signed char (*SmallJob)(unsigned char data);
typedef signed char (*MultiByteJob)(unsigned char data);


// Use the #define NumRWSingleJob 32   to set the number of SmallJobs. That is in MemoryMap.h
// don't forget to increment that every time a new job type is created here.
SmallJob SmallJobTable[NumRWSingleJob]={
    SetFrontAlignmentLaser,
    SetRearAlignmentLaser,
    SetDownLaser,
    FrontBeamLaserOnOff,
    RearBeamLaserOnOff,
    SetRedLed,
    SetGreenLed,
    SetBlueLed,
    
}; 




#include "MultiJobConfig.h"   //Sets up the multi job LUTS etc
signed char DoMultiByteJob (unsigned int address)
{
    signed char retval;
    signed int  JobIndex;
    
    JobIndex=LookUpMultiJob(address);
    if (JobIndex<0)
        return(-1); // ie if error returned, no job found, 
    // look up multi job fn ptr index.....
    retval = MultiJobTable[(unsigned int)JobIndex];   
    return(retval);
}
// assuming a sensible limit on the number of Multi byte jobs, 
// this is probably the best way to find the function
// the same index could be used to identify parameters, but currently assuming 
// the code pointed to has these baked in
signed int LookUpMultiJob (unsigned int address)
{
   signed int i;
   
   
   for (i=0;i<NumRWMultiJob;i++)
   {
     if (MultiJobLUT[i]==address)
     {
         return(i);
     }
   }
   return (-1); // if exited loop without finding it, then return error code
}

// this function is visible outside. 
signed char DoSingleByteJob (unsigned int address,unsigned char data)
{
    signed char retval;
    
    retval = SmallJobTable[address](data);
    
    return(retval);
}

//********* Single Byte Job functions **********
/* These are all 'single call' functions that 
 can be done quickly, so not complex queues
 All code for small jobs  now in RTOS_SmallJobs.h
 * where ' 'small job' is synonymous with 'single byte job
 */



/*****************************
***** Code Section contanining all the 'small' or
 *     'single byte' jobs.                     *
 *   note this is a header containing functional code, */
 
#include "RTOS_SmallJobs.h"
/*****************************
***** END Code Section contanining all the 'small' or
 *     'single byte' jobs.                        *
 */
  
//depending on how many functions like this, may refactor to
// a common function.
unsigned char BallDetectedJob(void)
{
   uint32_t TransitTime;
   uint16_t address;
   char err;
   address=TransitTimeAddr;
   
   TransitTime = TMR4_Counter32BitGet();
   
   err=Write32ToMemoryMap(TransitTime,address);  

    
   // remember to re-instate the last post increment if extending.
   
   
   
    
    //Copy Timer 4 into the 4 consecutive memory locations
    // Calculate the speed (m/s)
    //Store speed as 
}
    