/**
 * Generated 16-bit Bootloader Interface Header File
 * 
 * @file     boot_config.h
 * 
 * @brief    Defines all of the boot loader configuration options
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

#ifndef BOOT_CONFIG_H
#define BOOT_CONFIG_H

#define BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW 0x2400
#define BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH 0x9FFE

#define BOOT_CONFIG_DOWNLOAD_LOW 0x2400
#define BOOT_CONFIG_DOWNLOAD_HIGH 0x9FFE

/* ---- Persistent flash store (RGS) --------------------------------------
 * Two erase pages sitting immediately above the application region, holding
 * data that must survive a firmware update.
 *
 * The programmable/download range above deliberately STOPS at 0x9FFE (it was
 * 0xA7FE) so the bootloader's IsLegalAddress() refuses every erase and write
 * into this area. The protection is enforced in the device, not by whatever
 * the host tool happens to send. The bootloader has, and needs, no knowledge
 * of what is stored here.
 *
 * Two banks so a commit is power-fail safe: the spare bank is erased and
 * written, and only becomes the live copy once its CRC and sequence number
 * are in place. An erase page is 512 instructions = 0x400 PC units, so each
 * bank is exactly one page.
 *
 * Deliberately NOT the 0xA800 page, which is also outside the download range:
 * CONFIG1/CONFIG2 live at 0xABFC/0xABFE inside it, so erasing it would take
 * the configuration fuses with it.
 *
 * The bank addresses themselves live in CommonFiles/header/persist_store.h,
 * which is the single source of truth for the store's geometry.
 */

#define BOOT_CONFIG_VERIFICATION_APPLICATION_HEADER_SIZE 12

#define BOOT_CONFIG_APPLICATION_IMAGE_APPLICATION_HEADER_ADDRESS (BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW)

#define BOOT_CONFIG_APPLICATION_RESET_ADDRESS (BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW + BOOT_CONFIG_VERIFICATION_APPLICATION_HEADER_SIZE)

#define BOOT_CONFIG_USER_IVT_TABLE_ADDRESS 0x2600


#define BOOT_CONFIG_VERSION 0x0102

#define BOOT_CONFIG_MAX_PACKET_SIZE 0x100

#endif