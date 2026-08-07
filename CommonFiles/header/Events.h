/* 
 * File:   Events.h
 * Author: Peter
 *
 * Created on August 31, 2018, 12:06 PM
 */

#ifndef EVENTS_H
#define	EVENTS_H

#ifdef	__cplusplus
extern "C" {
#endif
  #include <stdint.h>  
 extern char LedOn;
 extern char FrontSense;
 extern char RearSense;
 extern uint32_t TransitTime;
 extern uint8_t GateTimeout;
 extern uint8_t WakeUp;
 extern uint8_t LightingUpdate;
 extern uint8_t DoTask;
 
 

 typedef struct EventFlags
    {
        unsigned int i2cQueJobWaiting :   1;   // A command from the jetson has been loaded on the queue
        unsigned int JobWaiting : 1;  
        unsigned int ResetPending : 1;
          //
        
        //etc, so up to 16 flags in total
        
    }Events;
    
  extern volatile Events EventJob;
   
  typedef struct ActionFlags
    {
        unsigned int GoToStandby :   1;
        unsigned int ProcessChar  :1; 
        unsigned int ProcessCommand : 1; 
        unsigned int ProcessADC : 1; 
        unsigned int ProcessUpstreamByte : 1;  
        unsigned int SendDownStreamPacket : 1; 
       
        unsigned int Send4Cells :1; // Rename is assigned
        unsigned int Spare2 :1; // don't forget to update in Events.c if
        unsigned int Spare3 :1; // used
        
        
        //etc, so up to 16 flags in total
        
    }Actions;
    
    extern volatile Actions RtosActions;   
  
    
  extern volatile uint8_t SelfResetTimeout;
  void ClearAllEvents(void);
  
 


#ifdef	__cplusplus
}
#endif

#endif	/* EVENTS_H */
