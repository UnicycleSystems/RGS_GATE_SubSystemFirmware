# include "InitEEpromVals.h"
#include "../CommonFiles/header/EEpromBlockLabels.h"
#include <stdint.h>
#include "../CommonFiles/header/MemoryMap.h"     /* if the file lives in CommonFiles/source */
#include "firmware_version.h"

// Exclusive to the bring up code, initialise the Emulated EEprom area

void ZeroEmulatedEEProm(void);
void PopulateSelectedEEprom(void);




void InitEmulatedEEprom (void)
{
    ZeroEmulatedEEProm();
    PopulateSelectedEEprom();
}

// This is only required in bring up code, to ensure that some baseline is set.
 void PopulateSelectedEEprom(void)
 {
     
     //Table version Firmware rev- Firmware gets update by app
     //Table version MUST NOT CHANGE. Table number is not up issued for purely additive changes.
     EMULATE_EEPROM_Memory[TableVersionAddr]=TableVersion;
     EMULATE_EEPROM_Memory[FirmwareVersionMSB] = FIRMWARE_REV_MSB;
     EMULATE_EEPROM_Memory[FirmwareVersionLSB] =FIRMWARE_REV_LSB;
     
     //TODO: HARDWARE VERSION COULD GO HERE
     
     
     //Ticks per second constant
     // this is 16,000,000 = 0x00F42400
     // directly derived from the XTAL (32MHz) / 2 driving the counter
     // there is(will be) a mechanism to update this, but a hard coded value
     // is appropriate
      EMULATE_EEPROM_Memory[TicksPerSecMMSB]=(uint8_t)(0x00); 
      EMULATE_EEPROM_Memory[ TicksPerSecNMSB]=(uint8_t)(0xF4);
      EMULATE_EEPROM_Memory[TicksPerSecHLSB]=(uint8_t)(0x24);
      EMULATE_EEPROM_Memory[TicksPerSecLLSB]=(uint8_t)(0x00);
      
     //Set the accelerometer calibrations to zero
     // the will get updated by the bring up,
      // but in the event of No cal process, these are pretty close
    EMULATE_EEPROM_Memory[Accl_CalZ_MSB_Addr]=0;   
    EMULATE_EEPROM_Memory[Accl_CalZ_LSB_Addr]=0; 
    EMULATE_EEPROM_Memory[Accl_CalY_MSB_Addr]=0;
    EMULATE_EEPROM_Memory[Accl_CalY_LSB_Addr]=0;  
    EMULATE_EEPROM_Memory[Accl_CalX_MSB_Addr]=0;
    EMULATE_EEPROM_Memory[Accl_CalX_LSB_Addr]=0;   
    
    
      
  
 }


void ZeroEmulatedEEProm(void)
{
    uint16_t loop;
    
    for (loop=0;loop<256;loop++)
    {
       EMULATE_EEPROM_Memory[loop]=0; 
    }
    
}
