/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     boot_demo.c
 * 
 * @brief    Example boot loader implementation.  This file determines:
 *           - when to stay in boot loader mode
 *           - when/how an application image is verified
 *           - when to jump to an application
 *           - when to load a backup application image
 *           - when to load a newly downloaded image (if there is a separate download image slot) 
 *
 *           It is intended that the user will replace/modify this file to meet their
 *           design needs.  This file provides an example implementation.
 *
 * @skipline @version    16-bit Bootloader - 1.26.0
 *
 * @skipline             Device : PIC24FJ64GA004
*/
/*
    (c) [2026] Microchip Technology Inc. and its subsidiaries.

    Subject to your compliance with these terms, you may use Microchip 
    software and any derivatives exclusively with Microchip products. 
    You are responsible for complying with 3rd party license terms  
    applicable to your use of 3rd party software (including open source  
    software) that may accompany Microchip software. SOFTWARE IS "AS IS." 
    NO WARRANTIES, WHETHER EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS 
    SOFTWARE, INCLUDING ANY IMPLIED WARRANTIES OF NON-INFRINGEMENT,  
    MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT 
    WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY 
    KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF 
    MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE 
    FORESEEABLE. TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP?S 
    TOTAL LIABILITY ON ALL CLAIMS RELATED TO THE SOFTWARE WILL NOT 
    EXCEED AMOUNT OF FEES, IF ANY, YOU PAID DIRECTLY TO MICROCHIP FOR 
    THIS SOFTWARE.
*/


#include <stdbool.h>
#include <stdint.h>
#include "boot_demo.h"
#include "boot_config.h"
#include "boot_application_header.h"
#include "boot_image.h"
#include "boot_process.h"
#include "../pin_manager.h"

#define DOWNLOADED_IMAGE    0u
#define EXECUTION_IMAGE     0u

static bool inBootloadMode = false;
static bool executionImageRequiresValidation = true;
static bool executionImageValid = false;

/* Clean-handoff flag (see boot_demo.h). Written here just before the
 * handoff reset; consumed (or zeroed) by main() at the top of every boot.
 * 'persistent' => lives in .pbss, untouched by the C runtime's data init,
 * so it survives asm("reset"). */
volatile uint32_t __attribute__((persistent)) boot_handoff_magic;

static bool EnterBootloadMode(void);

void BOOT_DEMO_Initialize(void)
{    
    
}


void BOOT_DEMO_Tasks(void)
{
    if(inBootloadMode == false)
    {
        if( EnterBootloadMode() == true )
        {
            inBootloadMode = true;
        }
        else
        {
            if( executionImageRequiresValidation == true )
            {
                executionImageValid = BOOT_ImageVerify(EXECUTION_IMAGE);
            }

            if(executionImageValid == false)
            {
                inBootloadMode = true;
            }

            if(inBootloadMode == false)
            {
                /* CLEAN HANDOFF: do NOT call the application from here.
                 * At this point the bootloader is "warm": UART1 is live
                 * (possibly with pending RX/error flags), timers have been
                 * counting, and pin state is mid-session. Calling the app
                 * directly hands it all of that, which is exactly what the
                 * old MCC #warning ("return device to reset state before
                 * starting the application") complained about.
                 *
                 * Instead: record the launch decision in persistent RAM and
                 * take a REAL reset. The reset returns every peripheral to
                 * its datasheet reset state; main() spots the magic within
                 * microseconds of restart -- before initialising anything --
                 * and jumps to the app from clean silicon.
                 *
                 * (A bare asm("reset") here WITHOUT the flag just restarts
                 * the bootloader forever -- the reset vector is ours, not
                 * the app's. That was the failed earlier experiment.)
                 */
                BI_LED_GREEN_SetHigh();
                BI_LED_RED_SetLow();
                boot_handoff_magic = BOOT_HANDOFF_MAGIC;
                asm("reset");
                /* not reached */
            }
        }

        if(inBootloadMode == true)
        {
            BI_LED_RED_SetHigh();
            BI_LED_GREEN_SetLow();
        }
    }

    (void)BOOT_ProcessCommand();
}

static bool EnterBootloadMode(void)
{
    /* Stay in the boot loader when JETSON_CALLING is driven high at reset;
     * otherwise fall through to the application image. */
    return JETSON_CALLING_GetValue();
}
