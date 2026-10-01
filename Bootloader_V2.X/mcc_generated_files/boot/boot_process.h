/**
 * Generated 16-bit Bootloader Interface Header File
 * 
 * @file     boot_process.h
 * 
 * @brief    Defines interface for the bootloader command processor
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

#ifndef BOOT_PROCESS_H
#define BOOT_PROCESS_H

#include <stdbool.h>
#include <stdint.h>

enum BOOT_COMMAND_RESULT{
    BOOT_COMMAND_SUCCESS,
    BOOT_COMMAND_NONE,
    BOOT_COMMAND_INCOMPLETE,
    BOOT_COMMAND_ERROR,
};


void BOOT_Initialize(void);
enum BOOT_COMMAND_RESULT BOOT_ProcessCommand(void);
void BOOT_StartApplication(void);

/* RGS: set to 1 by every successful erase or write. main() consumes it to show
 * "programming" on the LEDs for a moment after the last flash operation. */
extern volatile uint8_t boot_programming_activity;

/* RGS: set to 1 when SELF_VERIFY passes on a session that actually programmed
 * flash - an update that is complete and verified. main() then resets and runs
 * the new application on its own, rather than waiting to be told to: a host
 * that dies after the verify would otherwise leave a good image unstarted. */
extern volatile uint8_t boot_launch_after_verify;
bool BOOT_Verify(void);

#endif 
