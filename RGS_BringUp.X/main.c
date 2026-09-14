
//#pragma config FWDTEN = OFF      // Watchdog Timer Enable (WDT disabled in hardware)
//#pragma config WINDIS = ON       // Windowed WDT disabled (optional)

#include "../CommonFiles/header/Events.h"
#include "../CommonFiles/header/pin_CustomISR.h"

#include "../CommonFiles/header/system.h"
#include "../CommonFiles/header/clock.h"
#include "../CommonFiles/header/interrupt_manager.h"
#include "../CommonFiles/header/i2c2.h"
#include "../CommonFiles/header/i2c1.h"
#include "../CommonFiles/header/tmr4.h"
#include "../CommonFiles/header/tmr2.h"
#include "../CommonFiles/header/pin_manager.h"
#include "../CommonFiles/header/uart1.h"
#include "../CommonFiles/header/lis2dw12.h"
#include "../CommonFiles/header/i2c2_helpers.h"
#include "../CommonFiles/header/lis2dw12_i2c2.h"
#include "../CommonFiles/header/bq40z50.h"

#include <stdbool.h>
#include <stdint.h>
#include "../CommonFiles/header/i2c_write_queue.h"
#include "../CommonFiles/header/address_block_lookup.h"
#include "../CommonFiles/header/job_queue.h"
#include <xc.h>

#define FCY 16000000UL  // or whatever your instruction clock is
#include <libpic30.h>
#include "../CommonFiles/header/pitchandroll.h"
#include "../CommonFiles/header/persist_store.h"
#include "firmware_version.h"
#include "../CommonFiles/header/EEpromBlockLabels.h"
#include "InitEEpromVals.h"
#include "../CommonFiles/header/ArrayUtils.h"


//accelerometer specific stuff....
// to be removed if we ever implement a proper .c/.h set up

//commented out here, copied to top, but preserved for moving to header file
/* ---- LIS2DW12 / LIS2DW1TR basics ---- */



#define ButtonDelay 5    // The number of cycles of the button hold to return 'true)
                         // NOT debounce, this is the long (ish)user press and hold

#define On 1
#define Off 0

//round robin possible tasks
void GetBattVolts(void);
void GetAccel(void);
void DummyTask(void);


////////////////////////////////////////////////




//end accelerometer specific defines

// accelerometer prototypes
//void LIS2DW12_SetAddress_I2C2(uint8_t addr);
void QuickAcellerometerGrabber(void);

//end accelerometer prototypes

void CallJetsonBall(void);
void CallJetsonJob(void);

void ReadOneByteExample(void);
bool lis2dw12_read_register(uint8_t reg, uint8_t *value);
//bool LIS2DW12_Configure(void);
void ShutdownProcessTemp(void);
void PowerDown(void);

void POST_Routine(void);
void LaunchTest(void);
uint8_t PowerButton (bool OnOff);

// PWM on RB11 via OC3/T3
#define PWM_RB11_PERIOD   159   // PR3 value: 100kHz at FCY=16MHz (16000000/100000 - 1)
void PWM_RB11_Init(void);
void PWM_RB11_Enable(void);
void PWM_RB11_Disable(void);
void PWM_RB11_SetDuty(uint8_t duty);


void WDT_SafeDelay10thSecs (uint8_t seconds_10th);

 uint8_t testval;
 
// power management
uint32_t SwitchState;
uint32_t ButtonCount;
bool PowerOff;
bool queuepanic;


I2C_WriteJob_t LoadJobFromEEprom;
uint8_t JobIndex;

// these are the calibration constants.
//note that an int16 is very generous, but choosing to keep them in same type as raw vals.
 int16_t xcal;
 int16_t ycal;
 int16_t zcal;
 
 

/* Minimal UART1 string writer. UART1_Write() spins on a full TX buffer with
 * no ClrWdt(), which would be a reset loop in the bootloadable build, so wait
 * for room here instead - bounded, and give up rather than hang. */
/* Wait for two-speed start-up to hand over to the crystal.
 *
 * IESO = ON means the device begins executing on the FRC, and with
 * CLKDIV RCDIV = FRC/2 that is FCY ~2 MHz instead of 16 MHz - everything
 * derived from FCY is 8x wrong until the 32 MHz crystal is stable, including
 * U1BRG (115200 becomes ~14.3 kbaud, which is why the greeting used to arrive
 * as a handful of garbage characters). CLOCK_Initialize() sets NOSC = PRI but
 * never waits for the switch, so do it here.
 *
 * OSCCON COSC reads 0b010 once the primary oscillator is the active source.
 * Bounded, so a dead crystal degrades to "runs slowly" rather than hanging. */
static void wait_for_primary_clock(void)
{
    uint16_t t;

    for (t = 0; OSCCONbits.COSC != 0b010; t++)
    {
        if (t >= 20000)             /* generous: crystal start-up is ~1-10 ms */
            return;
        Nop();
        ClrWdt();
    }
}


static void uart_puts(const char *s)
{
    while (*s)
    {
        uint16_t guard = 0;
        while (!UART1_IsTxReady())
        {
            if (++guard >= 10000)       /* ~100 ms at 10 us/spin */
                return;
            __delay32(FCY / 100000ul);  /* 10 us */
            ClrWdt();
        }
        UART1_Write((uint8_t)*s++);
    }
}


/* ---- Jetson command interface on UART1 ---------------------------------
 * Wire-compatible with the bootloader's command protocol, so the host side is
 * identical whether the bootloader or this jig is running. The bootloader
 * uses raw packed structs with no framing:
 *
 *   command  (host -> board), 11 bytes:
 *       uint8_t  cmd
 *       uint16_t dataLength
 *       uint32_t unlockSequence
 *       uint32_t address
 *   response (board -> host), 12 bytes: the same 11 fields plus a status byte
 *
 * RESET_DEVICE is 0x09, and the bootloader answers it with a FIXED response
 * (cmd 9, all other fields zero, status 0x01) rather than echoing what it
 * received - so this does the same. Reset is the only command implemented;
 * others are simply ignored, which keeps stray terminal traffic harmless.
 */
#define JIG_CMD_RESET_DEVICE  0x09
#define JIG_CMD_LENGTH        11      /* == sizeof(struct CMD_STRUCT_0) */
#define JIG_CMD_SUCCESS       0x01

/* Handover marker printed when bring-up has finished and the jig is parked.
 * rgs_bootload_BringUp.py watches the serial line for this EXACT text: seeing
 * it, the host detaches its monitor and offers to flash a new image. Change
 * this and you must change JIG_PROMPT_LOAD in that script to match. */
#define JIG_PROMPT_LOAD  "Hit Enter to load new image"

static uint8_t jigCmdLen = 0;

/* ---- Operator input over UART1 -----------------------------------------
 * Bytes that are not part of a reset command are treated as the operator
 * pressing a key at the far end of the serial link, and are handed to
 * uart_wait_key(). Written by the RX interrupt, read by the main line, so
 * both are volatile.
 *
 * Only ONE byte is kept: this is for "hit a key to carry on", not a command
 * line, so a fast typist simply loses the extra characters rather than
 * needing a buffer. */
static volatile bool    uart_key_ready = false;
static volatile uint8_t uart_key_byte  = 0;

/* Byte writer with the same bounded, watchdog-safe wait as uart_puts(). */
static void uart_putb(uint8_t b)
{
    uint16_t guard = 0;

    while (!UART1_IsTxReady())
    {
        if (++guard >= 10000)
            return;
        __delay32(FCY / 100000ul);
        ClrWdt();
    }
    UART1_Write(b);
}

/* Interrupt-driven rather than polled: the jig spends seconds at a time
 * inside gauge transactions where nothing would service the port. The RX
 * FIFO is only four deep, so an 11-byte command arriving during one of those
 * would overflow it, latch OERR, and leave the receiver DEAD until something
 * read it - missing the command and every command after it. An interrupt
 * cannot miss the frame.
 *
 * The handler does almost nothing until a complete reset command arrives, at
 * which point it answers and resets the device - so how long that last part
 * takes stops mattering. */
