/*
 * File:   i2c2_helpers.c
 *
 * See i2c2_helpers.h. Moved verbatim from the identical copies that lived in
 * PuttingGate.X/main.c and RGS_BringUp.X/main.c.
 */

#include "../header/i2c2_helpers.h"

/* FCY must be defined before libpic30.h for __delay_ms(). Both main.c files
 * set it to 16 MHz; kept in step here so this file builds standalone. */
#ifndef FCY
#define FCY 16000000UL
#endif
#include <libpic30.h>
#include <xc.h>


bool i2c2_wait_done(volatile I2C2_MESSAGE_STATUS *st, uint16_t timeout_ms)
{
    while (*st == I2C2_MESSAGE_PENDING) {
        __delay_ms(1);
        ClrWdt();
        if (timeout_ms-- == 0) return false;   // timeout
    }
    return true;
}

bool i2c2_write_u8(uint8_t dev7, uint8_t reg, uint8_t val)
{
    volatile I2C2_MESSAGE_STATUS st = I2C2_MESSAGE_PENDING;
    uint8_t w[2] = { reg, val };
    I2C2_MasterWrite(w, 2, dev7, (I2C2_MESSAGE_STATUS*)&st);
    return i2c2_wait_done(&st, 50) && (st == I2C2_MESSAGE_COMPLETE);
}

bool i2c2_read_regs(uint8_t dev7, uint8_t start_reg, uint8_t *dst, uint8_t n)
{
    volatile I2C2_MESSAGE_STATUS st = I2C2_MESSAGE_PENDING;
    I2C2_TRANSACTION_REQUEST_BLOCK trb[2];

    I2C2_MasterWriteTRBBuild(&trb[0], &start_reg, 1, dev7);
    I2C2_MasterReadTRBBuild (&trb[1], dst,        n, dev7);
    I2C2_MasterTRBInsert(2, trb, (I2C2_MESSAGE_STATUS*)&st);

    if (i2c2_wait_done(&st, 50) && st == I2C2_MESSAGE_COMPLETE)
        return true;

    // Fallback: STOP between write(reg) and read(n)
    st = I2C2_MESSAGE_PENDING;
    I2C2_MasterWrite(&start_reg, 1, dev7, (I2C2_MESSAGE_STATUS*)&st);
    if (!i2c2_wait_done(&st, 50) || st != I2C2_MESSAGE_COMPLETE) return false;

    st = I2C2_MESSAGE_PENDING;
    I2C2_MasterRead(dst, n, dev7, (I2C2_MESSAGE_STATUS*)&st);
    return i2c2_wait_done(&st, 50) && (st == I2C2_MESSAGE_COMPLETE);
}

bool i2c2_read_u8(uint8_t dev7, uint8_t reg, uint8_t *val)
{
    return i2c2_read_regs(dev7, reg, val, 1);
}

/* Bounded spin on a self-clearing I2C2CON bit (SEN, RCEN, ACKEN, PEN).
 * Returns false if it never clears - a line held so hard that the peripheral
 * cannot finish the step - so a stuck bus can never hang the caller. */
static bool i2c2_wait_con_clear(uint16_t mask)
{
    uint16_t t;

    for (t = 0; (I2C2CON & mask) != 0; t++)
    {
        if (t >= 2000)              /* ~20 ms at 10 us/spin */
            return false;
        __delay32(FCY / 100000ul);  /* 10 us */
        ClrWdt();
    }
    return true;
}

/* Free a bus that a device is holding, and reset the driver.
 *
 * Every I2C2 device is powered from downstream of the pack FETs, which stay
 * latched on through a PIC reset. A plain I2C device caught mid-byte by the
 * reset is never power-cycled, so it can go on holding SDA low indefinitely -
 * across restarts - until something clocks it through the rest of its byte.
 * (The SMBus gauge gives up by itself after 25-35 ms; plain I2C parts don't.)
 *
 * Same sequence as BQ40Z50_BusUnwedge() in bq40z50.c, which BringUp uses:
 * START, then up to nine dummy byte reads each NACKed, then STOP. RCEN is only
 * actioned inside a transaction, which is why the START has to come first.
 * Every step is best-effort and bounded; what matters is the clocks that do
 * get out, not a tidy transaction.
 *
 * The MCC driver's interrupt is held off while the peripheral is driven by
 * hand, so its state machine cannot act on the events these steps raise.
 * I2C2_Initialize() at each end empties the driver's queue - dropping any
 * transfer a timeout abandoned - and returns its state machine to idle; the
 * second call also turns the interrupt back on with its flag cleared.
 *
 * Reports nothing: only a real transfer to a real device shows the bus is
 * usable, so the caller's next read is the test. */
void i2c2_bus_unwedge(void)
{
    uint8_t i;

    I2C2_Initialize();
    IEC3bits.MI2C2IE = 0;                       /* driver hands off */
    __delay_ms(5);
    ClrWdt();

    I2C2CONbits.SEN = 1;
    (void)i2c2_wait_con_clear(1u << 0);         /* SEN */

    for (i = 0; i < 9; i++)
    {
        I2C2CONbits.RCEN = 1;                   /* 8 clocks */
        if (!i2c2_wait_con_clear(1u << 3))      /* RCEN */
            break;
        (void)I2C2RCV;                          /* discard */

        I2C2CONbits.ACKDT = 1;                  /* NACK */
        I2C2CONbits.ACKEN = 1;
        if (!i2c2_wait_con_clear(1u << 4))      /* ACKEN */
            break;
    }

    I2C2CONbits.PEN = 1;                        /* STOP -> bus idle */
    (void)i2c2_wait_con_clear(1u << 2);         /* PEN */

    I2C2_Initialize();                          /* flag cleared, interrupt back on */
    __delay_ms(5);
    ClrWdt();
}
