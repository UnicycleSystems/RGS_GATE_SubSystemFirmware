/*
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <xc.h>

#include "JetsonInterface.h"
#include "Events.h"
#include "MemoryMap.h"

#define MaxNumJetsJobs 10

uint8_t JetsonJobStack[MaxNumJetsJobs][2];
  //Just a 2d array 
                                            // in  effect,  the  memory address and data.
   // if the value [*][1] is zero, that's a 'simple' job, where it's do whatever 
   // with the data indicated. The memory address dictates the job, and the 
// value at that address is 'what to do with it' . This covers all single byte jobs easily.
// multi byte jobs need to use the data in subsequent 
uint8_t JetsJobsOutstanding;  // 
uint8_t JetsNextJob;
uint8_t JetsJobQueue;
bool JetsQueueLock;










bool InitialiseJetsJobQueue(void)
{
   uint8_t Job;
   uint8_t Data;
   
   for (Job=0;Job<MaxNumJetsJobs;Job++)
   {
       JetsonJobStack[Job][0]=0;
       JetsonJobStack[Job][1]=0;  
   }
   JetsJobsOutstanding=0;
   JetsJobQueue=0; 
   JetsNextJob=0;
   JetsQueueLock=0;
   
}


unsigned char AddNewJetsonJob(unsigned char StartByte,unsigned char NumBytes)// just a 'push'
{
    //This is basically a 'push' to circular 
    if (JetsJobsOutstanding==10)//queue panic... 
    {
        JetsQueueLock=1;
        return(2); // error 2 meaning push failed, try again later
        //TODO: mark some memory spote and alert jetson we are full
    }
    
    
    JetsonJobStack[JetsJobQueue][0]=StartByte;
    JetsonJobStack[JetsJobQueue][1]=NumBytes;
    
    JetsJobsOutstanding++;
    JetsJobQueue++;
    if(JetsJobQueue==10)
        JetsJobQueue=0;  //Just wrap around, nothing  fancy
    RtosEvents.I2c_JetsonNewJob=1;  //ensure job gets done
    
    if (JetsJobsOutstanding==10)
        return(1); // Job was loaded, but stack now full, so no more just now
    return(0); //Job loaded, all good
    
    

}
bool DoNextJetsonJob(void)
{
    
}
bool CurrentJetsJob(void)
{
    
    // 
    
}
bool FlushJetsonJobs(void)
{
    
}
*/