void __attribute__((interrupt, no_auto_psv)) _U1RXInterrupt(void)
{
    uint8_t b, i;
    uint16_t guard;

    IFS0bits.U1RXIF = 0;

    while (U1STAbits.URXDA)
    {
        b = (uint8_t)U1RXREG;

        /* A frame can only begin with a command byte we recognise, so stray
         * characters from a terminal never leave us half-way through a
         * phantom packet waiting for bytes that will not come.
         *
         * Those stray characters are exactly what the operator types, so hand
         * them to uart_wait_key() instead of discarding them. A reset command
         * still takes priority: 0x09 starts a frame and never registers as a
         * key press, so the host can always reset the jig even while it is
         * sitting at a prompt. */
        if (jigCmdLen == 0 && b != JIG_CMD_RESET_DEVICE)
        {
            /* FIRST byte wins, and anything after it is dropped until the main
             * line consumes it. The host monitor is line buffered, so choosing
             * a menu item sends the character AND a newline about 87us apart
             * at 115200 - overwriting here would mean uart_wait_key() always
             * saw the newline and every selection read as "invalid". */
            if (!uart_key_ready)
            {
                uart_key_byte  = b;
                uart_key_ready = true;
            }
            continue;
        }

        if (++jigCmdLen < JIG_CMD_LENGTH)
            continue;                   /* still collecting */

        jigCmdLen = 0;

        /* Fixed response, byte-for-byte as the bootloader's ResetDevice(). */
        uart_putb(JIG_CMD_RESET_DEVICE);
        for (i = 0; i < 10; i++)
            uart_putb(0x00);
        uart_putb(JIG_CMD_SUCCESS);

        /* Let the reply leave the shift register before resetting, or the
         * host sees a truncated response. */
        for (guard = 0; !UART1_IsTxDone() && guard < 10000; guard++)
        {
            __delay32(FCY / 100000ul);
            ClrWdt();
        }
        __delay_ms(2);

        asm("reset");
    }

    /* An overrun latches the receiver off until OERR is cleared by hand. */
    if (U1STAbits.OERR)
        U1STAbits.OERR = 0;
}


/* Print a prompt and wait for the operator to send any character.
 *
 * Anything already received is discarded first, so noise on the line - or a
 * character typed before the prompt appeared - cannot skip the pause.
 *
 * Blocks indefinitely by design: the jig is attended, and a bring-up that
 * quietly carried on unattended would be worse than one that waits. The
 * watchdog is fed throughout, and the RX interrupt stays live, so the host
 * can still reset the jig out of this loop with a RESET_DEVICE command.
 *
 * The POWER BUTTON is honoured here too, so the unit can always be switched
 * off by hand - from the menu, or from any prompt - without needing the
 * serial link or the host at all. Every wait in the jig goes through this
 * function, so putting it here covers the lot rather than each caller having
 * to remember. A qualifying hold never returns (PowerDown drops the rails and
 * resets); a short press just borrows the LEDs while counting, so restore them
 * on the way back.
 *
 * @return the character the operator sent, for callers that want to offer a
 *         choice rather than just "carry on".
 */
static uint8_t uart_wait_key(const char *prompt)
{
    uart_key_ready = false;             /* drop anything already buffered */

    if (prompt != NULL)
        uart_puts(prompt);

    while (!uart_key_ready)
    {
        if (!POWER_BUTTON_GetValue())   /* active low */
        {
            PowerDown();                /* a qualifying hold never comes back */
            BI_LED_GREEN_SetHigh();
            BI_LED_RED_SetLow();
        }
        ClrWdt();
        __delay_ms(10);
    }

    uart_puts("\r\n");
    return uart_key_byte;
}


/* ---- Operator menu -----------------------------------------------------
 * STAGE 1: the menu and its dispatch are real, the actions are placeholders.
 * Each handler just says what was chosen, so the menu, the key handling and
 * the host echo can be proven before any test is moved into it.
 *
 * Selecting "load new image" prints JIG_PROMPT_LOAD, which is what
 * rgs_bootload_BringUp.py watches for - it detaches its monitor and offers to
 * flash. Nothing else in the firmware has to know about that.
 *
 * Anything unrecognised - including a bare Enter - simply redraws the menu,
 * so there is no way to get stuck and no "invalid choice" nagging.
 */
/* ---- Small number formatting -------------------------------------------
 * There is no stdio in this build and sprintf would drag in far more than a
 * couple of readouts justify, so these do the job directly.
 */
static void uart_put_int(int32_t v)
{
    char    buf[12];
    uint8_t n = 0;
    uint32_t u;

    if (v < 0)
    {
        uart_putb('-');
        u = (uint32_t)(-v);
    }
    else
    {
        u = (uint32_t)v;
    }

    do
    {
        buf[n++] = (char)('0' + (u % 10u));
        u /= 10u;
    } while (u);

    while (n)
        uart_putb((uint8_t)buf[--n]);
}

/* ComputePitchRoll() returns 8192 counts per 180 degrees (pitchandroll.c), so
 * one count is about 0.022 degrees. Print degrees to one decimal place using
 * integer maths only: tenths = raw * 1800 / 8192. */
static void uart_put_deg(int16_t raw)
{
    int32_t tenths = ((int32_t)raw * 1800) / 8192;
    int32_t whole  = tenths / 10;
    int32_t frac   = tenths % 10;

    if (frac < 0)
        frac = -frac;

    /* -0.4 would print as "0.4" without this: the sign lives in the whole
     * part, which is zero. */
    if (tenths < 0 && whole == 0)
        uart_putb('-');

    uart_put_int(whole);
    uart_putb('.');
    uart_put_int(frac);
}


/* Level test. Reads the accelerometer once a second and prints the raw counts
 * alongside the derived pitch and roll, until the operator presses Enter.
 *
 * QuickAcellerometerGrabber() returns nothing - it leaves its results in
 * EMULATE_EEPROM_Memory, raw XYZ at [10..15] and pitch/roll at [16..19], each
 * big-endian - so they are read back out from there rather than duplicating
 * the read.
 *
 * Initialises the accelerometer itself: the call in the fixed sequence is
 * commented out, so nothing else does, and a test that depends on having been
 * reached a particular way is exactly what this menu is meant to get away
 * from.
 */
