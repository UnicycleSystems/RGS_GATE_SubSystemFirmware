/* 
 * File:   RTOSJobs.h
 * Author: peterbrewster
 *
 * Created on 02 July 2025, 10:32
 */

#ifndef RTOSJOBS_H
#define	RTOSJOBS_H

#ifdef	__cplusplus
extern "C" {
#endif


   
    
signed char DoSingleByteJob (unsigned int address,unsigned char data);
signed char DoMultiByteJob (unsigned int address,unsigned char *data,unsigned char numdata); 

unsigned char BallDetectedJob(void);



#ifdef	__cplusplus
}
#endif

#endif	/* RTOSJOBS_H */

