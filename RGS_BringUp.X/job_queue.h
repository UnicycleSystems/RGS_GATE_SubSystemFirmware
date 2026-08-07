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

#endif // JOB_QUEUE_H