static void test_level(void)
{
    uint8_t i;

    uart_puts("\r\n*** Level test ***\r\n");

    if (!LIS2DW12_Init_I2C2())
    {
        uart_puts("  ** accelerometer did not initialise - check I2C2 and the\r\n"
                  "     device address (this build uses LIS_ADDR_1, 0x19) **\r\n");
        uart_puts("  Hit Enter to return to the menu.\r\n");
        uart_key_ready = false;
        while (!uart_key_ready)
        {
            if (!POWER_BUTTON_GetValue())
            {
                PowerDown();
                BI_LED_GREEN_SetHigh();
                BI_LED_RED_SetLow();
            }
            ClrWdt();
            __delay_ms(10);
        }
        return;
    }
    /* No direct sensor read here: the loop below calls
     * QuickAcellerometerGrabber() and reads the results back out of
     * EMULATE_EEPROM_Memory, so this test shows exactly what the Jetson sees
     * over I2C - which is the thing worth verifying - and the axis re-mapping
     * lives in one place rather than being duplicated here. */

    uart_puts("  Raw counts and derived angles, once a second.\r\n"
              "  C to zero, Enter to return to the menu.\r\n\r\n");

    uart_key_ready = false;         /* ignore anything typed before we started */

    for (;;)
    {
        int16_t x, y, z, pitch, roll;

        QuickAcellerometerGrabber();        /* refreshes [10..19] */
        
     

        x     = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]);
        y     = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_Y_LSB_Addr]);
        z     = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_Z_LSB_Addr]);
        
        
        pitch = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[PitchLSB_Addr]);
        roll  = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[RollLSB_Addr]);

        uart_puts("  X=");      uart_put_int(x);
        uart_puts("  Y=");      uart_put_int(y);
        uart_puts("  Z=");      uart_put_int(z);
        uart_puts("   pitch="); uart_put_deg(pitch);
        uart_puts("  roll=");   uart_put_deg(roll);
        uart_puts(" deg\r\n");

        /* One second, but in 10 ms steps so a key is acted on straight away
         * rather than up to a second later, and the power button stays live. */
        for (i = 0; i < 100u && !uart_key_ready; i++)
        {
            if (!POWER_BUTTON_GetValue())
            {
                PowerDown();
                BI_LED_GREEN_SetHigh();
                BI_LED_RED_SetLow();
            }
            ClrWdt();
            __delay_ms(10);
        }

        if (uart_key_ready)
        {
            uint8_t key = uart_key_byte;

            uart_key_ready = false;     /* consume it, ready for the next one */

            if (key == 'c' || key == 'C')
            {
                /* Take the current attitude as level.
                 *
                 * ACCUMULATE, do not replace. x/y/z here come from
                 * EMULATE_EEPROM_Memory, and QuickAcellerometerGrabber()
                 * already added the existing calibration before storing them
                 * - so they are corrected values, not raw.
                 *
                 * Wanted: a new calibration C' with raw + C' == 0. Since
                 * raw = x - C, that gives C' = C - x, i.e. subtract the
                 * displayed value from what is already there.
                 *
                 * Writing `xcal = -x` instead zeroes against an
                 * already-corrected reading: the first press works, the
                 * second discards the correction (x reads ~0, so the new cal
                 * becomes ~0) and the readings jump back toward raw by
                 * whatever noise was present. This form is idempotent -
                 * pressing C twice without moving the board changes nothing.
                 */
                xcal = (int16_t)(xcal - x);
                ycal = (int16_t)(ycal - y);

                /* Z is deliberately NOT zeroed. It carries the 1g reference
                 * that pitch and roll are measured AGAINST - nulling it
                 * removes the very thing being measured. atan2(y, z) with z
                 * near zero is ill-conditioned, and roll flips to +/-180 on
                 * noise; it also accumulated toward the int16 limit (32147
                 * seen on the bench, against a 32767 ceiling) and wrapped.
                 *
                 * Cancelling mounting tilt only needs the horizontal
                 * components: with X and Y nulled at level, pitch and roll
                 * both read zero and Z keeps its full magnitude, so the
                 * angles stay well conditioned right through to 90 degrees.
                 *
                 * zcal is forced to zero rather than left alone, so a stale
                 * value stored by an earlier build cannot be loaded back at
                 * start-up and quietly reintroduce the fault. */
                zcal = 0;

                MAP_PackInt16(xcal, &EMULATE_EEPROM_Memory[Accl_CalX_LSB_Addr]);
                MAP_PackInt16(ycal, &EMULATE_EEPROM_Memory[Accl_CalY_LSB_Addr]);
                MAP_PackInt16(zcal, &EMULATE_EEPROM_Memory[Accl_CalZ_LSB_Addr]);

                uart_puts("\r\n  zeroed\r\n\r\n");

                continue;               /* stay in the test */
            }

            break;                      /* Enter, or anything else: leave */
        }
    }

    uart_puts("\r\n*** level test finished ***\r\n");
}


/* Manual beam-break test. Break each beam in turn and check the matching
 * laser lights. Runs until the operator presses Enter, then returns to the
 * menu.
 *
 * Two changes from the version that lived in the fixed sequence:
 *
 *  - it exits on Enter rather than on BOTH beams being broken at once. The
 *    old gesture needed two hands and could not be told apart from genuinely
 *    testing both beams, so the operator could not leave without triggering
 *    the thing being tested.
 *
 *  - it reports on a CHANGE of state, not every pass. The old loop printed
 *    for as long as a beam was held, which buried everything else.
 *
 * Leaves the lasers off and the beam emitters back off on the way out, so a
 * later test starts from a known state rather than inheriting this one's.
 */
static void test_beam_break(void)
{
    bool front_prev = false;
    bool rear_prev  = false;
    bool front_now, rear_now;

    uart_puts("\r\n*** Manual beam break test ***\r\n"
              "  Break each beam in turn - the matching laser should light.\r\n"
              "  Hit Enter to return to the menu.\r\n\r\n");

    BEAM_SetLow();                  /* emitters on (active low) */
    uart_key_ready = false;         /* ignore anything typed before we started */

    while (!uart_key_ready)
    {
        ClrWdt();

        /* Keep hold-to-power-off available, as everywhere else that waits. */
        if (!POWER_BUTTON_GetValue())
        {
            PowerDown();
            BI_LED_GREEN_SetHigh();
            BI_LED_RED_SetLow();
        }

        front_now = !FRONT_BALL_SENSE_GetValue();   /* active low = broken */
        rear_now  = !REAR_BALL_SENSE_GetValue();

        /* Lasers follow the sensors; low is lit. */
        if (front_now) FRONT_LASER_PWM_SetLow(); else FRONT_LASER_PWM_SetHigh();
        if (rear_now)  REAR_LASER_PWM_SetLow();  else REAR_LASER_PWM_SetHigh();

        if (front_now != front_prev)
        {
            uart_puts(front_now ? "  FRONT beam broken\r\n"
                                : "  FRONT beam clear\r\n");
            front_prev = front_now;
        }
        if (rear_now != rear_prev)
        {
            uart_puts(rear_now ? "  REAR  beam broken\r\n"
                               : "  REAR  beam clear\r\n");
            rear_prev = rear_now;
        }

        __delay_ms(10);
    }

    FRONT_LASER_PWM_SetHigh();
    REAR_LASER_PWM_SetHigh();
    BEAM_SetHigh();

    uart_puts("\r\n*** beam break test finished ***\r\n");
}


/* ---- EV2400 passive mode -------------------------------------------------
 *
 * Hands the local SMBus over to an EV2400 so bqStudio can characterise the
 * pack, while this PIC stays powered and keeps the rails latched up.
 *
 * The PIC cannot simply be switched off for this. The SMBus pull-ups sit on
 * our own 3V3 rail, so an unpowered board presents no bus at all - and an
 * EV2400 driving SCL/SDA into a dead board back-feeds 3V3 through the RB2/RB3
 * clamp diodes, partially powering the chip through two signal pins. Powered
 * but electrically absent is the only workable state.
 *
 * ORDER MATTERS getting off the bus: while I2CEN is set the module owns
 * RB2/RB3 regardless of TRIS, so the module must be disabled BEFORE the pins
 * are made inputs. Doing it the other way round looks right and does nothing.
 *
 * Safe to enter straight from the menu: every BQ40Z50 access is main line -
 * nothing touches the gauge from an interrupt - so no transaction can be in
 * flight when the module goes down.
 */
static void i2c2_bus_release(void)
{
    I2C2CONbits.I2CEN = 0;          /* first, or RB2/RB3 stay with the module */

    IEC3bits.MI2C2IE = 0;           /* leave nothing able to restart it */
    IEC3bits.SI2C2IE = 0;
    IFS3bits.MI2C2IF = 0;
    IFS3bits.SI2C2IF = 0;

    SDA_LOCAL_SetDigitalInput();    /* RB2 */
    SCL__LOCAL_SetDigitalInput();   /* RB3 */

    /* No pull-up work required: pin_manager clears CNPU1/CNPU2 wholesale and
     * re-enables only CN16 and CN21, neither of which is RB2 or RB3. */
}

/* Parks with the bus released. DOES NOT RETURN.
 *
 * This has to survive a full learning cycle - realistically 12 to 24 hours
 * including the relaxation periods - so the loop does nothing but clear the
 * watchdog and count. A watchdog reset partway through a bqStudio data flash
 * write would re-init I2C2 and drive the bus mid-transaction, corrupting the
 * write and losing the run.
 *
 * There is deliberately NO keystroke escape. Two reasons:
 *
 *  - a stray byte on the debug UART must not be able to end a twenty hour
 *    characterisation, and
 *
 *  - powering down is the only exit that cannot put two masters on the bus.
 *    bqStudio polls continuously while connected, so any path that re-enabled
 *    I2C2 on a live board would risk the PIC driving into an EV2400
 *    transaction. Dropping the rails removes us from the bus for good.
 *
 * The cost, and it matters: the EV2400 MUST be unwired BEFORE the rails drop.
 * An EV2400 driving SCL/SDA into an unpowered board back-feeds 3V3 through the
 * RB2/RB3 clamp diodes - precisely the failure this mode exists to avoid.
 */
