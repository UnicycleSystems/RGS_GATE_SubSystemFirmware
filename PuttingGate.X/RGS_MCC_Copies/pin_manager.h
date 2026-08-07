#ifndef _PIN_MANAGER_H
#define _PIN_MANAGER_H

#include <xc.h>
void RestoreDetect(void);

#define FRONT_BALL_SENSE_SetHigh()          (_LATA0 = 1)

#define FRONT_BALL_SENSE_SetLow()           (_LATA0 = 0)

#define FRONT_BALL_SENSE_Toggle()           (_LATA0 ^= 1)

#define FRONT_BALL_SENSE_GetValue()         _RA0

#define FRONT_BALL_SENSE_SetDigitalInput()  (_TRISA0 = 1)

#define FRONT_BALL_SENSE_SetDigitalOutput() (_TRISA0 = 0)

#define REAR_BALL_SENSE_SetHigh()          (_LATA1 = 1)

#define REAR_BALL_SENSE_SetLow()           (_LATA1 = 0)

#define REAR_BALL_SENSE_Toggle()           (_LATA1 ^= 1)

#define REAR_BALL_SENSE_GetValue()         _RA1

#define REAR_BALL_SENSE_SetDigitalInput()  (_TRISA1 = 1)

#define REAR_BALL_SENSE_SetDigitalOutput() (_TRISA1 = 0)

#define HOLD_PWR_SetHigh()          (_LATA10 = 1)

#define HOLD_PWR_SetLow()           (_LATA10 = 0)

#define HOLD_PWR_Toggle()           (_LATA10 ^= 1)

#define HOLD_PWR_GetValue()         _RA10

#define HOLD_PWR_SetDigitalInput()  (_TRISA10 = 1)

#define HOLD_PWR_SetDigitalOutput() (_TRISA10 = 0)

#define ACCEL_INT_SetHigh()          (_LATA4 = 1)

#define ACCEL_INT_SetLow()           (_LATA4 = 0)

#define ACCEL_INT_Toggle()           (_LATA4 ^= 1)

#define ACCEL_INT_GetValue()         _RA4

#define ACCEL_INT_SetDigitalInput()  (_TRISA4 = 1)

#define ACCEL_INT_SetDigitalOutput() (_TRISA4 = 0)

#define DEBUG_IN_SetHigh()          (_LATA7 = 1)

#define DEBUG_IN_SetLow()           (_LATA7 = 0)

#define DEBUG_IN_Toggle()           (_LATA7 ^= 1)

#define DEBUG_IN_GetValue()         _RA7

#define DEBUG_IN_SetDigitalInput()  (_TRISA7 = 1)

#define DEBUG_IN_SetDigitalOutput() (_TRISA7 = 0)

#define BEAM_SetHigh()          (_LATA8 = 1)

#define BEAM_SetLow()           (_LATA8 = 0)

#define BEAM_Toggle()           (_LATA8 ^= 1)

#define BEAM_GetValue()         _RA8

#define BEAM_SetDigitalInput()  (_TRISA8 = 1)

#define BEAM_SetDigitalOutput() (_TRISA8 = 0)

#define JETSON_HEARTBEAT_SetHigh()          (_LATA9 = 1)

#define JETSON_HEARTBEAT_SetLow()           (_LATA9 = 0)

#define JETSON_HEARTBEAT_Toggle()           (_LATA9 ^= 1)

#define JETSON_HEARTBEAT_GetValue()         _RA9

#define JETSON_HEARTBEAT_SetDigitalInput()  (_TRISA9 = 1)

#define JETSON_HEARTBEAT_SetDigitalOutput() (_TRISA9 = 0)

#define ICSP_PGED_SetHigh()          (_LATB0 = 1)

#define ICSP_PGED_SetLow()           (_LATB0 = 0)

#define ICSP_PGED_Toggle()           (_LATB0 ^= 1)

#define ICSP_PGED_GetValue()         _RB0

#define ICSP_PGED_SetDigitalInput()  (_TRISB0 = 1)

#define ICSP_PGED_SetDigitalOutput() (_TRISB0 = 0)

