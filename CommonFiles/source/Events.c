#include "../header/Events.h"

/* volatile - see Events.h for which ISR writes each one and why it matters. */
volatile char LedOn=0;
 volatile char FrontSense=0;
 volatile char RearSense=0;
  uint8_t LightingUpdate=0;
 volatile uint32_t TransitTime=0;
volatile uint8_t GateTimeout=0;
volatile uint8_t DoTask=0;
volatile uint8_t WakeUp=0;

volatile Events EventJob;
volatile Actions RtosActions;

volatile uint8_t SelfResetTimeout; 

void ClearAllEvents(void)
{
       
       
        
}