static void ev2400_passive_mode(void)
{
    uint16_t ticks   = 0;           /* ~10 ms each */
    uint16_t minutes = 0;

    uart_puts("\r\n*** EV2400 passive mode ***\r\n"
              "  Releasing the local SMBus to the EV2400.\r\n"
              "  Wire SCL, SDA and GND only - leave EV2400 VCC disconnected,\r\n"
              "  this board supplies the rail and the bus pull-ups.\r\n"
              "\r\n"
              "  Loads can be switched while parked, to measure combinations:\r\n"
              "    2 front laser   3 rear laser   4 ball beam   5 IR lights\r\n"
              "\r\n"
              "  There is NO keyboard exit. This mode ends only at power down.\r\n"
              "  To finish: UNWIRE THE EV2400 FIRST, then hold the power button.\r\n"
              "  Unwiring first matters - an EV2400 left driving the bus into an\r\n"
              "  unpowered board back-feeds 3V3 through the PIC clamp diodes.\r\n\r\n");

    i2c2_bus_release();

    /* Both lines should now float high on our own 3V3 pull-ups. Either one
     * reading low means something is still holding the bus down, and the
     * EV2400 will not get on it - worth knowing before waiting 20 hours. */
    uart_puts("  SDA (RB2) reads ");
    uart_puts(SDA_LOCAL_GetValue()  ? "HIGH\r\n" : "LOW  ** still held **\r\n");
    uart_puts("  SCL (RB3) reads ");
    uart_puts(SCL__LOCAL_GetValue() ? "HIGH\r\n" : "LOW  ** still held **\r\n");
    uart_puts("\r\n  bus released - parked until power down\r\n");

    uart_key_ready = false;         /* drop anything typed before we started */

    for (;;)
    {
        /* The only way out. PowerButton() wants a qualifying ~900 ms hold, so
         * a knock cannot end the run; a short hold just falls through here. */
        if (!POWER_BUTTON_GetValue())          /* active low */
        {
            PowerDown();                       /* a qualifying hold never returns */
            BI_LED_GREEN_SetHigh();            /* too short - PowerButton had the LEDs */
            BI_LED_RED_SetLow();
        }

        /* Load switching, so one park can walk through several combinations
         * instead of costing a power cycle each. Same keys as the menu.
         *
         * None of these touch I2C2, so the bus stays released - which is also
         * why keys are safe here at all: the worst a stray byte can do is
         * flip a laser, where a keyed EXIT would have ended the run. The
         * marker lines matter as much as the toggles, since they are what
         * lines a step up against the current trace in the bqStudio log. */
        if (uart_key_ready)
        {
            switch (uart_key_byte)
            {
                case '2': FRONT_LASER_PWM_Toggle(); uart_puts("  > front laser\r\n"); break;
                case '3': REAR_LASER_PWM_Toggle();  uart_puts("  > rear laser\r\n");  break;
                case '4': BEAM_Toggle();            uart_puts("  > ball beam\r\n");   break;
                case '5': PWM_IR_Toggle();          uart_puts("  > IR lights\r\n");   break;
                default:  break;                    /* ignored - no exit by key */
            }
            uart_key_ready = false;                 /* re-arm the ISR capture */
        }

        ClrWdt();
        __delay_ms(10);

        /* Liveness tick, and the tell-tale for the thing this mode has to
         * avoid: if the elapsed count ever restarts from zero, the PIC reset
         * while parked and whatever bqStudio was doing is suspect. */
        if (++ticks >= 6000u)
        {
            ticks = 0;
            minutes++;
            uart_puts("  parked, ");
            uart_put_int((int32_t)minutes);
            uart_puts(" min\r\n");
        }
    }
}


static void menu_show(void)
{
    uart_puts("\r\n"
              "=========== RGS BringUp ===========\r\n");
    uart_puts("-----------             -----------\r\n");
    uart_puts("------------ Version "); 
    uart_put_int(FIRMWARE_REV_MSB);
    uart_puts(".");
    uart_put_int(FIRMWARE_REV_LSB);
    uart_puts(" ----------\r\n");
    
     uart_puts("--- Use with App V3.0 and up ----\r\n"
              "-----------------------------------\r\n"
              "  0  Show all status\r\n"
              "  1  Battery Minimal Function - NOT production\r\n"
              "  2  Toggle Front laser\r\n"
              "  3  Toggle Rear laser\r\n"
              "  4  Toggle Ball detect beam\r\n"
              "  5  Toggle IR lights\r\n"
              "  6  Manual beam-break test\r\n"
              "  7  Test Level  1\r\n"
              "  8  Load battery pack production Image\r\n"
              "  9   TBD 3\r\n"
              "                         \r\n"
              "                         \r\n"
              "  ---------------------- \r\n"
              "  E  EV2400 passive mode (release SMBus)\r\n"
              "  S  Save Settings\r\n"
              "  L  Load Production image\r\n"
              "  X  Exit and power down \r\n"
              "===================================\r\n"
              "Select (Enter to redraw): ");
}

#define MENU_ACTION_NONE      0     /* stay in the menu */
#define MENU_ACTION_SEQUENCE  1     /* run the fixed sequence, as before */
#define MENU_ACTION_LOAD      2     /* park and hand over for a firmware load */

static uint8_t menu_dispatch(uint8_t key)
{
    switch (key)
    {
        
        case '0':
        {
          BQ40Z50_ReportStatus(); 
        }
        break;
        /* MINIMUM functional bring-up. Deliberately NOT a characterised
         * image: this is the fixed configuration that makes a pack work at
         * all - 4 cell, non-removable, SLEEP off, FETs on and persistent,
         * design capacity and voltage - and nothing else. No Qmax, no Ra
         * tables, no learned gauging.
         *
         * The point is that a pack can be made functional in the lab or on
         * the line with no golden image available, so an app can be loaded
         * and the unit used. Gauging accuracy comes later, from case 8.
         *
         * Naming trap: the function called below is ApplyGoldenImage(), but
         * the table it writes IS this minimum configuration - the name
         * predates the split between "minimum config" and "characterised
         * image". It is the right call despite reading wrongly.
         *
         * Returns to the menu rather than parking, unlike case 8, because
         * the next step here is normally "now load an app". The pack is
         * left UNSEALED - sealing is a production end step. */
        case '1':
        {
            uint8_t   bad = 0, unset = 0;
            BQ_STATUS st;

            uart_puts("\r\n*** Minimum battery pack bring-up ***\r\n"
                      "  Fixed configuration only - no gauging data.\r\n\r\n");

            /* Free the bus first. A slave left holding SDA survives a PIC
             * reset, because the pack FETs keep every I2C2 device powered. */
            if (!BQ40Z50_BusUnwedge())
            {
                uart_puts("  ** I2C2 BUS STUCK - nothing attempted **\r\n");
                break;
            }

            /* Everything that is not data flash: probe, unseal, gauge reset,
             * FET enable. The unseal is what makes the writes below legal, so
             * this has to run first even on a pack that only needs one byte. */
            st = BQ40Z50_BringUp();
            if (st != BQ_OK)
                uart_puts("  (bring-up reported errors - continuing anyway)\r\n");

            /* The fixed config table. Writes only what is already wrong and
             * re-reads each entry it touches. */
            if (BQ40Z50_ApplyGoldenImage() != BQ_OK)
                uart_puts("  ** one or more config writes FAILED **\r\n");

            /* Independent read-back is the verdict - not the write status. */
            BQ40Z50_VerifyGoldenImage(&bad, &unset);

            uart_puts("\r\n  ---- minimum bring-up result ----\r\n");
            if (bad != 0)
            {
                uart_puts("  ** FAILED ** entries wrong or unreadable: ");
                uart_put_int((int32_t)bad);
                uart_puts("\r\n  Pack is NOT safe to ship or fit.\r\n");
            }
            else if (unset != 0)
            {
                uart_puts("  INCOMPLETE - verified so far, but ");
                uart_put_int((int32_t)unset);
                uart_puts(" value(s) unconfigured.\r\n");
            }
            else
            {
                uart_puts("  OK - minimum configuration verified.\r\n"
                          "  Pack is functional. NOT gauge-characterised.\r\n");
            }

            BQ40Z50_ReportGoldenImage();
            uart_puts("\r\n*** minimum bring-up finished ***\r\n");
        }
        break;
        
        case '2': 
        {
           uart_puts("\r\nCheck Front laser toggles. Turn off when finished please!!!\r\n");  
           FRONT_LASER_PWM_Toggle();
        }
        break;
        
        case '3': 
        {
           uart_puts("\r\nCheck rear laser toggles. Turn off when finished please!!!\r\n");  
           REAR_LASER_PWM_Toggle();
            
        }
        break;
            
    case '4':
    {
        uart_puts("\r\nCheck detection beam toggles. Switch it off when done\r\n");
        BEAM_Toggle();
    }
    break;
    case '5': 
    {
        uart_puts("\r\nCheck IR lights on, may need a phone camera to do this! Turn off when done !!!!\r\n");     
        PWM_IR_Toggle();
    }
        break;
        
        
    case '6':
    {
        test_beam_break();          /* returns when the operator hits Enter */
    }
    break;
    
     case '7':
    {
        test_level();               /* returns when the operator hits Enter */
    }
    break;
    
    
   case 'e':
   case 'E':
   {
        ev2400_passive_mode();      /* never returns - ends at power down */
   }
   break;

   case 's':
   case 'S':
   {
         uart_puts("\r\n  attempting to save settings .....\r\n");
        if (PERSIST_SaveFromEeprom())
            uart_puts("\r\n  settings saved\r\n");
        else
         uart_puts("\r\n  ** SAVE FAILED **\r\n");
   }
    break;

    /* Not a placeholder: runs everything exactly as it does today, so a pack
     * can still be provisioned while the individual handlers above are being
     * filled in. It ends in the park below and does not come back here. */
    case '8': 
        return MENU_ACTION_SEQUENCE;

    case 'l':
    case 'L': 
        return MENU_ACTION_LOAD;

    default:  break;                /* redraw, no complaint */
    }
    return MENU_ACTION_NONE;
}

