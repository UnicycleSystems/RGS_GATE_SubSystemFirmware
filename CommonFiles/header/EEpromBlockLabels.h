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
#define   TableVersion 255   // was 1, due an up issue testing
    


//  READ ONLY Block 1
//Addresses and field sizes of low order (frequent) read only data

#define TransitTimeTicksAddr  0        // the raw measurement of ball speed, in  counter ticks
#define TransitTimeTicksNumBytes 4
 
    
    
//Acceleromoter data addresses  
#define AccelerometerXYZ_RawAddr (TransitTimeTicksAddr + TransitTimeTicksNumBytes)
#define AccelerometerXYZ_RawNumBytes 6
       
#define Accl_X_LSB_Addr AccelerometerXYZ_RawAddr
#define Accl_X_MSB_Addr (Accl_X_LSB_Addr + 1)
#define Accl_Y_LSB_Addr ( Accl_X_MSB_Addr + 1)
#define Accl_Y_MSB_Addr (Accl_Y_LSB_Addr +1 )   
#define Accl_Z_LSB_Addr ( Accl_Y_MSB_Addr + 1)
#define Accl_Z_MSB_Addr (Accl_Z_LSB_Addr +1 )    
    
#define PitchAndRoll_Addr ( AccelerometerXYZ_RawAddr + AccelerometerXYZ_RawNumBytes)
#define PitchAndRollNumBytes 4
    
#define PitchLSB_Addr PitchAndRoll_Addr
#define PitchMSB_Addr (PitchLSB_Addr + 1)
#define RollLSB_Addr ( PitchMSB_Addr + 1)
#define RollMSB_Addr (RollLSB_Addr +1 )
    
//Battery pack info 
    
#define BatteryChargeState_Addr (PitchAndRoll_Addr + PitchAndRollNumBytes  )   //percentage charge left
#define BatteryChargeStateNumBytes 1
    
#define BatteryPackVoltage_Addr (BatteryChargeState_Addr + BatteryChargeStateNumBytes )  //in mv, 0-65535
#define BatteryPackVoltageNumBytes 2
    
    

    
    
    

    
    
    

 //READ ONLY Block 2   
 // addresses and field sizes of High order read only parameters 
 // at some point, the high order parameters MAY get backed up into a non-vol area of the pic.
 // Note that this is in reverse order (counting down)from 127. This is to allow empty space between 
 // the low and high order tables, useable by a change in either.
#define TableVersionAddr   127
#define TableVersionNumBytes 1   
    

       
#define FirmwareVersionAddr (TableVersionAddr - TableVersionNumBytes)
#define FirmwareVersionNumBytes 2
#define FirmwareVersionMSB FirmwareVersionAddr
#define FirmwareVersionLSB  ( FirmwareVersionMSB - 1 )

#define HardwareVersionAddr (FirmwareVersionAddr - FirmwareVersionNumBytes)
#define HardwareVersionNumBytes 2
    
#define TicksPerSecondAddr (HardwareVersionAddr - HardwareVersionNumBytes)  // the conversion factor to turn TransitTimeTicks into seconds 
#define TicksPerSecondNumBytes 4
    
 #define TicksPerSecMMSB  TicksPerSecondAddr
 #define TicksPerSecNMSB  ( TicksPerSecMMSB - 1 )
#define TicksPerSecHLSB  ( TicksPerSecNMSB - 1 )
#define TicksPerSecLLSB  ( TicksPerSecHLSB - 1 )
    
#define LaserStateAddr (TicksPerSecondAddr - TicksPerSecondNumBytes)  // the conversion factor to turn TransitTimeTicks into seconds 
#define LaserStateNumBytes 1   
    
#define IRLevelAddr (LaserStateAddr - LaserStateNumBytes)  
#define IRLevelNumBytes 1 
 
    
 //Accelerometer Cal co-efficients
#define Accel_Cal_Addr (IRLevelAddr - IRLevelNumBytes)
#define Accel_Cal_NumBytes 6
       
#define Accl_CalZ_MSB_Addr Accel_Cal_Addr
#define Accl_CalZ_LSB_Addr (Accl_CalZ_MSB_Addr - 1)
#define Accl_CalY_MSB_Addr ( Accl_CalZ_LSB_Addr - 1)
#define Accl_CalY_LSB_Addr (Accl_CalY_MSB_Addr -1 )   
#define Accl_CalX_MSB_Addr ( Accl_CalY_LSB_Addr - 1)
#define Accl_CalX_LSB_Addr (Accl_CalX_MSB_Addr -1 )  
    
// Call Jetson code -- a range from 1-255 , (0 means nope, didn't call)
#define CallJetsonCode_Addr (Accel_Cal_Addr - Accel_Cal_NumBytes)
#define CallJetsonCode_NumBytes 1  
    
    
    

    
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
 
//    
//Jetson sets this to advise that it has read the call code and is doing something about it 
//Sub system clears it and may then pull new code onto stack if one waiting.
// This MAY be also used as a back channel TBD
#define JetsonAcknowledgeCall_Addr ( ResetSubsysConfirmAddr + ResetSubsysConfirmNumBytes )   
#define JetsonAcknowledgeNumBytes 1
 
    
   //General purpose calling code - Set this, then use the ResetSybSys//ConfirmResetSubsys pattern to activate
    // These are locked as they have forced reset, power cycles, etc.
#define JetsonCallingCode_Addr ( JetsonAcknowledgeCall_Addr + JetsonAcknowledgeNumBytes )
#define JetsonCallingCodeNumBytes = 1
    
    
    
    

    

    
    

 // Other labels- not memory addresses....
 // but are specific values that may be posted 
 
    
// 'codes' for when the Subsystem calls the jetson
// when 'call jetson' is asserted by the subsystem,
// there will be a value posted  in location "CallJetsonCode_Addr"
// which the jetson reads and acts upon

#define NoAlarmsAndNoSurprises   0 // default value, Nothing to see here.
#define PowerOff_1_min  1  // The power to the jetson is going to be removed in 1 minute, so shutdown please
#define LowBatteryVoltage 2 // The battery voltage is low, the jetson may want to raise a gui alet to the user.
#define LowCharge 3   // General warning, not critical, gui alert to user
#define CriticalCharge 4 // warning to user, may shut down soon 
#define BallStrike 5 // accelerometer indicates the gate has been knocked, or a ball strike , or some other impact event that has had minimal effect on orientation
#define GateMoving 6 // The gate appears to have been picked up. Lasers are off, will remain so until correct orientation for a few second
#define GateInvalidOrientation 7 // The gate has a tilt greater that TBD X degrees
#define GateOrienationRestored 8 // Should only occur when an invalid orientation occured, and is now rectified 

                               
    

    
    
    

                         

    

    
  
   


#ifdef	__cplusplus
}
#endif

#endif	/* EEPROMBLOCKLABELS_H */

