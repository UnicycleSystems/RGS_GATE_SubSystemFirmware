/* 
 * File:   EEpromBlockLabels.h
 * Author: peterbrewster
 *
 * Created on 30 June 2026, 12:03
 */

#ifndef EEPROMBLOCKLABELS_H
#define	EEPROMBLOCKLABELS_H

#ifdef	__cplusplus
extern "C" {
#endif


    
//This reference for eeprom locations/functions
// the memory is divided into two sections, read only and read/write
// in practice, the write area is only read internally
// 'writable' areas are for the jetson/client to intiate some state change
// (lasers, parameters, etc)  
// the readable area is for the client to get constants, active data, and verify that 
// any state change has been performed
    
// this will contain nothing other than #defines, and as such may contain 
// features that appear redundant to this (pic24) code. This is because
// it is intended to serve as a shareable reference between the subsytem and the 
// client - currently PIC 24 and Jetson, respectively
    
// Writeable areas starts at 128 onwards.
// readable is the lower half.
// note there is some attempt at structure, 
// commonly read data is all at the bottom (0)
// wheres parameters, things read infrequently start at 127 and 
// are being populated in reverse order.




// 'Hard coded' parameters that are used by the subsystem build, 
// to be  checked/ updated on any release
//These are not, in this form, directly used by the 
#define   TableVersion 3   //Version 3 - added power handling and jetson calls/alerts,aliases for some internals
 // -------   *****  Please do read this. It's not hard. ***********  
 //---------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!-----------------------
 // 
 //             FAO: any devs writing code that talks to the emulated eeprom on this device
 //             (ie the client code on Jetson or other   )
 //
 //             NOTE: use of alias's in the addressing schem.
 /*      
               This table is a convenient block of 256 bytes. The first half,
  (0 - 127 is strictly READ only from client side . The second half,
  128-255  is writeable, and is used to launch 'jobs' here.
  
  There is a complexity arising. The table was intended to have a short section and the 
  beginning that would be always read in one long packed, whereas the remainder is 
  to be read randomly, and at random packetlengths. Thus the first half of the table
  grows naturally from 0 to whereever it ends. The second half of the table grows from
  127 downwards, ie the space is used decrementally. This was to allow both sections to
  be added to, with arbitary gaps, needs to re-align, etc. 
  All of these are read LSB first. (or just 'value' in the case of a byte value)
  To create some consistency in the naming, alias's have been added for all parameters
  in that Read-only half. 
  * 
  * For example the address to read the Battery Pack voltage,
  *   BatteryPackVoltage_Addr  has an alias,
  * #define BattVoltReadAddr  BatteryPackVoltage_Addr
  * 
  * which may seem supreflous,
  * 
  * However, in the later part of the table, the derivation of the addresses
  * is inconsistent, so for example,  FirmwareVersionAddr actually points at the MSB
  * an alias is created to correct this.
  * 
  * #define FirmwareVerReadAddr FirmwareVersionLSB
  * 
  * each of these alias's ais the final entry in each sub-group,
  * with a blank line between the body of the group, and the alias
  * for example
  
  #define FirmwareVersionAddr (TableVersionAddr - TableVersionNumBytes)
  #define FirmwareVersionNumBytes 2
  #define FirmwareVersionMSB FirmwareVersionAddr
  #define FirmwareVersionLSB  ( FirmwareVersionMSB - 1 )
  
  #define FirmwareVerReadAddr (FirmwareVersionLSB)  //!client side read address    
   
  
  
  * where the last line #define FirmwareVerReadAddr FirmwareVersionLSB  
  * gives FirmwareVerReadAddr   as the definitive programmers reference to index
  * that memory.
  * 
  * the various NumBytes fields are unaffected.
  * 
  * The upper table entries (128 onwards) have no such alias's, as they 
  * are writable, and infact trigger actions etc, completely different behaviour.
  * 
  *     !!!!!!!!!!!!!    End of  message. !!!!!!!!!!!!!! 
  * 
  * !!! anybody asking a question that implies they have not read this will be 
  * referred back in no uncertain terms.
  * 
 
  * 
  * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  */



//  READ ONLY Block 1
//Addresses and field sizes of low order (frequent) read only data

#define TransitTimeTicksAddr  0        // the raw measurement of ball speed, in  counter ticks
#define TransitTimeTicksNumBytes 4   
    
#define TransitTimeReadAddr  (TransitTimeTicksAddr)  //!! client side address alias
    
    
//Acceleromoter data addresses  
#define AccelerometerXYZ_RawAddr (TransitTimeTicksAddr + TransitTimeTicksNumBytes)
#define AccelerometerXYZ_RawNumBytes 6
       
#define Accl_X_LSB_Addr (AccelerometerXYZ_RawAddr)
#define Accl_X_MSB_Addr (Accl_X_LSB_Addr + 1)
#define Accl_Y_LSB_Addr ( Accl_X_MSB_Addr + 1)
#define Accl_Y_MSB_Addr (Accl_Y_LSB_Addr +1 )   
#define Accl_Z_LSB_Addr ( Accl_Y_MSB_Addr + 1)
#define Accl_Z_MSB_Addr (Accl_Z_LSB_Addr +1 ) 
    
#define AccelXYZReadAddr (Accl_X_LSB_Addr)           // !client side read address alias
  
    
//pitch and roll sub group
    
#define PitchAndRoll_Addr ( AccelerometerXYZ_RawAddr + AccelerometerXYZ_RawNumBytes)
#define PitchAndRollNumBytes 4   
#define PitchLSB_Addr (PitchAndRoll_Addr)
#define PitchMSB_Addr (PitchLSB_Addr + 1)
#define RollLSB_Addr ( PitchMSB_Addr + 1)
#define RollMSB_Addr (RollLSB_Addr +1 )
    
#define PitchRollReadAddr (PitchAndRoll_Addr)     // !client side read address alias 
    
    
//Battery pack info 
    
#define BatteryChargeState_Addr (PitchAndRoll_Addr + PitchAndRollNumBytes  )   //percentage charge left
#define BatteryChargeStateNumBytes 1
    
#define BattChargeStateReadAddr (BatteryChargeState_Addr)   // !client side read address alias 

    
#define BatteryPackVoltage_Addr (BatteryChargeState_Addr + BatteryChargeStateNumBytes )  //in mv, 0-65535
#define BatteryPackVoltageNumBytes 2
#define BattVoltReadAddr  (BatteryPackVoltage_Addr)   //!client side read address alias
 
    
   //Firmware version - copied at run time from firmware_version.h  on start up.
    // four bytes, in the from   MSB.LSB.Minor - rc   (where rc is release candidate. )
    // NOTE the '+' : this region runs UPWARDS, each block starting after the
    // previous one. Subtracting here put the four bytes on top of
    // BatteryChargeState and BatteryPackVoltage.
#define FirmwareVersionAddr (BatteryPackVoltage_Addr + BatteryPackVoltageNumBytes)
#define FirmwareVersionNumBytes 4

#define FirmwareVersionRcAddr FirmwareVersionAddr      // this is release candidate , and thus should be zero for anything that has been released.
#define FirmwareVersionMinorAddr ( FirmwareVersionRcAddr + 1 )
#define FirmwareVersionLSBAddr  ( FirmwareVersionMinorAddr + 1 )
#define FirmwareVersionMSBAddr (FirmwareVersionLSBAddr + 1 )
    
    
/*     thus each program in the suite should have
 * 
 * EMULATE_EEPROM_Memory[FirmwareVersionRcAddr] = FIRMWARE_RC
 * EMULATE_EEPROM_Memory[FirmwareVersionMinorAddr] = FIRMWARE_REV_MINOR 
 * EMULATE_EEPROM_Memory[FirmwareVersionLSBAddr] = FIRMWARE_REV_LSB
 * EMULATE_EEPROM_Memory[FirmwareVersionMSBAddr] = FIRMWARE_REV_MSB  
    
 * quite early on its start up path, somewhere before the i2c is initialiesd
 */
 

    
  
 //READ ONLY Block 2   
 // addresses and field sizes of High order read only parameters 
 // at some point, the high order parameters MAY get backed up into a non-vol area of the pic.
 // Note that this is in reverse order (counting down)from 127. This is to allow empty space between 
 // the low and high order tables, useable by a change in either.

//Table version
#define TableVersionAddr   127
#define TableVersionNumBytes 1   
    
#define TableVerReadAddr  (TableVersionAddr)  //  !client side read address alias
    

 //Spare/resereved  Reserved1   - can be reassigend      
#define Reserved1Addr (TableVersionAddr - TableVersionNumBytes)
#define Reserved1NumBytes 2
#define Reserved1MSB Reserved1Addr
#define Reserved1LSB  ( Reserved1MSB - 1 )
    
    


//Hardware Version
/* Anchored to Reserved1, NOT to the firmware version block.
 *
 * Reserved1 is what the old 2-byte firmware version became, so this keeps
 * HardwareVersion - and the whole descending chain below it: TicksPerSecond,
 * LaserState and everything after - exactly where it has always been.
 *
 * It used to read (FirmwareVersionAddr - FirmwareVersionNumBytes). That tied
 * the entire lower half of the table to wherever the firmware version block
 * happened to sit, so moving that block to the unused space near the battery
 * fields silently dragged LaserState from 118 to 7 and took everything below
 * it along. A provisioned unit's stored 256-byte block would then restore
 * every field into the wrong place. Nothing down here should move because the
 * version block moved. */
#define HardwareVersionAddr (Reserved1Addr - Reserved1NumBytes)
#define HardwareVersionNumBytes 2
    
#define HardwareVerReadAddr (HardwareVersionAddr)    //!client side read address alias


// 'ticks per second - conversion constant from timer to seconds    
#define TicksPerSecondAddr (HardwareVersionAddr - HardwareVersionNumBytes)  // the conversion factor to turn TransitTimeTicks into seconds 
#define TicksPerSecondNumBytes 4    
#define TicksPerSecMMSB  TicksPerSecondAddr
#define TicksPerSecNMSB  ( TicksPerSecMMSB - 1 )
#define TicksPerSecHLSB  ( TicksPerSecNMSB - 1 )
#define TicksPerSecLLSB  ( TicksPerSecHLSB - 1 )
    
#define TicksPerSecReadAddr (TicksPerSecondAddr)   //!client side read address alias


//Laser (and other lights    - a bit field for all the lighting - TODO: best document that here
#define LaserStateAddr (TicksPerSecondAddr - TicksPerSecondNumBytes)
#define LaserStateNumBytes 1



#define LaserStateReadAddr  (LaserStateAddr)     //!! client side read address alias
    
    
// IR output level - currently not implemented, but hard ware support pending. range 0-100    
#define IRLevelAddr (LaserStateAddr - LaserStateNumBytes)  
#define IRLevelNumBytes 1 

#define IRLevelReadAddr (IRLevelAddr)   //!! client side read address aliase
    
 //Accelerometer Cal co-efficients - these are the values that zero the readings
#define Accel_Cal_Addr (IRLevelAddr - IRLevelNumBytes)
#define Accel_Cal_NumBytes 6      
#define Accl_CalZ_MSB_Addr Accel_Cal_Addr
#define Accl_CalZ_LSB_Addr (Accl_CalZ_MSB_Addr - 1)
#define Accl_CalY_MSB_Addr ( Accl_CalZ_LSB_Addr - 1)
#define Accl_CalY_LSB_Addr (Accl_CalY_MSB_Addr -1 )   
#define Accl_CalX_MSB_Addr ( Accl_CalY_LSB_Addr - 1)
#define Accl_CalX_LSB_Addr (Accl_CalX_MSB_Addr -1 ) 
    
#define AcclCalReadAddr (Accl_CalX_LSB_Addr)   //! client side read addres alias
    
// Call Jetson code -- 16 bit bitfield, see  , seperate section "*CallJetson ... 
#define CallJetsonCode_Addr (Accel_Cal_Addr - Accel_Cal_NumBytes)
#define CallJetsonCode_NumBytes 2  
#define CallJetsonCode_MSB CallJetsonCode_Addr
#define CallJetsonCode_LSB ( CallJetsonCode_Addr  - 1 )  
    
#define CallJetsCodeReadAddr   (CallJetsonCode_LSB)     //! Client side read Address  alias 
    
#define PowerOffFlag  (CallJetsonCode_Addr -  CallJetsonCode_NumBytes )  // this may be used to trigger other things, but currently just launch a power off up the command chain
#define PowerOffFlag_NumBytes 1
   
/// *********  END of READ ONLY TABLES   *************************
// **                                                           **
// **   The following section does not have alias's
//****************************************************************
    
    

    
     //Addresses etc of writeable fields  BLOCK 3
//Starts at 128. These are intended as write only, but it is legal 
// for the client to read them if they really want, maybe for validation
// However, the primary function is to configure the unit, switch lighting, 
//etc.
    
#define ConfigLasersAddr 128
#define ConfigLasersNumBytes 1
    
#define SetIRLevelAddr ( ConfigLasersAddr + ConfigLasersNumBytes )
#define SetIRLevelNumBytes 1
    
#define SetTicksPerSecond ( SetIRLevelAddr + SetIRLevelNumBytes )
#define SetTicksPerSecondNumBytes 4
    
#define SetModeChange ( SetTicksPerSecond + SetTicksPerSecondNumBytes )
#define SetModeChangeNumBytes 1   
    
#define ConfigAccelerometerAddr (SetModeChange + SetModeChangeNumBytes)
#define ConfigAccelerometerNumBytes 18
    
#define GeneralPurposeJobBufferAddr (ConfigAccelerometerAddr + ConfigAccelerometerNumBytes)
#define GeneralPurposeJobBufferNumBytes 16
    
#define ResetSubsysAddr (GeneralPurposeJobBufferAddr + GeneralPurposeJobBufferNumBytes)
#define ResetSubsysNumBytes 1
    
#define ResetSubsysConfirmAddr ( ResetSubsysAddr + ResetSubsysNumBytes)
#define ResetSubsysConfirmNumBytes 1
   //General purpose calling code - Set this, then use the ResetSybSys//ConfirmResetSubsys pattern to activate
    // These are locked as they have forced reset, power cycles, etc.
#define JetsonCallingCode_Addr ( ResetSubsysConfirmAddr + ResetSubsysNumBytes)
#define JetsonCallingCodeNumBytes  1
    
//    
//Jetson sets  this to advise that it has read the call code and is doing something about it 
//Sub system clears it and may then pull new code onto stack if one waiting.
// This MAY be also used as a back channel TBD
#define JetsonAcknowledgeCall_Addr ( JetsonCallingCode_Addr + JetsonCallingCodeNumBytes )   
#define JetsonAcknowledgeNumBytes 1
 
    
  
    
   
 // Other labels- not memory addresses....
 // but are specific values that may be posted 
 
    
 //******************************   
 // "CallJetson" codes below:    
// 'codes' for when the Subsystem calls the jetson
// when 'call jetson' is asserted by the subsystem,
// there will be a value posted  in location "CallJetsonCode_Addr"
// which the jetson reads and acts upon

#define PowerOff_1_min  0x0001  // The power to the jetson is going to be removed in 1 minute, so shutdown please. 
#define LowBatteryWarning 0x0002 // The battery voltage or charge is low,(may also include temperature) the jetson may want to raise a gui alet to the user.
#define LowBatteryCritical 0x0004   // charge or other critical battery pack issue , jetson to warn user as forced shut down 1 min. Jetson MAY chose to read regs and try and figure out why?
#define BatteryPackCommsFailure 0x0008 // appears to be a block on the i2c bus to the battery pack. Continue at your own peril
#define BallStrike 0x0010 // accelerometer indicates the gate has been knocked, or a ball strike , or some other impact event that has had minimal effect on orientation
#define GateMoving 0x0020 // The gate appears to have been picked up. Lasers are off, will remain so until correct orientation for a few second
#define GateInvalidOrientation 0x0040 // The gate has a tilt greater that TBD X degrees
#define Spare2 0x0080 // 
#define Spare3 0x0100 
#define Spare4 0x0200 // 
#define Spare5 0x0400
#define Spare6 0x0800
#define Spare7 0x1000 // 
#define Spare8 0x2000 
#define Spare9 0x4000 // 
#define Spare10 0x8000

                               
    
//Codes when the Jetson is calling the subsys -- 
#define Nothing  0   // jetson must have pocket dialled, nothing to do         
#define JetsonIsShuttingDown 1   // jetson is shutting from gui or other cause, Subsytem to power down in 1 minute please
#define InitReset   0x56
#define InitPowerOff 0x23
#define ConfirmReset_PowerOff  0x2F

 
 
    
    
//other defines for internal use only - not needed by any external code
    
#define ImmediatePowerOff 0x67   // used in a specific read,ie  EMULATE_EEPROM_Memory[PowerOffFlag]=ImmediatePowerOff will pass a power off command up the chain
#define InitResetCheck   0x41        // internally sets a location to this to validate reset request
#define InitPowerOffCheck  0x42     // internally sets a location to this to validate power off request
// Bit within LaserState that is NOT a lamp: it latches "the lights have already
// been switched off because the gate is out of level", so the orientation check
// does that work once instead of on every pass. It is also a LOCKOUT: while it
// is set LampsApply() forces every lamp off, so nothing - not even a Jetson
// write to ConfigLasersAddr - can light them until the gate is level again.
#define LaserState_OrientFault 0x40

// The lamp bits themselves, within LaserState: 0 front laser, 1 rear laser,
// 2 beam. LampsApply() writes ONLY these, so the flags above survive. They
// report what is ACTUALLY lit; ConfigLasersAddr holds what was REQUESTED.
#define LaserState_LampsMask 0x07

// Latches "the lamps were switched off" - by a tilt, or a power-down.
#define LaserState_LampsOff 0x80
    
   

#ifdef	__cplusplus
}
#endif

#endif	/* EEPROMBLOCKLABELS_H */

