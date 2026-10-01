/**
 * Generated 16-bit Bootloader Source File
 * 
 * @file     boot_image.c
 * 
 * @brief    Boot loader file responsible for handling addressing application
 *           image(s).
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

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <xc.h>

#include "../../../CommonFiles/header/flash.h"
#include "boot_private.h"
#include "boot_image.h"
#include "boot_config.h"


struct IMAGE {
    uint32_t startAddress;
};

const static struct IMAGE images[] = 
{
    {
        .startAddress = 0x2400
    },
};

#define FLASH_ERASE_MASK (~((FLASH_ERASE_PAGE_SIZE_IN_INSTRUCTIONS*2UL) - 1)) 

static bool IsLegalAddress(uint32_t addressToCheck)
{
   return ( (addressToCheck >= EXECUTABLE_IMAGE_FIRST_ADDRESS) && (addressToCheck <= EXECUTABLE_IMAGE_LAST_ADDRESS) );
}

/* ---- RGS: the charger gate, where flash is actually modified -------------
 * /ACOK on RA7 is the charger IC's AC-present output: LOW means present.
 *
 * boot_process.c also checks it in its ERASE and WRITE handlers, but that is
 * ONE check per command - and BOOT_BlockErase() below erases a whole region
 * page by page, so a charger pulled straight after that check still lost the
 * entire application. Checking here instead:
 *
 *   - covers EVERY caller of these functions, now and later, rather than the
 *     two command handlers that happen to check today;
 *   - is repeated before each page erase and each write block, so losing the
 *     charger part way stops the operation instead of finishing it.
 *
 * Flash is never unlocked at all unless the charger is present when asked.
 */
static bool ChargerPresent(void)
{
    return (PORTAbits.RA7 == 0);
}

/* Several reads before committing to an erase or a write: an open-collector
 * line and a single sample are not worth the application image. Any sample
 * reading high means no charger. The spacing is deliberately small - this
 * rejects a glitch, it is not waiting for the line to settle. */
static bool ChargerPresentSettled(void)
{
    uint8_t sample;
    uint8_t spin;

    for (sample = 0; sample < 5u; sample++)
    {
        if (!ChargerPresent())
            return false;
        for (spin = 0; spin < 40u; spin++)
            Nop();
    }
    return true;
}


bool IsLegalRange(uint32_t startRangeToCheck, uint32_t endRangeToCheck)
{
    return ( IsLegalAddress(startRangeToCheck) && IsLegalAddress(endRangeToCheck - 2u) );
}


NVM_RETURN_STATUS BOOT_BlockWrite(uint32_t deviceAddress, uint32_t lengthInBytes, uint8_t *sourceData, uint32_t key)
{
    uint32_t count = 0;
    enum NVM_RETURN_STATUS response = NVM_SUCCESS;
    
    if (!ChargerPresentSettled())
    {
        return NVM_NO_CHARGER;          /* nothing is unlocked, nothing written */
    }

    if ((lengthInBytes % MINIMUM_WRITE_BLOCK_SIZE) == 0u)
    {
        if ( IsLegalRange(deviceAddress, deviceAddress + (lengthInBytes/2u)) )
        {

        FLASH_Unlock(key);


        for (count = 0; count < lengthInBytes; count += MINIMUM_WRITE_BLOCK_SIZE)
        {
            uint32_t flashData[MINIMUM_WRITE_BLOCK_SIZE/sizeof(uint32_t)];
            uint32_t physicalWriteAddress = BOOT_ImageAddressGet(DOWNLOAD_IMAGE_NUMBER, deviceAddress + (count/2u));

            if (!ChargerPresent())      /* charger gone mid-block: stop here */
            {
                response = NVM_NO_CHARGER;
                break;
            }

            memcpy(&flashData[0], &sourceData[count], MINIMUM_WRITE_BLOCK_SIZE);

            if (FLASH_WriteWord24(physicalWriteAddress, flashData[0] ) == false)
            {
                response = NVM_WRITE_ERROR;
                break;
            }
        }

 
        FLASH_Lock();
        }
        else
        {
            response = NVM_INVALID_ADDRESS;
        }
    }
    else
    {
        response = NVM_INVALID_LENGTH;
    }
    
    return response;
}