/* Runs until the operator picks something that leaves the menu. */
static uint8_t menu_run(void)
{
    uint8_t action;

    for (;;)
    {
        menu_show();
        action = menu_dispatch(uart_wait_key(NULL));
        if (action != MENU_ACTION_NONE)
            return action;
    }
}

/* Final resting state: report the pack once, then sit on the handover prompt
 * the host watches for. Never returns - the host resets us to load an image,
 * or the operator powers the unit down with the button. */
static void jig_park_for_load(void)
{
    BI_LED_GREEN_SetHigh();
    BQ40Z50_ReportStatus();
    uart_puts("\r\n" JIG_PROMPT_LOAD "\r\n");

    for (;;)
    {
        if (!POWER_BUTTON_GetValue())      /* active low */
        {
            PowerDown();
            /* Returned: hold was too short. Restore the verdict display,
             * since PowerButton() borrowed the LEDs while counting. */
            BI_LED_GREEN_SetHigh();
            BI_LED_RED_SetLow();
        }
        ClrWdt();
        __delay_ms(50);
    }
}


int main(void)
{
    /* ---- Cold start vs warm reset (REVIEW) --------------------------------
     * RCONbits.POR is set by the silicon ONLY on a genuine power-on; software
     * resets (bootloader handoff, firmware-update reset, InitSelfReset) and
     * the watchdog leave it clear -- PROVIDED we clear it once per power
     * cycle, which happens below at the point power-on is complete.
     *
     *   warmBoot == true : we were already running before this reset (e.g.
     *                      just came back from a firmware update). Re-latch
     *                      our own supply AND keep the Jetson's 5V alive
     *                      immediately -- microseconds after reset, before
     *                      SYSTEM_Initialize can let anything sag.
     *   warmBoot == false: genuine cold start. Touch nothing here; the
     *                      Jetson stays OFF and power-on follows the normal
     *                      charger-loop / button-hold flow.
     */
    bool warmBoot = ((RCONbits.POR == 0));

    if (warmBoot)
    {
        HOLD_PWR_SetDigitalOutput();
        HOLD_PWR_SetHigh();
        JETSON_5V_ON_SetDigitalOutput();
        JETSON_5V_ON_SetHigh();
        
    }

    SYSTEM_Initialize();

    /* Two-speed start-up leaves us on the FRC at ~1/8 speed until the crystal
     * is ready. Nothing that depends on FCY - UART baud, I2C timing, delays -
     * is trustworthy before this returns. */
    wait_for_primary_clock();

    REAR_LASER_PWM_SetHigh();
    FRONT_LASER_PWM_SetHigh();

    LedOn=0;
    FrontSense=0;
    RearSense=0;
    TransitTime=0;
    GateTimeout=0;
    SwitchState=0; 
    ButtonCount=0;
    PowerOff=false;
   
     
    //This is a 
    EMULATE_EEPROM_Memory[128] = 0;  //This should cause both lasers off
    PWM_RB11_Init();
    PWM_RB11_Enable();
    PWM_RB11_SetDuty(10);
    I2C_WriteQueue_Init();
    // Explicit changes for new versions
    POWER_BUTTON_SetDigitalInput();
    
    /* PIN_MANAGER_Initialize (inside SYSTEM_Initialize) bulk-writes the
     * latches, momentarily dropping both rails; the external FET gates ride
     * through that dip on capacitance. Re-assert per the boot type:
     *   warm : both rails HIGH -- Jetson must not lose power across a reset.
     *   cold : HOLD_PWR stays HIGH (we MUST keep our own supply latched --
     *          we arrived here from a bootloader handoff-reset, the button is
     *          already released, and on battery there is nothing else holding
     *          3V3 up; dropping HOLD_PWR here powers the device straight off
     *          before the charger loop ever runs). Jetson rail stays OFF so
     *          the charge-indication state is Jetson-dark until power-on
     *          completes via the button.
     */
    HOLD_PWR_SetDigitalOutput();
    JETSON_5V_ON_SetDigitalOutput();
    HOLD_PWR_SetHigh();                  /* keep our own supply latched, both boot types */
    if (warmBoot)
    {
        JETSON_5V_ON_SetHigh();
    }
    else
    {
        JETSON_5V_ON_SetLow();
    }
    
    
    /* Cold-start power-on. Warm boots (firmware-update resume) skip all of
     * this. The path splits on whether the charger is present, read from
     * /ACOK on RA7 (DEBUG_IN): the charger IC pulls it LOW when AC is
     * present, an external pull-up holds it HIGH otherwise.
     *
     *   NO charger  -> the only way 3V3 came up on battery is a deliberate
     *                  button press, so power straight up and run. HOLD_PWR
     *                  is already latched high -> single press, no charger
     *                  loop, no second press.
     *
     *   Charger present -> the charger forced us on; the user has not asked
     *                  to run yet. RELEASE HOLD_PWR so the charger alone
     *                  holds the rail -- then pulling the charger while still
     *                  idle drops power and the unit goes fully off (no
     *                  latched-on-but-idle limbo). Show charge status and
     *                  wait for a button press; on press, re-latch HOLD_PWR
     *                  and power up. Once latched, unplugging keeps us
     *                  running on battery.
     *
     * Safety: HOLD_PWR is only released when the charger DEFINITELY reads
     * present (RA7 == 0). Any other reading falls through to run-and-stay-
     * latched, so a misread can never strand a battery boot dead. */
    /* BRING-UP JIG: the product's cold-start charger loop (release HOLD_PWR,
     * charge-indicate, wait for a power-button press-and-hold) is bypassed.
     * A provisioning jig must power straight up and run unconditionally, and
     * must never release HOLD_PWR - on the pack bench there may be no charger
     * holding the rail, so releasing it powers the board off. HOLD_PWR is
     * already latched high above; fall straight through to running. */
    /* Both paths are now "powered and running": show green. */
    BI_LED_GREEN_SetHigh();//Turn on Green LED
    BI_LED_RED_SetLow();//Turn off Red LED

    /* Power-on is complete: clear the power-on reset-cause bits so every
     * later reset in this power cycle reads as warm (POR==0). Deliberately
     * placed AFTER the button-hold: if we crash or watchdog out of the
     * charger loop / hold-count above, POR is still set and the retry is
     * correctly treated as another cold start. SWR/WDTO are left untouched
     * for any future reset-cause diagnostics (nothing reads them today). */
    RCONbits.POR = 0;
    RCONbits.BOR = 0;

    /* The accelerometer correction values are NOT read here any more. They
     * live in EMULATE_EEPROM_Memory, which is not populated from the
     * persistent store until PERSIST_LoadToEeprom() runs further down - so
     * reading them at this point picked up zeros, and a saved calibration
     * never reached QuickAcellerometerGrabber(). They are read immediately
     * after the restore instead. */

    FrontSensorOff;
    RearSensorOff;
    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;

    
    ClrWdt();

    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;
    INTERRUPT_GlobalEnable();   // this is an inline, in the interrupt manager header, so not a function call as such!
    PWM_RB11_Init();
    
  
    LightingUpdate=0;
    uint8_t bugout;
    uint8_t reportTick;
    uint8_t goldenBad;
    uint8_t goldenUnset;
    BQ_PROVISIONED prov;
  
    char LastOnOff;
    LedOn=0;
    LastOnOff=0;

  
  // set the 'ticks per second and other defaults.
    
   // in due course, add a bit of non-vol and init all at start up.
   


   // INTERRUPT_TO_JETSON_SetLow();
    RestoreDetect();
   
   // LIS2DW12_Init_I2C2();    // TODO: should ensure it inits, or returns an error

    /* --- BQ40Z50-R2 battery pack bring-up (report on UART1) --- */

    /* U1TX is RC4, and PIN_MANAGER_Initialize() drove LATC = 0, so the TX line
     * sits LOW until the UART is enabled - a break condition. The receiver
     * reads the low-to-idle transition as framing errors, which is why the
     * greeting arrived as garbage ("Hu5UB") while everything later was clean.
     * uart1.c's own header says to set the TX latch high before init. */
    LATCbits.LATC4 = 1;
    __delay_ms(2);                  /* let the line settle at idle */
    UART1_Initialize();
    __delay_ms(2);

    /* Enable receive interrupts so a Jetson command is never missed, even
     * while we are deep inside a gauge transaction. URXISEL in U1STA is 00
     * (MCC default), so this fires on every character. */
    IFS0bits.U1RXIF = 0;
    IEC0bits.U1RXIE = 1;

    uart_puts("\r\nRGS BringUp jig: hello\r\n");

    /* Establish EMULATE_EEPROM_Memory: restore it if this board has been
     * provisioned before, otherwise build it from the coded defaults.
     *
     * PERSIST_LoadToEeprom() returns false only when NEITHER bank validates -
     * magic, length and CRC must all agree, and erased flash reads 0xFFFF, so
     * a never-written board is rejected deterministically rather than
     * probabilistically. In that case it leaves the register file untouched,
     * so InitEmulatedEEprom() defines everything.
     *
     * Placed here rather than earlier because UART1 only comes up a few lines
     * above - SYSTEM_Initialize() leaves it commented out - and which branch
     * was taken is worth reporting.
     *
     * NOTE: once a board has a valid bank, InitEmulatedEEprom() never runs
     * again, so a default added to it later will not reach already-provisioned
     * units. If that becomes a problem, put a format/version byte in the block
     * and re-run the init when it does not match what this firmware expects. */
    if (PERSIST_LoadToEeprom())
    {
        uart_puts("Persistent config: restored from flash\r\n");
    }
    else
    {
        uart_puts("Persistent config: none stored - applying defaults\r\n");
        InitEmulatedEEprom();
    }

    /* Stamp the RUNNING firmware version over whatever was restored. The
     * version lives inside the mirrored block, so a provisioned board would
     * otherwise report the version that was current when it was provisioned.
     * InitEmulatedEEprom() writes these too, but only on the defaults path. */
    EMULATE_EEPROM_Memory[FirmwareVersionMSB] = FIRMWARE_REV_MSB;
    EMULATE_EEPROM_Memory[FirmwareVersionLSB] = FIRMWARE_REV_LSB;

    /* Pull the accelerometer corrections into the working variables, now that
     * the register file holds either the restored block or the defaults.
     *
     * This MUST stay after the load. It used to sit ~120 lines earlier, where
     * it read zeros because nothing had populated EMULATE_EEPROM_Memory yet -
     * a saved calibration was written to flash correctly and restored
     * correctly, but never reached QuickAcellerometerGrabber(), so a
     * calibrated board still read its raw mounting offset after a restart.
     *
     * If a cal-update job is ever added to the app, it must refresh these too
     * - writing the bytes alone is not enough. */
    xcal = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_CalX_LSB_Addr]);
    ycal = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_CalY_LSB_Addr]);
    zcal = MAP_UnpackInt16(&EMULATE_EEPROM_Memory[Accl_CalZ_LSB_Addr]);

    /* Provision a blank board straight away so it is never left unsaved. On a
     * board that was restored this finds nothing to do and writes nothing -
     * flash endurance is finite and a jig is power-cycled far more often than
     * a field unit. The operator's "save settings" menu item covers changes
     * made during the session.
     *
     * The write blocks for ~30 ms with interrupts unserviced. Safe here - it
     * is before the jig loop and nothing is mid-transaction. */
    if (!PERSIST_EepromMatchesStore())
    {
        if (PERSIST_SaveFromEeprom())
            uart_puts("Persistent config: WRITTEN\r\n");
        else
            uart_puts("Persistent config: ** WRITE FAILED **\r\n");
    }
    else
    {
        uart_puts("Persistent config: already up to date\r\n");
    }


    /* Jetson 5V rail UP for the whole jig session, before the menu is offered.
     *
     * The lasers, the beam and the IR emitters all hang off this rail, so with
     * it low their control pins do nothing and a test looks broken when it is
     * only unpowered. The cold-start path above deliberately leaves it LOW
     * (line ~528) because a field unit must not power the Jetson until the
     * user asks for it - a jig has no such requirement, and expecting each
     * test to raise it individually just moves the trap around.
     *
     * The fixed sequence raises it again later; harmless, it is idempotent. */
    JETSON_5V_ON_SetDigitalOutput();
    JETSON_5V_ON_SetHigh();
    __delay_ms(50);                 /* let the rail settle before anything drives it */

    /* Operator menu. STAGE 1: only "8 - full sequence" and "L - load image"
     * do anything; the individual tests are placeholders that report what was
     * chosen. Moving each test out of the fixed sequence below and into its
     * own handler is stage 2.
     *
     * Falls through to the fixed sequence on 8, so a pack can still be
     * provisioned normally while that work is done. */
    if (menu_run() == MENU_ACTION_LOAD)
        jig_park_for_load();        /* never returns */

     BEAM_SetHigh();

    /* Free the bus before the first gauge access. The pack FETs stay latched
     * on, so every I2C2 device keeps its power through a PIC reset - a plain
     * I2C slave left holding SDA stays stuck across restarts until something
     * clocks it out, which is why the fault used to persist run after run. */
    if (BQ40Z50_BusUnwedge())
        uart_puts("I2C2 bus unwedge: ok\r\n");
    else
        uart_puts("I2C2 bus unwedge: BUS STILL STUCK\r\n");


    /* BRING-UP JIG: repeat the report forever (green LED heartbeat between
     * runs) so a serial monitor attached at any time sees it within a few
     * seconds. The product main loop below is never reached. */
    while (1)
    {
        
            for (bugout = 0; bugout < 10; bugout++)     /* ~5 s heartbeat */
        {
            BI_LED_GREEN_Toggle();
            BI_LED_RED_Toggle();
            __delay_ms(500);
            ClrWdt();
        }
       /* Dark while working, so green means the VERDICT and nothing else.
        * A visible dark period = the gauge was slow to answer. */
       BI_LED_RED_SetLow();
       BI_LED_GREEN_SetLow();

       /* Provisioning is judged by the WHOLE golden image now, not just the
        * DA Config byte. BringUp() still runs first when something is wrong:
        * it does the parts that are not data flash - probe, unseal, FET
        * enable, gauge reset - and unsealing is what makes the writes legal. */
       BQ40Z50_VerifyGoldenImage(&goldenBad, &goldenUnset);
       if (goldenBad != 0)
       {
           BQ40Z50_BringUp();
           BQ40Z50_ApplyGoldenImage();
           BQ40Z50_VerifyGoldenImage(&goldenBad, &goldenUnset);
       }

       if (goldenBad != 0)
           prov = BQ_PROV_NO;        /* entries wrong, or unreadable */
       else if (goldenUnset != 0)
           prov = BQ_PROV_UNKNOWN;   /* correct so far, but image incomplete */
       else
           prov = BQ_PROV_YES;

       /* Park showing the verdict. All THREE outcomes get their own pattern,
        * and an INCOMPLETE image must never show as a pass - otherwise a pack
        * with no capacity or gauging configured looks identical to a finished
        * one.
        *
        *   solid green            - golden image complete and verified
        *   red flashing           - entries wrong or unreadable
        *   green/red alternating  - verified so far, but values still unset
        */
       BI_LED_GREEN_SetHigh();
       BI_LED_RED_SetLow();

       BQ40Z50_ReportStatus();
       BQ40Z50_ReportGoldenImage();
       reportTick = 0;
       while (1)
       {
           if (prov == BQ_PROV_NO)
           {
               BI_LED_GREEN_SetLow();
               BI_LED_RED_SetHigh();
           }
           else if (prov != BQ_PROV_YES)     /* BQ_PROV_UNKNOWN */
           {
               BI_LED_GREEN_SetHigh();
               BI_LED_RED_SetHigh();
           }
           __delay_ms(150);
           ClrWdt();

           /* Re-report every ~5 s so a serial monitor attached at any time
            * sees the pack state within seconds, rather than having to catch
            * the one-shot report at power-up. */
          
          
           
           
    
           
       
      
       uart_puts("\r\n***********************************\r\n");
       uart_puts("\r\n********Auto mated tests complete****\r\n");
       
        uart_puts("\r\n*******Manual beam break tests****\r\n");
        uart_puts("\r\n***   Break each beam in turn,   ****\r\n");
        uart_puts("\r\n***   Verify corresponding laser comes on   ****\r\n");
        uart_puts("\r\n***Simultaneously break both beams to exit  ****\r\n");
        BEAM_SetLow();
        while(1)
        {
            ClrWdt();
            if(!(FRONT_BALL_SENSE_GetValue()))
            {
                uart_puts("\r\n***   Front Beam broken? ****\r\n");
                FRONT_LASER_PWM_SetLow();
            }
               
            else
            {
                FRONT_LASER_PWM_SetHigh();
              
               
            }
            
            if(!(REAR_BALL_SENSE_GetValue()))
            {
               REAR_LASER_PWM_SetLow();
                uart_puts("\r\n***   Rear Beam broken? ****\r\n"); 
            }
            else
            {
                REAR_LASER_PWM_SetHigh();   
            }
            
            if( (!(FRONT_BALL_SENSE_GetValue())) && (!(REAR_BALL_SENSE_GetValue())))
                break;
            
                
        }
       REAR_LASER_PWM_SetHigh(); 
        FRONT_LASER_PWM_SetHigh();
        
       uart_puts("\r\n*******Tests Complete****\r\n");

      /* Park: keep displaying the pack verdict, and offer a way out.
       * PowerDown() requires a qualifying ~900 ms hold (flashing the LEDs as
       * feedback while it counts), then drops the Jetson rail and releases
       * HOLD_PWR. If something external is still holding the rail up it forces
       * a reset rather than leaving us latched-but-idle. A short press is
       * ignored, so this cannot power off by accident. */
       if (prov == BQ_PROV_NO)
          {
              BI_LED_GREEN_SetLow();
              BI_LED_RED_SetHigh();
          }
          else if (prov != BQ_PROV_YES)      /* BQ_PROV_UNKNOWN */
          {
              BI_LED_GREEN_SetHigh();
              BI_LED_RED_SetHigh();
          } 
       
      /* Bring-up is finished. Report the pack ONCE and then park on a single
       * prompt, rather than repeating the battery report forever - the
       * repetition scrolled anything interesting off the operator's screen.
       *
       * JIG_PROMPT_LOAD is the handover to the host: rgs_bootload_BringUp.py
       * watches the line for this exact text, detaches its monitor and offers
       * to flash a new image. The two strings must stay in step; if this one
       * changes, change the marker in that script as well.
       *
       * Nothing is done with the operator's key press here - the host consumes
       * it and takes over, raising JETSON_CALLING and sending RESET_DEVICE,
       * which the UART interrupt above acts on. So this loop only has to stay
       * alive and keep the power button working. */
      jig_park_for_load();          /* never returns */

       }
    }                       /* jig loop: never exits */

    
    
    return 0;
}
///End of int main(void)


