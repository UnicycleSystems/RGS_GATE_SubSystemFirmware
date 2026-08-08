/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     memory_partition.S
 * 
 * @brief    Defines blank sections that prevent the application from linking into
 *           sections of device memory that are not valid (the configuration
 *           page, the boot loader space, etc.)
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


#include "boot_config.h"
    .equ    ERASE_PAGE_MASK,(~((1024) - 1)) 
    .equ    LAST_PAGE_START_ADDRESS, (0xABFA & ERASE_PAGE_MASK)
    /* Derived from the configured top of the application region rather than
     * hardcoded, so it follows automatically when that range changes. It is
     * now 0xA000, which reserves the two persistent-flash banks
     * (BOOT_CONFIG_PERSIST_BANK_A/B) as well as the old config-page area --
     * application code must not link into either. */
    .equ    RESERVED_MEMORY_START, (BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH+2)
    .equ    PROGRAM_MEMORY_ORIGIN, (0x200)
    .equ    LAST_ADDRESS_OF_MEMORY, (0xABFA)
   
    /* The exectuable application image lives between:
     *   Start Address = 0x2400
     *   End Address = 0x9FFE
     * 
     * All other memory on the device must be reserved so that executable
     * application code can't link to those addresses.  This includes the space
     * required by the bootloader.
     *
     * The value in the address() field defines the start address.
     * The number on the .space defines the size of this block in PC units (2 per
     * instruction).
     */

    /* Reserve the memory used by the bootloader */
    .section *, code, address(PROGRAM_MEMORY_ORIGIN), noload, keep
boot_loader_memory:
    .space (BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW  - PROGRAM_MEMORY_ORIGIN), 0x00

    /* Reserve all of the memory after the last instruction of the executable
     * image, through the end of device memory.
     */
    .section *, code, address(RESERVED_MEMORY_START), noload, keep
config_page_memory:
    .space (LAST_ADDRESS_OF_MEMORY-RESERVED_MEMORY_START), 0x00
    
