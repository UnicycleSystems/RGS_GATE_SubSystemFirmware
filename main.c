/**
  Generated main.c file from MPLAB Code Configurator

  @Company
    Microchip Technology Inc.

  @File Name
    main.c

  @Summary
    This is the generated main.c using PIC24 / dsPIC33 / PIC32MM MCUs.

  @Description
    This source file provides main entry point for system initialization and application code development.
    Generation Information :
        Product Revision  :  PIC24 / dsPIC33 / PIC32MM MCUs - 1.171.5
        Device            :  PIC24FJ64GA004
    The generated drivers are tested against the following:
        Compiler          :  XC16 v2.10
        MPLAB 	          :  MPLAB X v6.05
*/

/*
    (c) 2020 Microchip Technology Inc. and its subsidiaries. You may use this
    software and any derivatives exclusively with Microchip products.

    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY IMPLIED
    WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS FOR A
    PARTICULAR PURPOSE, OR ITS INTERACTION WITH MICROCHIP PRODUCTS, COMBINATION
    WITH ANY OTHER PRODUCTS, OR USE IN ANY APPLICATION.

    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE,
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP HAS
    BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO THE
    FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL CLAIMS IN
    ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT OF FEES, IF ANY,
    THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS SOFTWARE.

    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF THESE
    TERMS.
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
/*
                         Main application
 */
int main(void)
{
    /* ---- CLEAN-HANDOFF FAST PATH (must stay FIRST in main) ----------------
     * If the previous boot cycle decided to launch the application, it left
     * BOOT_HANDOFF_MAGIC in persistent RAM and took a software reset. Every
     * peripheral is now at its datasheet reset state; jump to the app NOW,
     * before this bootloader warms anything up.
     *
     * Guards, in order:
     *  - RCONbits.SWR: the magic is only meaningful after a software reset.
     *    At cold power-on, persistent RAM is random garbage but SWR is 0, so
     *    garbage can never cause a false launch. (SWR is sticky within a
     *    power cycle; the magic itself -- consumed here, zeroed below -- is
     *    what prevents replay on later resets.)
     *  - magic match: 32-bit value, so even an SWR-gated accident is a
     *    ~1-in-4-billion event.
     *
     * The only pins touched before the jump are the power rails (µs of
     * work): HOLD_PWR stays latched so the supply survives the app's own
     * startup; the Jetson rail keeps whatever JETSON_CALLING implies, same
     * policy as a normal boot. The app re-owns all pins moments later.
     *
     * NOTE for reviewers: after a handoff, the app sees RCONbits.SWR = 1
     * (true -- a software reset really did occur). Anything in the app that
     * inspects RCON for reset-cause diagnostics should expect SWR rather
     * than a POR/BOR signature when launched via the bootloader.
     */
    if (RCONbits.SWR && boot_handoff_magic == BOOT_HANDOFF_MAGIC)
    {
        boot_handoff_magic = 0;          /* consume: never replay */
        HOLD_PWR_SetDigitalOutput();
        HOLD_PWR_SetHigh();
        JETSON_5V_ON_SetDigitalOutput();
        if (JETSON_CALLING_GetValue())
            JETSON_5V_ON_SetHigh();
        else
            JETSON_5V_ON_SetLow();
        BOOT_StartApplication();         /* never returns */
    }
    /* Not a handoff boot: make sure no stale/garbage value lingers. */
    boot_handoff_magic = 0;

    // Take the power pins as early as possible after reset.
    // HOLD_PWR: always latch our own supply on.
    // JETSON_5V_ON: ONLY keep the Jetson powered if it is the one calling
    // (JETSON_CALLING high = live update session; the Jetson is up and must
    // survive the reset). On a cold button boot the Jetson rail must stay
    // OFF: switching that load on while running from the button's momentary
    // power path causes an inrush brown-out reset loop (~5-10Hz flicker).
    HOLD_PWR_SetDigitalOutput();
    HOLD_PWR_SetHigh();
    JETSON_5V_ON_SetDigitalOutput();
    if (JETSON_CALLING_GetValue())
        JETSON_5V_ON_SetHigh();
    else
        JETSON_5V_ON_SetLow();


    SYSTEM_Initialize();
    FRONT_LASER_PWM_SetDigitalOutput();   
    REAR_LASER_PWM_SetDigitalOutput();
    
    FRONT_LASER_PWM_SetHigh();
    REAR_LASER_PWM_SetHigh();

    BOOT_DEMO_Initialize();

    while (1)
    {
        // Add your application code
        BOOT_DEMO_Tasks();
        ClrWdt();
    }

    return 1;
}
/**
 End of File
*/

