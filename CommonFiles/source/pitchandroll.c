#include "../header/pitchandroll.h"
#include <math.h>
#include <stdint.h>

#define ANGLE_FULL_SCALE_DEG   180.0f
#define ANGLE_RESOLUTION_BITS  14
#define ANGLE_SCALE_FACTOR     (8192.0f / ANGLE_FULL_SCALE_DEG)  // counts per degree


// pretty much a maths cookbook approach. 
// plenty of scope to optimise this - cordics, maybe,or look at Crenshaw, chapters 4 and 6

void ComputePitchRoll(int16_t x_raw, int16_t y_raw, int16_t z_raw,
                       int16_t *pitch_out, int16_t *roll_out)
{
    float x = (float)x_raw;
    float y = (float)y_raw;
    float z = (float)z_raw;

    float roll_deg  = atan2f(y, z) * (180.0f / (float)M_PI);
    float pitch_deg = atan2f(-x, sqrtf(y * y + z * z)) * (180.0f / (float)M_PI);

    int32_t roll_raw  = (int32_t)lroundf(roll_deg  * ANGLE_SCALE_FACTOR);
    int32_t pitch_raw = (int32_t)lroundf(pitch_deg * ANGLE_SCALE_FACTOR);

    // Clip defensively in case of rounding right at �180
    if (roll_raw  >  8191) roll_raw  =  8191;
    if (roll_raw  < -8192) roll_raw  = -8192;
    if (pitch_raw >  8191) pitch_raw =  8191;
    if (pitch_raw < -8192) pitch_raw = -8192;

    *pitch_out = (int16_t)pitch_raw;
    *roll_out  = (int16_t)roll_raw;
}


