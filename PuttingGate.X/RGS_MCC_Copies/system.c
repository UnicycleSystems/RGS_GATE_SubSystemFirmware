
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

// Configuration bits: when this image is loaded through Bootloader_V2.X via
// UART, config words can never be rewritten (they live at 0xABFC/0xABFE,
// outside the bootloader's writable range 0x2400-0xA7FE) -- whatever is
// burned in when Bootloader_V2.X is ICSP-programmed is what actually takes
// effect, so config words are omitted in that build to avoid drift between
// two never-enforced copies. See Bootloader_V2.X/mcc_generated_files/system.c
// for the authoritative config word settings used in the field.
//
// STANDALONE_BUILD is defined only by the "Standalone" MPLAB X build
// configuration, used for direct ICSP/debugger use without the bootloader
// present, where this project owns the whole chip and must set its own
// config words.
#ifdef STANDALONE_BUILD

// CONFIG2
#pragma config POSCMOD = HS    //Primary Oscillator Select->HS Oscillator mode selected
#pragma config I2C1SEL = SEC    //I2C1 Pin Location Select->Use alternate SCL1/SDA1 pins
#pragma config IOL1WAY = ON    //IOLOCK Protection->Once IOLOCK is set, cannot be changed
#pragma config OSCIOFNC = OFF    //Primary Oscillator Output Function->OSC2/CLKO/RC15 functions as CLKO (FOSC/2)
#pragma config FCKSM = CSDCMD    //Clock Switching and Monitor->Clock switching and Fail-Safe Clock Monitor are disabled
#pragma config FNOSC = PRI    //Oscillator Select->Primary Oscillator (XT, HS, EC)
#pragma config SOSCSEL = SOSC    //Sec Oscillator Select->Default Secondary Oscillator (SOSC)
#pragma config WUTSEL = LEG    //Wake-up timer Select->Legacy Wake-up Timer
#pragma config IESO = ON    //Internal External Switch Over Mode->IESO mode (Two-Speed Start-up) enabled

// CONFIG1
#pragma config WDTPS = PS2048    //Watchdog Timer Postscaler->1:512
#pragma config FWPSA = PR128    //WDT Prescaler->Prescaler ratio of 1:128
#pragma config WINDIS = OFF    //Watchdog Timer Window->Standard Watchdog Timer enabled,(Windowed-mode is disabled)
#pragma config FWDTEN = OFF    //Watchdog Timer Enable->Watchdog Timer is enabled
#pragma config ICS = PGx1    //Comm Channel Select->Emulator EMUC1/EMUD1 pins are shared with PGC1/PGD1
#pragma config BKBUG = OFF    //Background Debug->Device resets into Operational mode
#pragma config GWRP = OFF    //General Code Segment Write Protect->Writes to program memory are allowed
#pragma config GCP = OFF    //General Code Segment Code Protect->Code protection is disabled
#pragma config JTAGEN = OFF    //JTAG Port Enable->JTAG port is disabled

#endif

#include "pin_manager.h"
#include "clock.h"
#include "system.h"
#include "interrupt_manager.h"
//#include "traps.h"
#include "tmr4.h"
//#include "uart1.h"
//#include "uart2.h"
#include "tmr1.h"
#include "tmr2.h"
//#include "tmr3.h"
//#include "oc1.h"
#include "i2c1.h"
//include "oc2.h"
//#include "oc5.h"
//#include "oc3.h"
//#include "oc4.h"
#include "i2c2.h"

void SYSTEM_Initialize(void)
{
    PIN_MANAGER_Initialize();
    /* PIN_MANAGER_Initialize just drove LATA=0, dropping HOLD_PWR (RA10) low.
     * Re-latch our own supply IMMEDIATELY and UNCONDITIONALLY -- on a cold
     * boot from the bootloader handoff the button is already released and, on
     * battery, HOLD_PWR is the only thing holding 3V3 up; leaving it low here
     * powers the device off partway through startup. Only PowerDown() drops
     * it deliberately. The Jetson 5V rail is kept alive only on a warm boot
     * (POR==0) so it survives a firmware-update reset; on a cold boot it
     * stays dark until power-on completes. */
    HOLD_PWR_SetDigitalOutput();
    HOLD_PWR_SetHigh();
    if(RCONbits.POR == 0)
    {
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();
    }

  
   
    CLOCK_Initialize();
    INTERRUPT_Initialize();
    //OC4_Initialize();
    //UART1_Initialize();
    TMR4_Initialize();
    //OC1_Initialize();
   // OC3_Initialize();
    TMR2_Initialize();
    I2C2_Initialize();
    //UART2_Initialize();
   // OC5_Initialize();
    I2C1_Initialize();
   // OC2_Initialize();
    TMR1_Initialize();
}

/**
 End of File
*/