#define ISCP_PGEC_SetHigh()          (_LATB1 = 1)

#define ISCP_PGEC_SetLow()           (_LATB1 = 0)

#define ISCP_PGEC_Toggle()           (_LATB1 ^= 1)

#define ISCP_PGEC_GetValue()         _RB1

#define ISCP_PGEC_SetDigitalInput()  (_TRISB1 = 1)

#define ISCP_PGEC_SetDigitalOutput() (_TRISB1 = 0)

#define POWER_BUTTON_SetHigh()          (_LATB10 = 1)

#define POWER_BUTTON_SetLow()           (_LATB10 = 0)

#define POWER_BUTTON_Toggle()           (_LATB10 ^= 1)

#define POWER_BUTTON_GetValue()         _RB10

#define POWER_BUTTON_SetDigitalInput()  (_TRISB10 = 1)

#define POWER_BUTTON_SetDigitalOutput() (_TRISB10 = 0)

#define PWM_IR_SetHigh()          (_LATB11 = 1)

#define PWM_IR_SetLow()           (_LATB11 = 0)

#define PWM_IR_Toggle()           (_LATB11 ^= 1)

#define PWM_IR_GetValue()         _RB11

#define PWM_IR_SetDigitalInput()  (_TRISB11 = 1)

#define PWM_IR_SetDigitalOutput() (_TRISB11 = 0)

#define BI_LED_GREEN_SetHigh()          (_LATB12 = 1)

#define BI_LED_GREEN_SetLow()           (_LATB12 = 0)

#define BI_LED_GREEN_Toggle()           (_LATB12 ^= 1)

#define BI_LED_GREEN_GetValue()         _RB12

#define BI_LED_GREEN_SetDigitalInput()  (_TRISB12 = 1)

#define BI_LED_GREEN_SetDigitalOutput() (_TRISB12 = 0)

#define BI_LED_RED_SetHigh()          (_LATB13 = 1)

#define BI_LED_RED_SetLow()           (_LATB13 = 0)

#define BI_LED_RED_Toggle()           (_LATB13 ^= 1)

#define BI_LED_RED_GetValue()         _RB13

#define BI_LED_RED_SetDigitalInput()  (_TRISB13 = 1)

#define BI_LED_RED_SetDigitalOutput() (_TRISB13 = 0)

#define DEBUG_RX_SetHigh()          (_LATB14 = 1)

#define DEBUG_RX_SetLow()           (_LATB14 = 0)

#define DEBUG_RX_Toggle()           (_LATB14 ^= 1)

#define DEBUG_RX_GetValue()         _RB14

#define DEBUG_RX_SetDigitalInput()  (_TRISB14 = 1)

#define DEBUG_RX_SetDigitalOutput() (_TRISB14 = 0)

#define DEBUG_TX_SetHigh()          (_LATB15 = 1)

#define DEBUG_TX_SetLow()           (_LATB15 = 0)

#define DEBUG_TX_Toggle()           (_LATB15 ^= 1)

#define DEBUG_TX_GetValue()         _RB15

#define DEBUG_TX_SetDigitalInput()  (_TRISB15 = 1)

#define DEBUG_TX_SetDigitalOutput() (_TRISB15 = 0)

#define SDA_LOCAL_SetHigh()          (_LATB2 = 1)

#define SDA_LOCAL_SetLow()           (_LATB2 = 0)

#define SDA_LOCAL_Toggle()           (_LATB2 ^= 1)

#define SDA_LOCAL_GetValue()         _RB2

#define SDA_LOCAL_SetDigitalInput()  (_TRISB2 = 1)

#define SDA_LOCAL_SetDigitalOutput() (_TRISB2 = 0)

#define SCL__LOCAL_SetHigh()          (_LATB3 = 1)

#define SCL__LOCAL_SetLow()           (_LATB3 = 0)

#define SCL__LOCAL_Toggle()           (_LATB3 ^= 1)

#define SCL__LOCAL_GetValue()         _RB3

#define SCL__LOCAL_SetDigitalInput()  (_TRISB3 = 1)