///functions, TBD other headers etc

void CallJetsonBall(void)
{
    
     BALL_DETECT_INT_SetHigh();
    __delay_ms(10);
    BALL_DETECT_INT_SetLow();
  //  __delay_ms(10);
   // BALL_DETECT_INT_SetHigh();
  //  __delay_ms(10);
 //   BALL_DETECT_INT_SetLow();
  //  __delay_ms(10);  
}

void CallJetsonJob(void)
{
    FrontSensorOff;
    RearSensorOff;
    IFS1bits.T5IF = false;
    IFS1bits.T5IF = false;
    IEC1bits.T5IE = false;
    IFS1bits.CNIF = 0;

    LOCAL_STATUS_LED_SetLow(); //turn the LED off 
    INTERRUPT_TO_JETSON_SetHigh();
    __delay_ms(10);
    INTERRUPT_TO_JETSON_SetLow();
    //ensure Jetson heartbeat is high
    while(!JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(10);
        ClrWdt();
    }
    LOCAL_STATUS_LED_SetHigh();  //high again when heartbeat seen
    while(JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(100);
        ClrWdt();
        BI_LED_GREEN_Toggle();
    };
    BI_LED_GREEN_SetLow();
    //we should have had the jetson acknowledge by now, so turn off
  //  JETSON_5V_ON_SetLow();
   
    while(!JETSON_HEARTBEAT_GetValue())
    {
        __delay_ms(100);  
        ClrWdt();
        BI_LED_GREEN_Toggle();
    };
       
       RestoreDetect();
}





