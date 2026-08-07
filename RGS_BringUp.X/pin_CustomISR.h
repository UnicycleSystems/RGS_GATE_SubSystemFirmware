/* 
 * File:   pin_CustomISR.h
 * Author: peterbrewster
 *
 * Created on 01 July 2025, 16:50
 * 
 * These are the custom ISR handlers, that we can set  from elsewhere,
 * and protect from the auto generated mayhem
 * 
 */

#ifndef PIN_CUSTOMISR_H
#define	PIN_CUSTOMISR_H

#ifdef	__cplusplus
extern "C" {
#endif
    
#define FrontSensorOn CNEN1bits.CN2IE=1
#define FrontSensorOff CNEN1bits.CN2IE=0
    
#define RearSensorOn CNEN1bits.CN3IE=1
#define RearSensorOff CNEN1bits.CN3IE=0 
    
#define WakeUpOn CNEN2bits.CN16IE = 1;
#define WakeUpOff CNEN2bits.CN16IE = 0;
    
    
  
void (ISR_CN_Dummy)(void);   
void (ISR_CN_FrontSensor)(void);
void (ISR_CN_RearSensor)(void);
void (ISR_CN_WakeUp)(void);
//??  




#ifdef	__cplusplus
}
#endif

#endif	/* PIN_CUSTOMISR_H */