#define SCL__LOCAL_SetDigitalOutput() (_TRISB3 = 0)

#define FRONT_LASER_PWM_SetHigh()          (_LATB4 = 1)

#define FRONT_LASER_PWM_SetLow()           (_LATB4 = 0)

#define FRONT_LASER_PWM_Toggle()           (_LATB4 ^= 1)

#define FRONT_LASER_PWM_GetValue()         _RB4

#define FRONT_LASER_PWM_SetDigitalInput()  (_TRISB4 = 1)

#define FRONT_LASER_PWM_SetDigitalOutput() (_TRISB4 = 0)

#define SDA_JETSON_SetHigh()          (_LATB5 = 1)

#define SDA_JETSON_SetLow()           (_LATB5 = 0)

#define SDA_JETSON_Toggle()           (_LATB5 ^= 1)

#define SDA_JETSON_GetValue()         _RB5

#define SDA_JETSON_SetDigitalInput()  (_TRISB5 = 1)

#define SDA_JETSON_SetDigitalOutput() (_TRISB5 = 0)

#define SCL_JETSON_SetHigh()          (_LATB6 = 1)

#define SCL_JETSON_SetLow()           (_LATB6 = 0)

#define SCL_JETSON_Toggle()           (_LATB6 ^= 1)

#define SCL_JETSON_GetValue()         _RB6

#define SCL_JETSON_SetDigitalInput()  (_TRISB6 = 1)

#define SCL_JETSON_SetDigitalOutput() (_TRISB6 = 0)

#define INTERRUPT_FROM_JETSON_SetHigh()          (_LATB7 = 1)

#define INTERRUPT_FROM_JETSON_SetLow()           (_LATB7 = 0)

#define INTERRUPT_FROM_JETSON_Toggle()           (_LATB7 ^= 1)

#define INTERRUPT_FROM_JETSON_GetValue()         _RB7

#define INTERRUPT_FROM_JETSON_SetDigitalInput()  (_TRISB7 = 1)

#define INTERRUPT_FROM_JETSON_SetDigitalOutput() (_TRISB7 = 0)

#define INTERRUPT_TO_JETSON_SetHigh()          (_LATB8 = 1)

#define INTERRUPT_TO_JETSON_SetLow()           (_LATB8 = 0)

#define INTERRUPT_TO_JETSON_Toggle()           (_LATB8 ^= 1)

#define INTERRUPT_TO_JETSON_GetValue()         _RB8

#define INTERRUPT_TO_JETSON_SetDigitalInput()  (_TRISB8 = 1)

#define INTERRUPT_TO_JETSON_SetDigitalOutput() (_TRISB8 = 0)

#define RED_LED_ON_SetHigh()          (_LATB9 = 1)

#define RED_LED_ON_SetLow()           (_LATB9 = 0)

#define RED_LED_ON_Toggle()           (_LATB9 ^= 1)

#define RED_LED_ON_GetValue()         _RB9

#define RED_LED_ON_SetDigitalInput()  (_TRISB9 = 1)

#define RED_LED_ON_SetDigitalOutput() (_TRISB9 = 0)

#define UPS_STATE_SetHigh()          (_LATC0 = 1)

#define UPS_STATE_SetLow()           (_LATC0 = 0)

#define UPS_STATE_Toggle()           (_LATC0 ^= 1)

#define UPS_STATE_GetValue()         _RC0

#define UPS_STATE_SetDigitalInput()  (_TRISC0 = 1)

#define UPS_STATE_SetDigitalOutput() (_TRISC0 = 0)

#define JETSON_5V_ON_SetHigh()          (_LATC1 = 1)

#define JETSON_5V_ON_SetLow()           (_LATC1 = 0)

#define JETSON_5V_ON_Toggle()           (_LATC1 ^= 1)

#define JETSON_5V_ON_GetValue()         _RC1

#define JETSON_5V_ON_SetDigitalInput()  (_TRISC1 = 1)

#define JETSON_5V_ON_SetDigitalOutput() (_TRISC1 = 0)