void ShutdownProcessTemp()

{
    uint8_t delay;
     BI_LED_RED_SetLow();   
    for(delay=0;delay<200;delay++)
    {
         ClrWdt();
        __delay_ms(50);
        RED_LED_ON_Toggle();  
    }
        RED_LED_ON_SetLow();         

   JETSON_5V_ON_SetHigh();//temp flip
        
    ButtonCount=0;
    while(ButtonCount<10)
    {
       
        if(!POWER_BUTTON_GetValue())
            ButtonCount++;
        else
            ButtonCount=0;
        __delay_ms(50);
        ClrWdt();
       
    }
    while(!POWER_BUTTON_GetValue())
    {
        ClrWdt();
        __delay_ms(50);
         BI_LED_GREEN_Toggle();   
    }
       BI_LED_GREEN_SetLow();       
   
     JETSON_5V_ON_SetLow();//tempflip
    
}





/* Provide a tiny delay; replace with your system delay if you have one */
static void small_delay(void)
{
    /* ~1?2 ms software delay; adjust to taste or replace with __delay_ms(1) */
    //for (volatile uint32_t i = 0; i < 8000UL; i++) { __asm__ volatile ("nop"); }
    __delay_ms(1);
}
//void LIS2DW12_SetAddress_I2C2(uint8_t addr)
//{
    
//}

/* ---- Low-level helpers using ONLY your TRB API ---- */

/* Proper repeated-start via TRB pair: write(reg) then read(n) */
/* Preferred: repeated-start via TRB pair. Falls back to STOP (write then read). */
/* ---- High-level sensor ops ---- */

