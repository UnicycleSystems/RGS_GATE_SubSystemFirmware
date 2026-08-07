//prototypes for custom ISR

//#include //"mcc_generated_files/mcc.h"
#include "RGS_MCC_Copies/tmr4.h"
#include "pin_CustomISR.h"
#include "RGS_MCC_Copies/pin_manager.h"
#include "Events.h"
#include "RGS_MCC_Copies/tmr2.h"

//Jump straight in with code...

void (ISR_CN_Dummy)(void)
{
    // clears flag and returns.
    /// already implemented in base line code
    // this is just to make it explicit
    
     IFS1bits.CNIF = 0;  // just  clear flag and go back.......
     
    
}
 
void (ISR_CN_FrontSensor)(void)
{
    //Clear and start the timer..
   TMR4_Counter32BitSet(0); 
   TMR4_Start();  //Disable the front sensor CN interrupt
   FrontSensorOff;
   TMR2_Stop();
           
   IFS1bits.T5IF = false;
   IEC1bits.T5IE = true;
   CN_SetInterruptHandler(ISR_CN_RearSensor);
   LedOn=1;
   FrontSense=1;
   RearSensorOn;
    // Time out will use TMR4_Interrupt - it overflows after approx 1s
    IFS1bits.CNIF = 0;  // just  clear flag and go back.......
  
    
}
void (ISR_CN_RearSensor)(void)
{
    TMR4_Stop();//Stop the timer. Do not re-enable interrupts
    TransitTime=TMR4_Counter32BitGet();
    RearSensorOff; ////Disable the rear sensor CN interrupt
    CN_SetInterruptHandler(ISR_CN_FrontSensor);
    RearSense=1;
    LedOn=1;
    FrontSensorOn;
    IFS1bits.T5IF = false;
   IEC1bits.T5IE = false;
    //RtosEvents.BallDetected = 1;
    IFS1bits.CNIF = 0;  // just  clear flag and go back.......
    // Don't re-engage the front sensor
    
}

void (ISR_CN_WakeUp)(void)
{
    WakeUp=1;
    IFS1bits.CNIF = 0;  // just  clear flag and go back.......  
}