#define REAR_LASER_PWM_SetHigh()          (_LATC2 = 1)

#define REAR_LASER_PWM_SetLow()           (_LATC2 = 0)

#define REAR_LASER_PWM_Toggle()           (_LATC2 ^= 1)

#define REAR_LASER_PWM_GetValue()         _RC2

#define REAR_LASER_PWM_SetDigitalInput()  (_TRISC2 = 1)

#define REAR_LASER_PWM_SetDigitalOutput() (_TRISC2 = 0)

#define BALL_DETECT_INT_SetHigh()          (_LATC3 = 1)

#define BALL_DETECT_INT_SetLow()           (_LATC3 = 0)

#define BALL_DETECT_INT_Toggle()           (_LATC3 ^= 1)

#define BALL_DETECT_INT_GetValue()         _RC3

#define BALL_DETECT_INT_SetDigitalInput()  (_TRISC3 = 1)

#define BALL_DETECT_INT_SetDigitalOutput() (_TRISC3 = 0)

#define BOOT_LOADER_TX_SetHigh()          (_LATC4 = 1)

#define BOOT_LOADER_TX_SetLow()           (_LATC4 = 0)

#define BOOT_LOADER_TX_Toggle()           (_LATC4 ^= 1)

#define BOOT_LOADER_TX_GetValue()         _RC4

#define BOOT_LOADER_TX_SetDigitalInput()  (_TRISC4 = 1)

#define BOOT_LOADER_TX_SetDigitalOutput() (_TRISC4 = 0)

#define BOOT_LOADER_RX_SetHigh()          (_LATC5 = 1)

#define BOOT_LOADER_RX_SetLow()           (_LATC5 = 0)

#define BOOT_LOADER_RX_Toggle()           (_LATC5 ^= 1)

#define BOOT_LOADER_RX_GetValue()         _RC5

#define BOOT_LOADER_RX_SetDigitalInput()  (_TRISC5 = 1)

#define BOOT_LOADER_RX_SetDigitalOutput() (_TRISC5 = 0)

#define LOCAL_STATUS_LED_SetHigh()          (_LATC6 = 1)

#define LOCAL_STATUS_LED_SetLow()           (_LATC6 = 0)

#define LOCAL_STATUS_LED_Toggle()           (_LATC6 ^= 1)

#define LOCAL_STATUS_LED_GetValue()         _RC6

#define LOCAL_STATUS_LED_SetDigitalInput()  (_TRISC6 = 1)

#define LOCAL_STATUS_LED_SetDigitalOutput() (_TRISC6 = 0)

#define VER_0_SetHigh()          (_LATC7 = 1)

#define VER_0_SetLow()           (_LATC7 = 0)

#define VER_0_Toggle()           (_LATC7 ^= 1)

#define VER_0_GetValue()         _RC7

#define VER_0_SetDigitalInput()  (_TRISC7 = 1)

#define VER_0_SetDigitalOutput() (_TRISC7 = 0)

#define VER_1_SetHigh()          (_LATC8 = 1)

#define VER_1_SetLow()           (_LATC8 = 0)

#define VER_1_Toggle()           (_LATC8 ^= 1)

#define VER_1_GetValue()         _RC8

#define VER_1_SetDigitalInput()  (_TRISC8 = 1)

#define VER_1_SetDigitalOutput() (_TRISC8 = 0)

#define VER_2_SetHigh()          (_LATC9 = 1)

#define VER_2_SetLow()           (_LATC9 = 0)

#define VER_2_Toggle()           (_LATC9 ^= 1)

#define VER_2_GetValue()         _RC9

#define VER_2_SetDigitalInput()  (_TRISC9 = 1)

#define VER_2_SetDigitalOutput() (_TRISC9 = 0)

void PIN_MANAGER_Initialize (void);

void CN_CallBack(void);

void CN_SetInterruptHandler(void (* InterruptHandler)(void));

void __attribute__((deprecated("\nThis will be removed in future MCC releases. \nUse CN_SetInterruptHandler instead."))) CN_SetIOCInterruptHandler(void *handler);

#endif
