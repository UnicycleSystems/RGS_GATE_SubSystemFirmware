/**
  PIN MANAGER Generated Driver File

  @Company:
    Microchip Technology Inc.

  @File Name:
    pin_manager.c

  @Summary:
    This is the generated manager file for the PIC24 / dsPIC33 / PIC32MM MCUs device.  This manager
    configures the pins direction, initial state, analog setting.
    The peripheral pin select, PPS, configuration is also handled by this manager.

  @Description:
    This source file provides implementations for PIN MANAGER.
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
    Section: Includes
*/

#include <xc.h>
#include <stdio.h>
#include "pin_manager.h"

/**
 Section: Driver Interface Function Definitions
*/
void PIN_MANAGER_Initialize (void)
{
    /****************************************************************************
     * Setting the Output Latch SFR(s)
     ***************************************************************************/
    LATA = 0x0000;
    LATB = 0x0000;
    LATC = 0x0010;

    /****************************************************************************
     * Setting the GPIO Direction SFR(s)
     ***************************************************************************/
    TRISA = 0x0797;
    TRISB = 0xCEFF;
    TRISC = 0x03EF;

    /* RA10 (HOLD_PWR) and RC1 (JETSON_5V_ON) are the RGS_PuttingGate
     * application's power-latch control pins. The generic bulk TRIS values
     * above configure both as inputs (floating), so we take explicit control:
     *
     *  - HOLD_PWR high, always: the bootloader must keep its own power
     *    alive. A field firmware update arrives via a reset from the running
     *    app; nobody is pressing the power button, so if this pin were low
     *    (or floating away), the board would power itself off mid-update.
     *
     *  - JETSON_5V_ON: CONDITIONAL on JETSON_CALLING. During a live update
     *    session (JETSON_CALLING high) the Jetson is up and must keep its
     *    5V rail through the reset. But on a cold button boot the Jetson
     *    rail must stay OFF: unconditionally switching that multi-amp load
     *    on here, while the board runs from the button's momentary power
     *    path, sags the supply and brown-out resets the PIC -- a
     *    self-sustaining ~5-10Hz reset/flicker loop that prevents power-up.
     *
     * This does NOT break the app's power-off path: PowerDown() drops both
     * pins and waits ~500ms before its reset, so on real (non-back-fed)
     * hardware the supply is gone before this code could ever run. The app
     * re-takes control of both pins within ~200ms on every normal boot.
     */
    _LATA10 = 1;
    _TRISA10 = 0;
    _LATC1 = JETSON_CALLING_GetValue() ? 1 : 0;
    _TRISC1 = 0;
    /****************************************************************************
     * Setting the Weak Pull Up and Weak Pull Down SFR(s)
     ***************************************************************************/
    CNPU1 = 0x0000;
    CNPU2 = 0x0400;

    /****************************************************************************
     * Setting the Open Drain SFR(s)
     ***************************************************************************/
    ODCA = 0x0000;
    ODCB = 0x0000;
    ODCC = 0x0000;

    /****************************************************************************
     * Setting the Analog/Digital Configuration SFR(s)
     ***************************************************************************/
    AD1PCFG = 0x180C;
    
    /****************************************************************************
     * Set the PPS
     ***************************************************************************/
    __builtin_write_OSCCONL(OSCCON & 0xbf); // unlock PPS

    RPOR10bits.RP20R = 0x0003;    //RC4->UART1:U1TX
    RPINR18bits.U1RXR = 0x0015;    //RC5->UART1:U1RX

    __builtin_write_OSCCONL(OSCCON | 0x40); // lock PPS
}

