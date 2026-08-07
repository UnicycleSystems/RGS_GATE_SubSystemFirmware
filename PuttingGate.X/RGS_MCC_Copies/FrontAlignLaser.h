/**
  OC1 Generated Driver API Header File

  @Company
    Microchip Technology Inc.

  @File Name
    oc1.h

  @Summary
    This is the generated header file for the OC1 driver using PIC24 / dsPIC33 / PIC32MM MCUs

  @Description
    This header file provides APIs for driver for OC1.
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

#ifndef _FrontAlignLaser_H
#define _FrontAlignLaser_H

/**
  Section: Included Files
*/

#include <xc.h>
#include <stdint.h>
#include <stdbool.h>

#ifdef __cplusplus  // Provide C++ Compatibility

    extern "C" {

#endif

/**
  Section: Data Types
*/

/** OC1 Fault Number

  @Summary
    Defines the fault number

  @Description
    This type defines the various faults supported.

  Remarks:
    None
*/

typedef enum
{   
    /* Fault 0 */
    FrontAlignLaser_FAULT0        /*DOM-IGNORE-BEGIN*/  = 0,/*DOM-IGNORE-END*/
} FrontAlignLaser_FAULTS;

/**
  Section: Interface Routines
*/


/**
  @Summary
    This function initializes OC instance : 1

  @Description
    This routine initializes the OC1 driver instance for : 1
    index, making it ready for clients to open and use it.
    This routine must be called before any other OC1 routine is called.
	
  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Example
    <code>
    uint16_t priVal,secVal;
    bool completeCycle = false;
    priVal = 0x1000;
    secVal = 0x2000;
    FrontAlignLaser_FAULTS faultNum = FrontAlignLaser_FAULT0;

    FrontAlignLaser_Initialize();
    
    FrontAlignLaser_CentreAlignedPWMConfig( priVal, secVal );
  
    FrontAlignLaser_Start();

    while(1)
    {
        faultStat =  FrontAlignLaser_FaultStatusGet( faultNum );

        if(faultStat)
        {
            FrontAlignLaser_FaultStatusClear( faultNum );
        }

        completeCycle = FrontAlignLaser_IsCompareCycleComplete( void );
        if(completeCycle)
        {
            FrontAlignLaser_Stop();
        }
    }
    </code>

*/

void FrontAlignLaser_Initialize (void);

/**
  @Summary
    Callback for OC1.

  @Description
    This routine is callback for OC1

  @Param
    None.

  @Returns
    None
 
  @Example 
	Refer to FrontAlignLaser_Initialize(); for an example
*/
void FrontAlignLaser_CallBack(void);

/**
  @Summary
    Maintains the driver's state machine and implements its ISR

  @Description
    This routine is used to maintain the driver's internal state
    machine and implement its ISR for interrupt-driven implementations.
  
  @Preconditions
    None.

  @Param
    None.

  @Returns
    None.

  @Example
    <code>
    while (true)
    {
        FrontAlignLaser_Tasks();

        // Do other tasks
    }
    </code>
    
*/
void FrontAlignLaser_Tasks( void );

/**
  @Summary
    Enables the OC module with the corresponding operation mode.

  @Description
    This routine enables the OC module with the corresponding operation mode.

  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    None.

  @Returns
    None.

  @Example 
    Refer to FrontAlignLaser_Initialize() for an example	
 
*/
void FrontAlignLaser_Start( void );

/**
  @Summary
    Disables the OC module.

  @Description
    This routine disables the OC module.

  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    None.

  @Returns
    None.

*/
void FrontAlignLaser_Stop( void );

/**
  @Summary
    Sets the primary compare value of respective OC.
	
  @Description
    This routine sets the primary compare value for respective OC.

  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    priVal - 16 bit primary compare value.
    

  @Returns
    None.

  @Example 
    <code>
        uint16_t priVal = 0x1000;
        FrontAlignLaser_PrimaryValueSet( uint16_t priVal);
    <code> 
 	
*/
void FrontAlignLaser_PrimaryValueSet( uint16_t priVal);

/**
  @Summary
    Sets the secondary compare value of respective OC.
	
  @Description
    This routine sets the Secondary compare value for respective OC.

  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    secVal - 16 bit secondary compare value.
    

  @Returns
    None.

  @Example 
    <code>
        uint16_t secVal = 0x1000;
        FrontAlignLaser_SecondaryValueSet( uint16_t secVal);
    <code> 
 	
*/
void FrontAlignLaser_SecondaryValueSet( uint16_t secVal);


/**
  @Summary
    Gets the status of the compare cycle completion.

  @Description
    This routine gets the status of the compare cycle completion.

  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    None.

  @Returns
    Boolean value describing the current status of the cycle completion. Returns
    true  : When the compare cycle has completed. 
    false : When the compare cycle has not completed. 

  @Example 
    Refer to FrontAlignLaser_Initialize() for an example
	

*/
bool FrontAlignLaser_IsCompareCycleComplete( void );

/**
  @Summary
    Gets the status of the PWM fault condition occurrence.

  @Description
    This routine gets the status of the PWM fault condition occurrence.
  
  @Preconditions
    FrontAlignLaser_Initialize function should have been called 

  @Param
    faultNum - The fault number

  @Returns
    boolean value describing the occurrence of the fault condition.
    true  : When the specified fault has occurred.
    false : When the specified fault has not occurred.
	
  @Example 
    Refer to FrontAlignLaser_Initialize() for an example 
 

*/
bool FrontAlignLaser_FaultStatusGet( FrontAlignLaser_FAULTS faultNum );


#ifdef __cplusplus  // Provide C++ Compatibility

    }

#endif

#endif //_FrontAlignLaser_H
    
/**
 End of File
*/
