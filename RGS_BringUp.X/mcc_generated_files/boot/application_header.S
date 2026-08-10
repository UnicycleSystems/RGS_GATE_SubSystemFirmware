/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     application_header.S
 * 
 * @brief    Generates the application header at the required address and allocates
 *           space for fields that are generated post build.
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


/* This file puts an application header at the start of the application image 
 * that the bootloader will use to verify the integrity of the application image.
 */

#include "boot_config.h"

    .section .application_header, code, address(BOOT_CONFIG_APPLICATION_IMAGE_APPLICATION_HEADER_ADDRESS), keep

    /* Reserve space for the application verification value (checksum/crc/signature/etc.) */
    .space 4, 0

    /* Address where to start the verification check */
    .long(BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW)

    /* Address where to end the verification check.
     *
     * Derived from boot_config.h rather than hardcoded: these two values were
     * 0x2400/0xA7FE while the configured range said 0x9FFE, and the bootloader
     * rejects an image whose header end exceeds PROGRAMMABLE_ADDRESS_HIGH
     * (boot_verify_crc32.c). Deriving them keeps header and range in step.
     *
     * It also matters for the persistent flash store: the bootloader CRCs
     * exactly this range, so the persist banks at 0xA000-0xA7FF must fall
     * OUTSIDE it - otherwise every commit would change the CRC and the
     * application would be judged invalid on the next boot. */
    .long(BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH)

    /* Firmware Image Reset Remap */
    goto __resetPRI 

    /* Start of Extended Application Header */
    .word 0 

    /* Length of Extended Application Header */
    .long (2)

    /* Count of Items in Application Header */
    .word (2)

    /* Version Number ID */
    .word (2) 

    /* Version Number Length */
    .long (4) 

    /* Version Number Data - 32-bit number in the format of:
     *   0x00MMmmpp
     *     MM = Major revision
     *     mm = minor revision
     *     pp = patch revision
     *
     *     e.g. 0x00020A03 = version 2.10.3
     */
    .long(0x0)