NVM_RETURN_STATUS BOOT_BlockRead (uint8_t *destinationData, uint32_t lengthInBytes, uint32_t nvmAddress)
{
    uint32_t count;
    uint32_t flashData;
    enum NVM_RETURN_STATUS response = NVM_SUCCESS;
    
    if ((lengthInBytes % 4u) == 0u)
    {
        if (IsLegalRange(nvmAddress, nvmAddress + (lengthInBytes/2u))) 
        {
            for (count = 0u; count < lengthInBytes; count += 4u)
                {
                    uint32_t physicalReadAddress = BOOT_ImageAddressGet(DOWNLOAD_IMAGE_NUMBER, nvmAddress + (count/2u));
                    flashData = FLASH_ReadWord24(physicalReadAddress);
                    memcpy(&destinationData[count], &flashData, 4u);
                }
        }
        else
        {
            response = NVM_INVALID_ADDRESS;
        }
    } else
    {
        response = NVM_INVALID_LENGTH;
    }
 
    return response;
}


NVM_RETURN_STATUS BOOT_BlockErase (uint32_t nvmAddress, uint32_t lengthInPages, uint32_t key)
{
    enum NVM_RETURN_STATUS response = NVM_SUCCESS;
    uint32_t eraseAddress = nvmAddress;
    bool goodErase = true;
    bool chargerLost = false;

    if (!ChargerPresentSettled())
    {
        return NVM_NO_CHARGER;          /* nothing is unlocked, nothing erased */
    }

    // check to make sure page is aligned here.
    if ( (eraseAddress & FLASH_ERASE_MASK) != eraseAddress)
    {
        goodErase = false;
    }

    FLASH_Unlock(key);

    #define ERASE_SIZE_REQUESTED ((uint32_t)(lengthInPages) * FLASH_ERASE_PAGE_SIZE_IN_PC_UNITS)

    while (goodErase && (eraseAddress < (nvmAddress +  ERASE_SIZE_REQUESTED ) ))
    {
        if (!ChargerPresent())      /* re-checked per PAGE, not once per command */
        {
            chargerLost = true;
            break;
        }

        if (IsLegalRange(eraseAddress, eraseAddress+FLASH_ERASE_PAGE_SIZE_IN_PC_UNITS))
        {
            uint32_t physicalEraseAddress = BOOT_ImageAddressGet(DOWNLOAD_IMAGE_NUMBER, eraseAddress);
            goodErase = (uint8_t) FLASH_ErasePage(physicalEraseAddress);

            eraseAddress += FLASH_ERASE_PAGE_SIZE_IN_PC_UNITS;
        }
        else
        {
            goodErase = false;
        }
    }

    FLASH_Lock();

    if (chargerLost)
    {
        response = NVM_NO_CHARGER;
    }
    else if ((!goodErase) || (eraseAddress != (nvmAddress + ERASE_SIZE_REQUESTED)))
    {
        response = NVM_INVALID_ADDRESS;
    }
    
    return response;
}

uint32_t BOOT_ImageAddressGet(enum BOOT_IMAGE image, uint32_t addressInExecutableImage)
{
    uint32_t offset = addressInExecutableImage - images[BOOT_IMAGE_0].startAddress;
    return images[image].startAddress + offset;
}

uint16_t BOOT_EraseSizeGet()
{
    return (FLASH_ERASE_PAGE_SIZE_IN_INSTRUCTIONS * 2u);
}

NVM_RETURN_STATUS BOOT_Read32Data (uint32_t *destinationData,  uint32_t nvmAddress)
{
    *destinationData = FLASH_ReadWord16(nvmAddress);
    *destinationData += ((uint32_t)FLASH_ReadWord16(nvmAddress + 2)) << 16;
    
    return NVM_SUCCESS;
}

NVM_RETURN_STATUS BOOT_Read16Data (uint16_t *destinationData,  uint32_t nvmAddress)
{
    *destinationData = FLASH_ReadWord16(nvmAddress);

    return NVM_SUCCESS;
}


        
   
   

