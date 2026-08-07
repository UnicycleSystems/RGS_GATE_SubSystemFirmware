#include "MemoryMap.h"



char Write32ToMemoryMap (uint32_t Val32, uint16_t address)
{
    
   uint8_t index;
   
   for(index=0;index<4;index++)
   {
     EMULATE_EEPROM_Memory[address++] = (uint8_t)((Val32)  & 0xFF); 
     Val32 >>=8;
   } 
}


