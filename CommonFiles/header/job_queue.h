/**
  Job Queue

  @Summary
    Fixed-size circular buffer of job indices.

  @Description
    Single-producer / single-consumer ring buffer, same shape as
    i2c_write_queue. The producer pushes a job index (e.g. an
    AddressBlock_Lookup() result); the consumer pops it and uses it to
    dispatch a handler, typically via a function-pointer table indexed
    by that same value.
*/

#ifndef JOB_QUEUE_H
#define JOB_QUEUE_H

#include <stdint.h>
#include <stdbool.h>

/**
  @Summary
    Resets the queue to empty. Call once at startup before interrupts
    are enabled.
*/
void JobQueue_Init(void);

/**
  @Summary
    Pushes a job index onto the queue.

  @Return
    true if the job was queued, false if the queue was full (job dropped).
*/
bool JobQueue_Push(uint8_t job_index);

/**
  @Summary
    Pops the oldest job index off the queue.

  @Return
    true if a job was popped into *job_index_out, false if the queue
    was empty.
*/
bool JobQueue_Pop(void);

/**
  @Summary
    Returns true if there is at least one job available to pop.
*/
bool JobQueue_IsEmpty(void);

/**
  @Summary
    The ONE place the lamp pins are driven: front laser, rear laser and beam.

  @Description
    Takes the lamp bits (LaserState_LampsMask - 0 front, 1 rear, 2 beam) and
    drives all three pins, which are active LOW because of the dual transistor
    drivers. It then records what it did in bits 0-2 of LaserState, through a
    mask, so the flag bits in that byte survive.

    While LaserState_OrientFault is set the gate is out of level and the lamps
    are LOCKED OUT: whatever is asked for, zero is applied. That makes the
    lockout impossible to bypass by accident - every caller, including
    SetLasers() on behalf of the Jetson, goes through here - and it still allows
    lamps to be switched OFF while locked out, which a power-down needs.

    Anything that lights lamps after the lockout lifts must therefore clear
    LaserState_OrientFault FIRST, or it will be refused.
*/
void LampsApply(uint8_t lamps);

/**
  @Summary
    Abandons a two-stage self-reset request that was armed but never confirmed.

  @Description
    Clears both request bytes and SelfResetTimeout, and puts the bi-colour LED
    back to green. Handler in job_queue.c, alongside InitSelfReset() and
    ConfirmSelfReset(); declared here because the one-second tick in each
    application's main loop calls it when the 10 s window lapses. Without this
    declaration those calls were implicit (XC16 assumed "int CancelReset()"),
    which worked only by luck of the calling convention.
*/
void CancelReset(void);

#endif // JOB_QUEUE_H
