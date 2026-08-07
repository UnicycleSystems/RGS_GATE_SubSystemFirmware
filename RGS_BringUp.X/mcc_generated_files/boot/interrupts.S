/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     interrupts.S
 * 
 * @brief    Lists all interrupts in the system and how they are shared/used
 *           between the bootloader and application projects.  Please read below
 *           for additional information.
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

/* This file lists all of the interrupts in the system and how they will be
 * handled.  This file is use by both the hardware interrupt table and the 
 * user remap table to make sure they both stay in sync.
 *
 * IMPORTANT NOTE: Once a boot loader is deployed using this file, this file 
 * can not be modified in the end application.  Take care when selecting how to 
 * handle each interrupt at the development of the boot loader.
 *
 * Options:
 *   remap_to_application - this forwards the interrupt directly to the
 *   user application.  Each interrupt forwarded will require 2 instructions
 *   for the GOTO in the user reamapping table thus taking up 6 bytes of program
 *   memory each.  This is the safest option for all interrupts implemented in 
 *   hardware.  
 *
 *   keep_in_bootloader - this option will keep the interrupt in the boot
 *   loader.  If the interrupt function is defined, it will just to that
 *   function.  If it is not defined, it will jump to the default interrupt 
 *   handler function.
 *
 *   remap_to_application_default - this forwards the interrupt directly to the
 *   user application's default interrupt handler rather than the specified 
 *   unique interrupt vector.  This option is useful for interrupts that the
 *   application does not expect to use.  Since each interrupt forwarded by the
 *   remap_to_application option takes 2 instruction words, can get quite costly
 *   to forward all possible interrupts.  Interrupts forwarded with this option
 *   do not take any additional code space to forward.  Since multiple
 *   interrupts will be forwarded to the same vector, the user code will have to
 *   check to see which interrupt triggered to process them accordingly.  
 */
    
#ifdef REMAP_TABLE    

