
/**
  OC3 Generated Driver API Source File

  @Company
    Microchip Technology Inc.

  @File Name
    oc3.c

  @Summary
    This is the generated source file for the OC3 driver using PIC24 / dsPIC33 / PIC32MM MCUs

  @Description
    This source file provides APIs for driver for OC3.
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

#include "oc3.h"

/** OC Mode.

  @Summary
    Defines the OC Mode.

  @Description
    This data type defines the OC Mode of operation.

*/

static uint16_t         gOC3Mode;

/**
  Section: Driver Interface
*/


void OC3_Initialize (void)
{
    // OC3RS 0; 
    OC3RS = 0x00;
    // OC3R 0; 
    OC3R = 0x00;
    // OCSIDL disabled; OCM PWM mode on OC, Fault pin is disabled; OCTSEL TMR3; 
    OC3CON = 0x0E;
	
    gOC3Mode = OC3CONbits.OCM;
}

void __attribute__ ((weak)) OC3_CallBack(void)
{
    // Add your custom callback code here
}

void OC3_Tasks( void )
{	
    if(IFS1bits.OC3IF)
    {
		// OC3 callback function 
		OC3_CallBack();
        IFS1bits.OC3IF = 0;
    }
}



void OC3_Start( void )
{
    OC3CONbits.OCM = gOC3Mode;
}


void OC3_Stop( void )
{
    OC3CONbits.OCM = 0;
}

void OC3_SecondaryValueSet( uint16_t secVal )
{
   
    OC3RS = secVal;
}


void OC3_PrimaryValueSet( uint16_t priVal )
{
   
    OC3R = priVal;
}

bool OC3_IsCompareCycleComplete( void )
{
    return(IFS1bits.OC3IF);
}


bool OC3_FaultStatusGet( OC3_FAULTS faultNum )
{
    bool status;
    /* Return the status of the fault condition */
   
    switch(faultNum)
    { 
        case OC3_FAULT0:
			status = OC3CONbits.OCFLT;
            break;
        default :
            break;

    }
    return(status);
}



/**
 End of File
*/
