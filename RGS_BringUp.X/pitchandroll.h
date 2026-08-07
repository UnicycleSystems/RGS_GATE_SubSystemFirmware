/* 
 * File:   pitchandroll.h
 * Author: peterbrewster
 *
 * Created on 21 July 2026, 16:33
 */

#ifndef PITCHANDROLL_H
#define	PITCHANDROLL_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <stdint.h>
void ComputePitchRoll(int16_t x_raw, int16_t y_raw, int16_t z_raw,
                       int16_t *pitch_out, int16_t *roll_out);


#ifdef	__cplusplus
}
#endif

#endif	/* PITCHANDROLL_H */

