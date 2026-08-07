#include "i2c_write_queue.h"
#include "Events.h"
#include "address_block_lookup.h"

//TODO: REFACTOR it might be nice to set a  flag that main can see
//      rather than have to call to check
//      
#define I2C_WRITE_QUEUE_SIZE 8   // must be a power of 2

static volatile I2C_WriteJob_t queue[I2C_WRITE_QUEUE_SIZE];
static volatile uint8_t head = 0;   // next write index (producer/ISR owns)
static volatile uint8_t tail = 0;   // next read index (consumer/main owns)

void I2C_WriteQueue_Init(void)
{
    head = 0;
    tail = 0;
}

bool I2C_WriteQueue_Push(uint8_t start_address, uint8_t num_bytes)
{
    uint8_t next_head = (uint8_t)((head + 1) & (I2C_WRITE_QUEUE_SIZE - 1));
    uint8_t index;
    
    if (next_head == tail)
    {
        // queue full, drop the job, possibly add an alert to jetson
        
        EventJob.i2cQueJobWaiting=0;
        return false;
    }
 //Validate address and num bytes
   //TODO:    
//put in some validation - ie is a valide start address, and num bytes is correct
    if(!AddressBlock_Lookup(start_address,num_bytes,&index))
    { 
        // add an alert to jetson
         return false;
    }
       
    
    queue[head].start_address = index;
    queue[head].num_bytes     = num_bytes;
    head = next_head;
    EventJob.i2cQueJobWaiting=1;
    return true;
}

bool I2C_WriteQueue_Pop(I2C_WriteJob_t *job)
{
    if (tail == head)
    {
        // queue empty
        EventJob.i2cQueJobWaiting=0;
        return false;
    }

    job->start_address = queue[tail].start_address;
    job->num_bytes      = queue[tail].num_bytes;
    tail = (uint8_t)((tail + 1) & (I2C_WRITE_QUEUE_SIZE - 1));
    if(tail==head)
        EventJob.i2cQueJobWaiting=0;
    return true;
}

bool I2C_WriteQueue_IsEmpty(void)
{
    return (tail == head);
}