REMAP_TO_APPLICATION_DEFAULT   ReservedTrap0       
REMAP_TO_APPLICATION   OscillatorFail       
REMAP_TO_APPLICATION   AddressError       
REMAP_TO_APPLICATION   StackError       
REMAP_TO_APPLICATION   MathError       
REMAP_TO_APPLICATION_DEFAULT   ReservedTrap5       
REMAP_TO_APPLICATION_DEFAULT   ReservedTrap6       
REMAP_TO_APPLICATION_DEFAULT   ReservedTrap7       
REMAP_TO_APPLICATION   INT0Interrupt       
REMAP_TO_APPLICATION   IC1Interrupt       
REMAP_TO_APPLICATION   OC1Interrupt       
REMAP_TO_APPLICATION   T1Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt4       
REMAP_TO_APPLICATION   IC2Interrupt       
REMAP_TO_APPLICATION   OC2Interrupt       
REMAP_TO_APPLICATION   T2Interrupt       
REMAP_TO_APPLICATION   T3Interrupt       
REMAP_TO_APPLICATION   SPI1ErrInterrupt       
REMAP_TO_APPLICATION   SPI1Interrupt       
REMAP_TO_APPLICATION   U1RXInterrupt       
REMAP_TO_APPLICATION   U1TXInterrupt       
REMAP_TO_APPLICATION   ADC1Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt14       
REMAP_TO_APPLICATION_DEFAULT   Interrupt15       
REMAP_TO_APPLICATION   SI2C1Interrupt       
REMAP_TO_APPLICATION   MI2C1Interrupt       
REMAP_TO_APPLICATION   CompInterrupt       
REMAP_TO_APPLICATION   CNInterrupt       
REMAP_TO_APPLICATION   INT1Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt21       
REMAP_TO_APPLICATION_DEFAULT   Interrupt22       
REMAP_TO_APPLICATION_DEFAULT   Interrupt23       
REMAP_TO_APPLICATION_DEFAULT   Interrupt24       
REMAP_TO_APPLICATION   OC3Interrupt       
REMAP_TO_APPLICATION   OC4Interrupt       
REMAP_TO_APPLICATION   T4Interrupt       
REMAP_TO_APPLICATION   T5Interrupt       
REMAP_TO_APPLICATION   INT2Interrupt       
REMAP_TO_APPLICATION   U2RXInterrupt       
REMAP_TO_APPLICATION   U2TXInterrupt       
REMAP_TO_APPLICATION   SPI2ErrInterrupt       
REMAP_TO_APPLICATION   SPI2Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt34       
REMAP_TO_APPLICATION_DEFAULT   Interrupt35       
REMAP_TO_APPLICATION_DEFAULT   Interrupt36       
REMAP_TO_APPLICATION   IC3Interrupt       
REMAP_TO_APPLICATION   IC4Interrupt       
REMAP_TO_APPLICATION   IC5Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt40       
REMAP_TO_APPLICATION   OC5Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt42       
REMAP_TO_APPLICATION_DEFAULT   Interrupt43       
REMAP_TO_APPLICATION_DEFAULT   Interrupt44       
REMAP_TO_APPLICATION   PMPInterrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt46       
REMAP_TO_APPLICATION_DEFAULT   Interrupt47       
REMAP_TO_APPLICATION_DEFAULT   Interrupt48       
REMAP_TO_APPLICATION   SI2C2Interrupt       
REMAP_TO_APPLICATION   MI2C2Interrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt51       
REMAP_TO_APPLICATION_DEFAULT   Interrupt52       
REMAP_TO_APPLICATION_DEFAULT   Interrupt53       
REMAP_TO_APPLICATION_DEFAULT   Interrupt54       
REMAP_TO_APPLICATION_DEFAULT   Interrupt55       
REMAP_TO_APPLICATION_DEFAULT   Interrupt56       
REMAP_TO_APPLICATION_DEFAULT   Interrupt57       
REMAP_TO_APPLICATION_DEFAULT   Interrupt58       
REMAP_TO_APPLICATION_DEFAULT   Interrupt59       
REMAP_TO_APPLICATION_DEFAULT   Interrupt60       
REMAP_TO_APPLICATION_DEFAULT   Interrupt61       
REMAP_TO_APPLICATION   RTCCInterrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt63       
REMAP_TO_APPLICATION_DEFAULT   Interrupt64       
REMAP_TO_APPLICATION   U1ErrInterrupt       
REMAP_TO_APPLICATION   U2ErrInterrupt       
REMAP_TO_APPLICATION   CRCInterrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt68       
REMAP_TO_APPLICATION_DEFAULT   Interrupt69       
REMAP_TO_APPLICATION_DEFAULT   Interrupt70       
REMAP_TO_APPLICATION_DEFAULT   Interrupt71       
REMAP_TO_APPLICATION   LVDInterrupt       
REMAP_TO_APPLICATION_DEFAULT   Interrupt73       
REMAP_TO_APPLICATION_DEFAULT   Interrupt74       
REMAP_TO_APPLICATION_DEFAULT   Interrupt75       
REMAP_TO_APPLICATION_DEFAULT   Interrupt76       
REMAP_TO_APPLICATION_DEFAULT   Interrupt77       
REMAP_TO_APPLICATION_DEFAULT   Interrupt78       
REMAP_TO_APPLICATION_DEFAULT   Interrupt79       
REMAP_TO_APPLICATION_DEFAULT   Interrupt80       
REMAP_TO_APPLICATION_DEFAULT   Interrupt81       
REMAP_TO_APPLICATION_DEFAULT   Interrupt82       
REMAP_TO_APPLICATION_DEFAULT   Interrupt83       
REMAP_TO_APPLICATION_DEFAULT   Interrupt84       
REMAP_TO_APPLICATION_DEFAULT   Interrupt85       
REMAP_TO_APPLICATION_DEFAULT   Interrupt86       
REMAP_TO_APPLICATION_DEFAULT   Interrupt87       
REMAP_TO_APPLICATION_DEFAULT   Interrupt88       
REMAP_TO_APPLICATION_DEFAULT   Interrupt89       
REMAP_TO_APPLICATION_DEFAULT   Interrupt90       
REMAP_TO_APPLICATION_DEFAULT   Interrupt91       
REMAP_TO_APPLICATION_DEFAULT   Interrupt92       
REMAP_TO_APPLICATION_DEFAULT   Interrupt93       
REMAP_TO_APPLICATION_DEFAULT   Interrupt94       
REMAP_TO_APPLICATION_DEFAULT   Interrupt95       
REMAP_TO_APPLICATION_DEFAULT   Interrupt96       
REMAP_TO_APPLICATION_DEFAULT   Interrupt97       
REMAP_TO_APPLICATION_DEFAULT   Interrupt98       
REMAP_TO_APPLICATION_DEFAULT   Interrupt99       
REMAP_TO_APPLICATION_DEFAULT   Interrupt100       
REMAP_TO_APPLICATION_DEFAULT   Interrupt101       
REMAP_TO_APPLICATION_DEFAULT   Interrupt102       
REMAP_TO_APPLICATION_DEFAULT   Interrupt103       
REMAP_TO_APPLICATION_DEFAULT   Interrupt104       
REMAP_TO_APPLICATION_DEFAULT   Interrupt105       
REMAP_TO_APPLICATION_DEFAULT   Interrupt106       
REMAP_TO_APPLICATION_DEFAULT   Interrupt107       
REMAP_TO_APPLICATION_DEFAULT   Interrupt108       
REMAP_TO_APPLICATION_DEFAULT   Interrupt109       
REMAP_TO_APPLICATION_DEFAULT   Interrupt110       
REMAP_TO_APPLICATION_DEFAULT   Interrupt111       
REMAP_TO_APPLICATION_DEFAULT   Interrupt112       
REMAP_TO_APPLICATION_DEFAULT   Interrupt113       
REMAP_TO_APPLICATION_DEFAULT   Interrupt114       
REMAP_TO_APPLICATION_DEFAULT   Interrupt115       
REMAP_TO_APPLICATION_DEFAULT   Interrupt116       
REMAP_TO_APPLICATION_DEFAULT   Interrupt117       

#endif