void QuickAcellerometerGrabber(void)
{
  
    int16_t pitch;
    int16_t roll;
    
   
        ClrWdt();
        int16_t x, y, z;
        
        // with reference to my notes in the 'compute pitch and roll', copied below
         // x,y,z are as 'text book' ,ie
    //X is 'forward' Z is down, Y is 'right'
    //not aligned to the accelerometer
    // 
        //so we need to correct for the orientation of the device on the PCB
        // the physical axis, related back to the accelerometer
        // current hardware, this is on the bottom side, so 'upside down'
        // Y 'points to the rear, X points right
        // thus we need to swap x and y
        // if we do this in the calling function, everything else shoud be fine
        
        if (LIS2DW12_ReadXYZ_I2C2(&y, &x, &z)) // note unconventional axis sequence)
        {
            
            //apply the corrections
            
            /* Mounting-tilt cancellation, horizontal components only.
             *
             * Z is NOT corrected: it carries the 1g reference that pitch and
             * roll are measured against, so offsetting it makes atan2(y, z)
             * ill-conditioned - roll flips to +/-180 on noise once z nears
             * zero - and the accumulated offset runs into the int16 limit.
             * Nulling X and Y is enough to make a level board read zero on
             * both angles. zcal is kept only so a stored value can be read
             * back and inspected; it is not applied. */
            x=x+xcal;
            y=y+ycal;
            
        /* ...and negate Z. Not cosmetic: the sensor reads about -1g on Z with
         * the board level, while atan2(y, z) in ComputePitchRoll() needs z
         * POSITIVE when level. It also restores handedness - the X/Y swap
         * above has determinant -1, a mirror rather than a rotation, which
         * reads correctly while level (both swapped axes ~0) and goes wrong
         * as soon as the board is tilted. Swap plus one negation is
         * determinant +1, a real rotation. If "positive roll" turns out to
         * mean the wrong direction, negate all three instead - also +1. */
     
            
            z = (int16_t)(-z);
        
       
       

        
        // Pack as [X_L, X_H, Y_L, Y_H, Z_L, Z_H]
        MAP_PackInt16(x, &EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]);
        MAP_PackInt16(y, &EMULATE_EEPROM_Memory[Accl_Y_LSB_Addr]);
        MAP_PackInt16(z, &EMULATE_EEPROM_Memory[Accl_Z_LSB_Addr]);
     
         
         
            /* use raw counts; scale later if needed */
        }
        else // if it fubars, then just fill with 0xFF;
            // 0xFF picked as zero is a plausible free -fall condition
        {
         EMULATE_EEPROM_Memory[Accl_X_LSB_Addr]  = 0xFF;
         EMULATE_EEPROM_Memory[Accl_X_MSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[Accl_Y_LSB_Addr] = 0xFF;
         EMULATE_EEPROM_Memory[Accl_Y_MSB_Addr] =0xFF;;
         EMULATE_EEPROM_Memory[Accl_Z_LSB_Addr] =0xFF;
         EMULATE_EEPROM_Memory[Accl_Z_MSB_Addr] =0xFF; 
        }
       ComputePitchRoll(x,y,z,&pitch,&roll);
      
       MAP_PackInt16(pitch, &EMULATE_EEPROM_Memory[PitchLSB_Addr]);
       MAP_PackInt16(roll, &EMULATE_EEPROM_Memory[RollLSB_Addr]);
   
       
}

//refactor into a general purpose button thing...
void PowerDown(void)
{ 
    uint8_t HoldOffms;
    HoldOffms = 0;
    if (PowerButton(Off))
    {
        JETSON_5V_ON_SetLow();
        HOLD_PWR_SetLow();

        // Give the external power-latch hardware time to actually cut supply
        // before we reset. Without this delay, if the latch hasn't dropped
        // power yet, the MCU reboots while still powered (going through the
        // bootloader) with the button often still held, which re-latches
        // power straight back on instead of turning off.
        
        while(1)
        {
            
            ClrWdt();
            __delay_ms(50);
           
            HoldOffms++;
            if(HoldOffms >=30)
            {
                
              RCONbits.EXTR = 1;
              RCONbits.POR=1;
              RCONbits.BOR=1;
              while(1)
                  ClrWdt();
            }
        }
       
    }
    return;
    
}


//returns 1 if Power button held long enough
// or 0 if not....
uint8_t PowerButton (bool OnOff)
{
    uint8_t ButtonPressHold;
    ButtonPressHold=0;
    bool ButtonPassed;
    ButtonPassed=0;
    
    while(!POWER_BUTTON_GetValue())
    {
        ButtonPressHold++;

        // Feed the watchdog: in the field (bootloader-programmed) config the
        // WDT period is only ~1.06s (4.1ms x PS256), and this hold-count runs
        // ~900ms -- without this, the WDT fires mid-count on every power-on
        // hold and the device reset-loops through the flash sequence.
        ClrWdt();

       BI_LED_GREEN_SetHigh();//Turn on Green LED
       BI_LED_RED_SetLow();//Turn off Red LED
      __delay_ms(100);
      BI_LED_RED_SetHigh();//Turn on Red LED
      BI_LED_GREEN_SetLow();//Turn off Green LED
      __delay_ms(50);
      if (ButtonPressHold>5)
      {
          ButtonPassed=1;

          break;
      }

    }
    if (OnOff)
    {
         HOLD_PWR_SetHigh();
         JETSON_5V_ON_SetHigh();
         BI_LED_GREEN_SetHigh();//Turn/JETSON_5V_ON_SetHigh(); on Green LED
         BI_LED_RED_SetLow();//Turn off Red LED 
    }
    else
    {
      BI_LED_RED_SetHigh();//Turn on Red LED
      BI_LED_GREEN_SetLow();//Turn off Green LED  
    }
        

    __delay_ms(50);
    while(!POWER_BUTTON_GetValue())
    {
        ClrWdt();
       __delay_ms(50);    
    }
    
    __delay_ms(50);
    
     while(!POWER_BUTTON_GetValue())
    {
         ClrWdt();
         __delay_ms(50);    
    }
    
    return(ButtonPassed);
         
}

 
// ---- PWM on RB11 via OC3 / T3 ----
// T3 runs at 100kHz (PR3=159, FCY=16MHz, prescaler 1:1)
// OC3 in PWM mode (no fault), OCTSEL=1 (T3)
// RB11 already mapped to OC3 in pin_manager.c

void PWM_RB11_Init(void)
{
    // T3: 16-bit, 1:1 prescaler, 100kHz
    TMR3  = 0x0000;
    PR3   = PWM_RB11_PERIOD;
    T3CON = 0x8000;         // TON=1, TCKPS=1:1, internal clock

    // OC3: PWM mode without fault, timer source = T3 (OCTSEL=1)
    OC3R   = 0;             // initial duty = 0
    OC3RS  = 0;             // shadow register = 0
    OC3CON = 0x0000;        // disabled until PWM_RB11_Enable() called
}

void PWM_RB11_Enable(void)
{
    OC3CON = 0x000E;        // OCM=110 (PWM no fault), OCTSEL=1 (T3)
}

void PWM_RB11_Disable(void)
{
    OC3CON = 0x0000;        // OCM=000, output disabled
}

void PWM_RB11_SetDuty(uint8_t duty)
{
    // in this implementation, we have 0-160 as our range, so 0.625% per bit
    if (duty > 160) duty = 160;
    OC3RS = (uint16_t)duty;
    
}

// ---- End PWM RB11 ----
// round robin tasks ...
/// normal tasks list, 'Standard'
/// alternative, test builds are 'Test1' and 'Test2'

 void GetBattVolts(void)
 {
   
    uint8_t dst[2];
     BI_LED_GREEN_SetLow();//Turn off Green LED
     BI_LED_RED_SetHigh();//Turn on Red LED
     ClrWdt();
     i2c2_read_regs(0x36, 0x09, dst, 2);
      ClrWdt(); 
      
     EMULATE_EEPROM_Memory[8]=dst[1];
     EMULATE_EEPROM_Memory[9]=dst[0];
     BI_LED_GREEN_SetHigh();//Turn off Green LED
     BI_LED_RED_SetLow();//Turn on Red LED
 }

void GetAccel(void)
{
    BI_LED_GREEN_SetLow();//Turn off Green LED
    BI_LED_RED_SetHigh();//Turn on Red LED
    QuickAcellerometerGrabber();
    BI_LED_GREEN_SetHigh();//Turn off Green LED
    BI_LED_RED_SetLow();//Turn on Red LED
}




 

// delays for x 10ths of a second
void WDT_SafeDelay10thSecs (uint8_t seconds_10th)
{
  
    uint8_t smallcount;
    
    for (smallcount=0;smallcount<seconds_10th;smallcount++)
      {
          __delay_ms(100);
          ClrWdt();
      }
}
