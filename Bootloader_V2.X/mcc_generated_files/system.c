/**
  @Generated PIC24 / dsPIC33 / PIC32MM MCUs Source File

  @Company:
    Microchip Technology Inc.

  @File Name:
    system.h

  @Summary:
    This is the sysetm.h file generated using PIC24 / dsPIC33 / PIC32MM MCUs

  @Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  PIC24 / dsPIC33 / PIC32MM MCUs - 1.171.5
        Device            :  PIC24FJ64GA004
    The generated drivers are tested against the following:
        Compiler          :  XC16 v2.10
        MPLAB             :  MPLAB X v6.05
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

// Configuration bits: selected in the GUI
//
// IMPORTANT: these are the AUTHORITATIVE config words for the whole device,
// including the RGS_PuttingGate application. Config words live at
// 0xABFC/0xABFE, outside the bootloader's UART-writable range, so whatever
// is burned in with this bootloader via ICSP is permanent for the life of
// the installation -- the application's own #pragma config settings never
// reach the chip. Values that the application depends on:
//   I2C1SEL = SEC : the app's Jetson-facing I2C1 slave is wired to the
//                   ALTERNATE pins (ASDA1/ASCL1 = RB5/RB6); PRI would attach
//                   the module to RB8/RB9, which the app uses as GPIO
//                   (INTERRUPT_TO_JETSON / BI_LED_RED_ON).
//   IOL1WAY = OFF : both this bootloader and the app perform their own PPS
//                   unlock/lock sequence; ON would brick the app's PPS setup.
//   IESO    = ON  : start on FRC while the HS crystal warms up, so code runs
//                   (and drives the power-latch pins) as soon as possible
//                   after every reset.

// CONFIG2
#pragma config POSCMOD = HS    //Primary Oscillator Select->HS Oscillator mode selected
#pragma config I2C1SEL = SEC    //I2C1 Pin Location Select->Use alternate SCL1/SDA1 pins (required by RGS_PuttingGate app)
#pragma config IOL1WAY = OFF    //IOLOCK Protection->IOLOCK may be changed via unlocking seq
#pragma config OSCIOFNC = ON    //Primary Oscillator Output Function->OSC2/CLKO/RC15 functions as port I/O (RC15)
#pragma config FCKSM = CSDCMD    //Clock Switching and Monitor->Clock switching and Fail-Safe Clock Monitor are disabled
#pragma config FNOSC = PRI    //Oscillator Select->Primary Oscillator (XT, HS, EC)
#pragma config SOSCSEL = SOSC    //Sec Oscillator Select->Default Secondary Oscillator (SOSC)
#pragma config WUTSEL = LEG    //Wake-up timer Select->Legacy Wake-up Timer
#pragma config IESO = ON    //Internal External Switch Over Mode->IESO mode (Two-Speed Start-up) enabled

// CONFIG1
#pragma config WDTPS = PS2048    //Watchdog Timer Postscaler->1:2048 (~8.4s period; PS256's ~1.06s proved hair-trigger against the app's ~900ms button-hold UI loops)
#pragma config FWPSA = PR128    //WDT Prescaler->Prescaler ratio of 1:128
#pragma config WINDIS = ON    //Watchdog Timer Window->Standard Watchdog Timer enabled,(Windowed-mode is disabled)
#pragma config FWDTEN = ON    //Watchdog Timer Enable->Watchdog Timer is enabled (period = 4.1ms prescaled LPRC tick x WDTPS postscale; PS2048 -> ~8.4s)
#pragma config ICS = PGx1    //Comm Channel Select->Emulator EMUC1/EMUD1 pins are shared with PGC1/PGD1
#pragma config BKBUG = OFF    //Background Debug->Device resets into Operational mode
//   GWRP = OFF : MUST stay OFF. General-segment write protect blocks run-time
//                (RTSP) writes to program flash -- which is exactly how this
//                bootloader programs the application. GWRP=ON would break all
//                field updates. The boot region is instead protected in
//                software by BOOT's IsLegalRange() check (UART writes are
//                confined to 0x2400-0xA7FE).
//   GCP  = ON  : code-READ protect. Blocks reading program memory back out
//                through the ICSP/programmer interface -- protects both the
//                bootloader and the application IP (whole-chip: one flash, one
//                fuse, cannot be applied to just one). Does NOT hinder the
//                CPU's own TBLRD reads, so BOOT_ImageVerify()/CRCFlash still
//                work. A bulk (chip) erase still clears protection, which is
//                how you re-provision a unit via ICSP.
//                *** VERIFY BEFORE RELEASE (see notes to Peter): confirm on
//                real silicon that after GCP=ON a full field update still
//                completes AND self-verify passes; and that the programmer
//                readback is genuinely refused. ***
#pragma config GWRP = OFF    //General Code Segment Write Protect->Writes to program memory are allowed (REQUIRED for bootloader RTSP)
/* GCP OFF for development (2026-08-11). ON enables whole-device READ
 * protection, which is what IP protection in the field wants - but it also
 * stops the programmer reading flash back, so every re-programme fails
 * verification with "expected <x>, got 0x00000000" once the first protected
 * image is on the part. Zeros rather than 0xFFFFFF is the signature.
 *
 * This affects READ access only. Execution is unaffected, and so is the
 * bootloader's self-programming, which depends on GWRP below (left OFF).
 *
 * Turn this back ON for production images. */
#pragma config GCP = OFF    //General Code Segment Code Protect->Code read protection disabled
#pragma config JTAGEN = OFF    //JTAG Port Enable->JTAG port is disabled

#include "pin_manager.h"
#include "clock.h"
#include "system.h"
#include "../../CommonFiles/header/flash.h"
#include "boot/boot_process.h"
#include "interrupt_manager.h"
#include "traps.h"
#include "uart1.h"

void SYSTEM_Initialize(void)
{
    BOOT_Initialize();
    PIN_MANAGER_Initialize();
    INTERRUPT_Initialize();
    CLOCK_Initialize();
    UART1_Initialize();
}




/**
 * 
 * 
 * #pragma config FWPSA = PR32    // 1:32 prescale
#pragma config FWPSA = PR128   // 1:128 prescale
 * 
 * 
 #pragma config WDTPS = PS1
#pragma config WDTPS = PS2
#pragma config WDTPS = PS4
#pragma config WDTPS = PS8
#pragma config WDTPS = PS16
#pragma config WDTPS = PS32
#pragma config WDTPS = PS64
#pragma config WDTPS = PS128
#pragma config WDTPS = PS256
#pragma config WDTPS = PS512
#pragma config WDTPS = PS1024
#pragma config WDTPS = PS2048
#pragma config WDTPS = PS4096
#pragma config WDTPS = PS8192
#pragma config WDTPS = PS16384
#pragma config WDTPS = PS32768
 * 
 * 
 * the period is nominally 4.1ms (LPRC)  . So the watchdog period is effectively 
    4.1e-3 * WDTP * WDTPS    seconds   
 End of File
*/