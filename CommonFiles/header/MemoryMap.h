/* 
 * File:   MemoryMap.h
 * Author: peterbrewster
 *
 * Created on 27 June 2025, 09:37
 */

#ifndef MEMORYMAP_H
#define	MEMORYMAP_H

#ifdef	__cplusplus
extern "C" {
#endif
// it is only necessary to give the size of each area, the enum sorts that out
// and enforces the order of areas in the map 
#define MapOffset         0    // Might change later ? that's fine
#define NumRWSingleJob    8    
#define NumRWMultiJob     23
#define NumWriteOnly      47
#define EMULATE_EEPROM_SIZE 256  // Size TBD

// Memory region boundaries (address ranges, inclusive)
 
    

#define RWSingleJobEnd  (MapOffset + NumRWSingleJob - 1)
#define RWMultiJobStart  (NumRWSingleJob)
#define RWMultiJobEnd    (RWMultiJobStart + NumRWMultiJob - 1)
#define WriteOnlyStart (RWMultiJobEnd + 1)
#define WriteOnlyEnd     (WriteOnlyStart + NumWriteOnly - 1)
#define ReadOnlyStart    (WriteOnlyEnd + 1)
#define ReadOnlyEnd (EMULATE_EEPROM_SIZE_1)


/* thus the memory map is in strict order
 
 * Base address = MapOffset... surely 0?
 * Single byte Jobs ( ie a single byte write here, needs no look up, 
 * Multiple byte job -- needs a look up for function pointer
 * Write only - launches no job, just updates the memory.Items controlled by the 'jetson' 
 *              that embedded system may inspect arbitrarily
 * Read only - launches no job, , Items controlled by embedded systems that jetson may want at
 *             any time- 'protected/dynamic stuff, eg ball speeds, other 'local' data.
 * 
 */   
//Useful range checks

#define CHECK_ADDR_SINGLE_BYTE_JOB(Addr) ((Addr) < NumRWSingleJob ? 1 : 0)
#define CHECK_ADDR_MULTI_JOB(Addr) (((Addr) >= RWMultiJobStart) && ((Addr) < RWMultiJobEnd) ? 1 : 0)    
#define CHECK_WRITE_ONLY(Addr) (((Addr) >= WriteOnlyStart) && ((Addr) < WriteOnlyEnd) ? 1 : 0)  
#define CHECK_READ_ONLY(Addr) (((Addr) >= ReadOnlyStart) && ((Addr) < ReadOnlyEnd) ? 1 : 0)    
    
/*   at the jetson end, do something like....
 uint32_t reconstructed = 
    ((uint32_t)bytes[0]) |
    ((uint32_t)bytes[1] << 8) |
    ((uint32_t)bytes[2] << 16) |
    ((uint32_t)bytes[3] << 24);
 * 
 * just have seperate function for 16 and 32 bit values, consuming a pointer,
 * returning value
 */
    
 /******************************************************
  **         Read only table construction             **
  **         ensure this header remains synced        **
  **         jetson for  this header                  **
  **         Note, in this context, 'Read only' means **
  **         Data/parameters that the jetson can Read **
  **         but not write, but the camera board has  ** 
  **         Read and Write capacticy                 **
  * 
  * 
  *
  ******************************************************/
 
    
    
#define FirmwareVersionAddr ReadOnlyStart    // Firmware version on the camera board. two bytes, Major,minor
#define FirmwareVersionLen 2                 // Firmware version is the first thing in memory. 
    
#define TableVersionAddr (FirmwareVersionAddr + FirmwareVersionLen + 1)
#define TableVersionLen 1 
    
#define TransitTimeAddr (TableVersionAddr + TableVersionLen + 1)  
#define TransitTimeLen 4  // explicitly 4 bytes, in little endian
    
#define BallSpeeedAddr (TransitTimeAddr + TransitTimeLen + 1)   //Calculated Ball speed
#define BallSpeedLen 4   // assumed 4 bytes, not yet implemented
    
    
    
    
    
extern uint8_t EMULATE_EEPROM_Memory[EMULATE_EEPROM_SIZE];


// Functions used by Camera board to update/read  from map

char Write32ToMemoryMap (uint32_t Val32, uint16_t address);


#ifdef	__cplusplus
}
#endif

#endif	/* MEMORYMAP_H */

