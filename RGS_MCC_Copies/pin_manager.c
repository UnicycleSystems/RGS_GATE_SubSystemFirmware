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
#include "../pin_CustomISR.h"

/**
 Section: File specific functions
*/
void (*CN_InterruptHandler)(void) = NULL;

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
    LATC = 0x0000;

    /****************************************************************************
     * Setting the GPIO Direction SFR(s)
     ***************************************************************************/
    TRISA = 0x0297;
    TRISB = 0x44EF;
    TRISC = 0x03A1;
    TRISBbits.TRISB12=0;
    /****************************************************************************
     * Setting the Weak Pull Up and Weak Pull Down SFR(s)
     ***************************************************************************/
    CNPU1 = 0x0000;
    CNPU2 = 0x0000;
    CNPU2bits.CN16PUE = 1;   //just the power switch is pulled up
    CNPU2bits.CN21PUE =1;  // hopefully, RA9 pulled up
    /****************************************************************************
     * Setting the Open Drain SFR(s)
     ***************************************************************************/
    ODCA = 0x0000;
    ODCB = 0x0000;
    ODCC = 0x0000;
    /****************************************************************************
     * Setting the Analog/Digital Configuration SFR(s)
     ***************************************************************************/
    AD1PCFG = 0x1FFF;
    
    /****************************************************************************
     * Set the PPS
     ***************************************************************************/
    __builtin_write_OSCCONL(OSCCON & 0xbf); // unlock PPS

    RPOR5bits.RP11R = 0x0014;    //RB11->OC3:OC3
    //RPOR6bits.RP12R = 0x0015;    //RB12->OC4:OC4 RB12 no longer PWM
    //RPOR6bits.RP13R = 0x0016;    //RB13->OC5:OC5 RB13 is green, no longer pwm
    //RPOR2bits.RP4R = 0x0012;    //RB4->OC1:OC1   RB4 is front laser,just on/off now
    RPOR10bits.RP20R = 0x0003;    //RC4->UART1:U1TX
    RPINR18bits.U1RXR = 0x0015;    //RC5->UART1:U1RX
    //RPOR9bits.RP18R = 0x0013;    //RC2->OC2:OC2 RC2 is rear laser, just on/off now

    __builtin_write_OSCCONL(OSCCON | 0x40); // lock PPS
    
    /****************************************************************************
     * Interrupt On Change: any
     ***************************************************************************/
    CNEN1bits.CN2IE = 0;    //Pin : RA0
    CNEN1bits.CN3IE = 0;    //Pin : RA1
    CNEN2bits.CN16IE = 0;    //Pin RB10 - power button
    
    /* Initialize IOC Interrupt Handler*/
    //CN_SetInterruptHandler(&CN_CallBack);
    CN_SetInterruptHandler(ISR_CN_FrontSensor);  
    
    /****************************************************************************
     * Interrupt On Change: Interrupt Enable
     ***************************************************************************/
    IFS1bits.CNIF = 0; //Clear CNI interrupt flag
    IEC1bits.CNIE = 1; //Enable CNI interrupt
}

void RestoreDetect(void)
{
    
    CNEN1bits.CN2IE = 1;    //Pin : RA0
    CNEN1bits.CN3IE = 0;    //Pin : RA1
    CN_SetInterruptHandler(ISR_CN_FrontSensor); 
    IFS1bits.CNIF = 0; //Clear CNI interrupt flag
    IEC1bits.CNIE = 1; //Enable CNI interrupt
    
    
    
}

void __attribute__ ((weak)) CN_CallBack(void)
{

}

void CN_SetInterruptHandler(void (* InterruptHandler)(void))
{ 
    IEC1bits.CNIE = 0; //Disable CNI interrupt
    CN_InterruptHandler = InterruptHandler; 
    IEC1bits.CNIE = 1; //Enable CNI interrupt
}

void CN_SetIOCInterruptHandler(void *handler)
{ 
    CN_SetInterruptHandler(handler);
}

/* Interrupt service routine for the CNI interrupt. */
void __attribute__ (( interrupt, no_auto_psv )) _CNInterrupt ( void )
{
    if(IFS1bits.CNIF == 1)
    {
        if(CN_InterruptHandler) 
        { 
            CN_InterruptHandler(); 
        }
        
        // Clear the flag
        IFS1bits.CNIF = 0;
    }
}

