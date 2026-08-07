/**
ain entry point for system initialization and application code development.
    Generation Information :
        Product Revision  :  PIC24 / dsPIC33 / PIC32MM MCUs - 1.171.5
        Device            :  PIC24FJ64GA004
    The generated drivers are tested against the following:
        Compiler          :  XC16 v2.10
        MPLAB 	          :  MPLAB X v6.05
*/



/**
  Section: Included Files
*/
#include "mcc_generated_files/system.h"
#include "mcc_generated_files/boot/boot_demo.h"
#include "mcc_generated_files/boot/boot_process.h"
#include "mcc_generated_files/pin_manager.h"
#include <xc.h>
#include <stdbool.h>



#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>

void AttemptShutDown(void);

/*
                         Main application
 */
int main(void)
{
    /* ---- CLEAN-HANDOFF FAST PATH (must stay FIRST in main) ----------------
     immediatley, ensure the 5V for the jetson, and the 3v3 for the pic are switched on
     Then, check if this is a warm or cold boot, if a restart from bootloader with a new app'
     * if so, then just launce the app
     * Other wise, continue starting bootloader
     */
        HOLD_PWR_SetDigitalOutput();
        HOLD_PWR_SetHigh();                 /* always: stay alive */
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();             /* always power the Jetson while in the bootloader */
    if (RCONbits.SWR && boot_handoff_magic == BOOT_HANDOFF_MAGIC)
    {
        boot_handoff_magic = 0;          /* consume: never replay */
        
        BOOT_StartApplication();         /* never returns */
    }
    /* Not a handoff boot: make sure no stale/garbage value lingers. */
    boot_handoff_magic = 0;

    // Take the power pins as early as possible after reset.
    // HOLD_PWR: always latch our own supply on.
    // JETSON_5V_ON: always powered while in the bootloader (needed for cold
    // bring-up and to keep the Jetson alive across an update reset).


    SYSTEM_Initialize();
    // After System_Initialise, we Verbosely ensure the power is maintained
    // rather than rely on sys init to be correct.
    HOLD_PWR_SetDigitalOutput();
    HOLD_PWR_SetHigh();
    JETSON_5V_ON_SetDigitalOutput();
    JETSON_5V_ON_SetHigh();             /* always power the Jetson while in the bootloader */
    FRONT_LASER_PWM_SetDigitalOutput();
    REAR_LASER_PWM_SetDigitalOutput();
    
    FRONT_LASER_PWM_SetHigh();
    REAR_LASER_PWM_SetHigh();

    BOOT_DEMO_Initialize();
    
    RED_LED_ON_SetDigitalOutput();
    RED_LED_ON_SetHigh();
    POWER_BUTTON_SetDigitalInput();
    
    //simple debounce of power button...
    while(POWER_BUTTON_PRESSED())
    {
        ClrWdt();
        __delay_ms(20);
    }
    RED_LED_ON_SetHigh();
    while(POWER_BUTTON_PRESSED())
    {
        ClrWdt();
        __delay_ms(20);
    }
    

    while (1)
    {
        if (POWER_BUTTON_PRESSED())
            AttemptShutDown();
        // Add your application code
        BOOT_DEMO_Tasks();
        ClrWdt();
    }

    return 1;
}

void AttemptShutDown(void)
{
  uint8_t HoldOffDelay;
  HoldOffDelay=0;
  
  while(POWER_BUTTON_PRESSED())
  {
    
    RED_LED_ON_SetHigh();
    __delay_ms(10);
    RED_LED_ON_SetLow();
    __delay_ms(30);
    HoldOffDelay++;
    if (HoldOffDelay==30)   //button pressed long enough to qualify as 'off'
    {
         HOLD_PWR_SetLow();
         JETSON_5V_ON_SetLow();

         /* On battery, dropping the rails removes power and we simply die in
          * this loop. If we are still executing after ~1.5s then external
          * power is holding 3V3 up (plugged in): force the next boot to look
          * COLD (POR) and reset, so we land in the app's charge-indication
          * state instead of hanging here forever. Mirrors the app's
          * PowerDown() so both images treat a plugged-in "off" identically. */
         uint8_t stillAlive = 0;
         while(1)
         {
             ClrWdt();
             __delay_ms(50);
             if(++stillAlive >= 30)
             {
                 RCONbits.POR  = 1;
                 RCONbits.BOR  = 1;
                 RCONbits.EXTR = 1;
                 asm("reset");
             }
         }
    }
    
  }
  
  RED_LED_ON_SetHigh();
    
}
/**
 End of File
*/

