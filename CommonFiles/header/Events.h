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
/* VOLATILE, and it matters. Every one of these is written by an interrupt
 * handler and read (or cleared) by the main loop:
 *
 *   DoTask       tmr2.c            - the one-second task tick
 *   FrontSense   pin_CustomISR.c   - beam broken at the front sensor
 *   RearSense    pin_CustomISR.c   - and at the rear
 *   TransitTime  pin_CustomISR.c   - TMR4 captured at the rear break
 *   LedOn        pin_CustomISR.c   - a ball is in the gate
 *   WakeUp       pin_CustomISR.c   - sensor activity while parked
 *   GateTimeout  tmr4.c            - the ball never arrived
 *
 * Without volatile the compiler is entitled to cache them in registers across
 * the main loop, and "if(DoTask)" would then never see the ISR's write. That
 * costs nothing at -O0, which is why this has worked so far, but it is a latent
 * bug and it is what makes -O1 unsafe on this code. Fixed ahead of any
 * optimisation change, because at -O1 the symptom is a unit that looks dead:
 * no one-second tick and no ball detection. */
 extern volatile char LedOn;
 extern volatile char FrontSense;
 extern volatile char RearSense;
 extern volatile uint32_t TransitTime;
 extern volatile uint8_t GateTimeout;
 extern volatile uint8_t WakeUp;
 extern uint8_t LightingUpdate;    /* main-line only - not written by any ISR */
 extern volatile uint8_t DoTask;
 
 

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
        unsigned int Reserved2 :1; // don't forget to update in Events.c if
        unsigned int Reserved3 :1; // used
        
        
        //etc, so up to 16 flags in total
        
    }Actions;
    
    extern volatile Actions RtosActions;   
  
    
  extern volatile uint8_t SelfResetTimeout;
  void ClearAllEvents(void);
  
 


#ifdef	__cplusplus
}
#endif

#endif	/* EVENTS_H */
