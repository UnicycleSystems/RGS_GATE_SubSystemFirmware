#include "Events.h"

char LedOn=0;
 char FrontSense=0;
 char RearSense=0;
  uint8_t LightingUpdate=0;
 uint32_t TransitTime=0;
uint8_t GateTimeout=0;
uint8_t DoTask=0;
uint8_t WakeUp=0;

volatile Events EventJob;
volatile Actions RtosActions;

volatile uint8_t SelfResetTimeout; 

void ClearAllEvents(void)
{
       
       
        
}
