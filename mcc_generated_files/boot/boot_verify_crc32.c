/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     boot_verify_crc32.c
 * 
 * @brief    Verifies an application image via a 32-bit CRC
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


#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>

#include "boot_config.h"
#include "boot_image.h"

#include <stdio.h>

#define MEMCPY_BUFFERS_MATCH 0

extern uint32_t CRC32Bit(uint32_t crc, uint32_t input);
extern uint32_t CRCFlash(uint32_t crcSeed, uint32_t startAddress, uint32_t endAddress);

struct BOOT_VERIFY_APPLICATION_HEADER
{
    uint32_t crc32;
    uint32_t startAddress;
    uint32_t endAddress;
};

static const uint32_t applicationHeaderAddress = BOOT_CONFIG_APPLICATION_IMAGE_APPLICATION_HEADER_ADDRESS;

static inline bool isOdd(uint32_t number)
{
    return ((number & 0x00000001) == 0x00000001);
}

static void ApplicationHeaderRead(uint32_t sourceAddress, struct BOOT_VERIFY_APPLICATION_HEADER *applicationHeader)
{
    BOOT_Read32Data (&applicationHeader->crc32, sourceAddress);
    BOOT_Read32Data (&applicationHeader->startAddress, sourceAddress + 4);
    BOOT_Read32Data (&applicationHeader->endAddress,   sourceAddress + 8);
}

bool BOOT_ImageVerify(enum BOOT_IMAGE image)
{   
    struct BOOT_VERIFY_APPLICATION_HEADER applicationHeader;
    uint32_t calculatedCRC;

    if( image >= BOOT_IMAGE_COUNT )
    {
        return false;
    }

    ApplicationHeaderRead(BOOT_ImageAddressGet(image, applicationHeaderAddress), &applicationHeader);

    if( isOdd(applicationHeader.startAddress) )
    {
        return false;
    }
    
    if( isOdd(applicationHeader.endAddress) )
    {
        return false;
    }

    if( applicationHeader.startAddress < BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW )
    {
        return false;
    }

    if( applicationHeader.endAddress < BOOT_CONFIG_PROGRAMMABLE_ADDRESS_LOW )
    {
        return false;
    }

    if( applicationHeader.startAddress > BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH )
    {
        return false;
    }

    if( applicationHeader.endAddress > BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH )
    {
        return false;
    }
    
    if( applicationHeader.startAddress > applicationHeader.endAddress)
    {
        return false;
    }
    
    /* Is the application header outside the memory range to be verified? */
    if( (applicationHeaderAddress < applicationHeader.startAddress) ||
        (applicationHeaderAddress > applicationHeader.endAddress)
    )
    {
        calculatedCRC = CRCFlash(0x00000000, BOOT_ImageAddressGet(image, applicationHeader.startAddress), BOOT_ImageAddressGet(image, applicationHeader.endAddress));
    }
    else
    {
        /* If the application header is inside of the memory range to be verified, we
         * can't include the CRC value inside the CRC calculation, so we must
         * ignore the CRC value in the application header by pushing in 0s instead.
         */
        calculatedCRC = 0;
        if(applicationHeader.startAddress != applicationHeaderAddress)
        {
            calculatedCRC = CRCFlash(calculatedCRC, BOOT_ImageAddressGet(image, applicationHeader.startAddress), BOOT_ImageAddressGet(image, applicationHeaderAddress - 2));
        }
        /* push in 2 instructions of 0s to blank out the CRC signature in the
         * image applicationHeader.
         */
        calculatedCRC = CRCFlash(calculatedCRC, 0, 0);
        calculatedCRC = CRCFlash(calculatedCRC, 0, 0);
        /* resume with the rest of the application image. */
        calculatedCRC = CRCFlash(calculatedCRC, BOOT_ImageAddressGet(image, applicationHeaderAddress + 4), BOOT_ImageAddressGet(image, applicationHeader.endAddress));
    }
    
    return ( calculatedCRC  == applicationHeader.crc32 );
}

bool BOOT_Verify(void)
{
    return BOOT_ImageVerify(0);
}
