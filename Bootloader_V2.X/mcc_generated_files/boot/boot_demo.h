/**
 * Generated 16-bit Bootloader Interface Header File
 * 
 * @file     boot_demo.h
 * 
 * @brief    Defines interface for the functions that run the bootloader demo
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


#ifndef BOOT_DEMO_H
#define BOOT_DEMO_H

#include <stdint.h>

void BOOT_DEMO_Initialize(void);
void BOOT_DEMO_Tasks(void);

/* ---- Clean-handoff support ------------------------------------------------
 * Instead of calling the application directly from a warm, half-configured
 * bootloader (live UART, possibly-pending interrupt flags, running timers),
 * the bootloader records its "launch the app" decision in a persistent RAM
 * word and executes a software RESET. main() checks the word within
 * microseconds of the next reset -- before ANY peripheral is touched -- and
 * jumps to the application, which therefore starts from genuine post-reset
 * silicon. This is the proper answer to the MCC-generated warning "Return
 * device to reset state before starting the application".
 *
 * __attribute__((persistent)) places the variable in .pbss, which the XC16
 * C runtime deliberately does NOT initialise, so the value survives the
 * software reset. It does NOT survive a power cycle (contents random at
 * power-on), which is why the consumer in main() also gates on RCONbits.SWR
 * (only ever set by a software reset) and why every non-handoff boot
 * explicitly zeroes the word.
 */
#define BOOT_HANDOFF_MAGIC 0xB007CAFEUL

extern volatile uint32_t __attribute__((persistent)) boot_handoff_magic;

#endif
