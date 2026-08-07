/* 
 * File:   RTOS_SmallJobs.h
 * Author: peterbrewster
 *
 * Created on July 14, 2025, 2:37 PM
 */

#ifndef RTOS_SMALLJOBS_H
#define	RTOS_SMALLJOBS_H

#ifdef	__cplusplus
extern "C" {
#endif

//********* Single Byte Job functions **********
/* These are all 'single call' functions that 
 can be done quickly, so not complex queues

 */
/*****************************
***** Code Section contanining all the 'small' or
 *     'single byte' jobs.  TODO: consider moving to own header file                      *
 */
  
signed char SetFrontAlignmentLaser(unsigned char data)
{
    uint16_t priVal;
    priVal=data<<=8;
    
    OC1_PrimaryValueSet(priVal );
    OC1_SecondaryValueSet(priVal);
    
    if(!data)
    {
        OC1_Stop();
    }
    else
    {
        OC1_Start();
    }
    return(0);
    
}

signed char SetRearAlignmentLaser(unsigned char data)
{
    uint16_t priVal;
    priVal=data<<=8;
    
    OC2_PrimaryValueSet(priVal );
    OC2_SecondaryValueSet(priVal);
    
    if(!data)
    {
        OC2_Stop();
    }
    else
    {
        OC2_Start();
    }
    retur(0);
    
}

signed char SetDownLaser(unsigned char data)
{
    //do code for i2c master to turn on or off 
    //I02 on u7
    return(0);
    
}

signed char FrontBeamLaserOnOff(unsigned char data)
{ 
    //do code for i2c master to turn on or off 
    //I00 on u7
    return(0);  
}

signed char RearBeamLaserOnOff(unsigned char data)
{
   //do code for i2c master to turn on or off 
    //I01 on u7
    return(0);   
}

signed char SetRedLed(unsigned char data)
{
    //Set or clear RB9
    if(data)
    {
        RED_LED_ON_SetHigh();
    }
    else
    {
        RED_LED_ON_SetLow();
    }
    return(0);
    
}signed char SetGreenLed(unsigned char data)
{
    uint16_t priVal;
    priVal=data<<=8;
    
    OC5_PrimaryValueSet(priVal );
    OC5_SecondaryValueSet(priVal);
    
    if(!data)
    {
        OC5_Stop();
    }
    else
    {
        OC5_Start();
    }
    retur(0);
    
    
}

signed char SetBlueLed(unsigned char data)
{
    uint16_t priVal;
    priVal=data<<=8;
    
    OC4_PrimaryValueSet(priVal );
    OC4_SecondaryValueSet(priVal);
    
    if(!data)
    {
        OC5_Stop();
    }
    else
    {
        OC5_Start();
    }
    retur(0);
     
}

/*****************************
***** END Code Section contanining all the 'small' or
 *     'single byte' jobs.                        *
 */
  


    


#ifdef	__cplusplus
}
#endif

#endif	/* RTOS_SMALLJOBS_H */

