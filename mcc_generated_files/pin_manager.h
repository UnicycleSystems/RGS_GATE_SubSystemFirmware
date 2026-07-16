/**
  PIN MANAGER Generated Driver File

  @Company:
    Microchip Technology Inc.

  @File Name:
    pin_manager.h

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

#ifndef _PIN_MANAGER_H
#define _PIN_MANAGER_H
/**
    Section: Includes
*/
#include <xc.h>


#define JETSON_5V_ON_SetHigh()          (_LATC1 = 1)

#define JETSON_5V_ON_SetLow()           (_LATC1 = 0)

#define JETSON_5V_ON_Toggle()           (_LATC1 ^= 1)

#define JETSON_5V_ON_GetValue()         _RC1

#define JETSON_5V_ON_SetDigitalInput()  (_TRISC1 = 1)

#define JETSON_5V_ON_SetDigitalOutput() (_TRISC1 = 0)

#define HOLD_PWR_SetHigh()         (_LATA10 = 1) 

#define HOLD_PWR_SetLow()           (_LATA10 = 0)

#define HOLD_PWR_Toggle()           (_LATA10 ^= 1)

#define HOLD_PWR_GetValue()         _RA10

#define HOLD_PWR_SetDigitalInput()  (_TRISA10 = 1)

#define HOLD_PWR_SetDigitalOutput() (_TRISA10 = 0)



#define BI_LED_GREEN_SetHigh()          (_LATB12 = 1)

#define BI_LED_GREEN_SetLow()           (_LATB12 = 0)

#define BI_LED_GREEN_Toggle()           (_LATB12 ^= 1)

#define BI_LED_GREEN_GetValue()         _RB12

#define BI_LED_GREEN_SetDigitalInput()  (_TRISB12 = 1)

#define BI_LED_GREEN_SetDigitalOutput() (_TRISB12 = 0)

#define BI_LED_RED_SetHigh()          (_LATB13 = 1)

#define BI_LED_RED_SetLow()           (_LATB13 = 0)

#define BI_LED_RED_Toggle()           (_LATB13 ^= 1)

#define BI_LED_RED_GetValue()         _RB13

#define BI_LED_RED_SetDigitalInput()  (_TRISB13 = 1)

#define BI_LED_RED_SetDigitalOutput() (_TRISB13 = 0)

#define JETSON_CALLING_SetHigh()          (_LATB7 = 1)

#define JETSON_CALLING_SetLow()           (_LATB7 = 0)

#define JETSON_CALLING_Toggle()           (_LATB7 ^= 1)

#define JETSON_CALLING_GetValue()         _RB7

#define JETSON_CALLING_SetDigitalInput()  (_TRISB7 = 1)

#define JETSON_CALLING_SetDigitalOutput() (_TRISB7 = 0)

#define CALL_JETSON_SetHigh()          (_LATB8 = 1)

#define CALL_JETSON_SetLow()           (_LATB8 = 0)

#define CALL_JETSON_Toggle()           (_LATB8 ^= 1)

#define CALL_JETSON_GetValue()         _RB8

#define CALL_JETSON_SetDigitalInput()  (_TRISB8 = 1)

#define CALL_JETSON_SetDigitalOutput() (_TRISB8 = 0)

#define FRONT_LASER_PWM_SetDigitalOutput() (_TRISB4 = 0)
#define FRONT_LASER_PWM_SetLow()           (_LATB4 = 0)
#define FRONT_LASER_PWM_SetHigh()          (_LATB4 = 1)

#define REAR_LASER_PWM_SetDigitalOutput() (_TRISC2 = 0)
#define REAR_LASER_PWM_SetLow()           (_LATC2 = 0)
#define REAR_LASER_PWM_SetHigh()          (_LATC2 = 1)


void PIN_MANAGER_Initialize (void);



#endif
