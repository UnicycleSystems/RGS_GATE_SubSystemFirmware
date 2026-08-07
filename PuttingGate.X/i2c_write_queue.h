/**
 just a bog standard ring buffer. 
 *in this code, it is pushed to when the 
 emulated eeprom is written to via i2c1
 main body then checks it and processes as appropriate
 * 
*/

#ifndef I2C_WRITE_QUEUE_H
#define I2C_WRITE_QUEUE_H

#include <stdint.h>
#include <stdbool.h>

typedef struct
{
    uint16_t start_address;
    uint8_t  num_bytes;
} I2C_WriteJob_t;

/**
  @Summary
    Resets the queue to empty. Call once at startup before interrupts
    are enabled.
*/
void I2C_WriteQueue_Init(void);

/**
  @Summary
    Pushes a completed write job onto the queue. Intended to be called
    from the I2C1 ISR only.

  @Return
    true if the job was queued, false if the queue was full (job dropped).
*/
bool I2C_WriteQueue_Push(uint8_t start_address, uint8_t num_bytes);

/**
  @Summary
    Pops the oldest write job off the queue. Intended to be called from
    main-loop (non-ISR) context only.

  @Return
    true if a job was popped into *job, false if the queue was empty.
*/
bool I2C_WriteQueue_Pop(I2C_WriteJob_t *job);

/**
  @Summary
    Returns true if there is at least one job available to pop.
*/
bool I2C_WriteQueue_IsEmpty(void);

#endif // I2C_WRITE_QUEUE_H
