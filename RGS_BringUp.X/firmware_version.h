#ifndef FIRMWARE_VERSION_H
#define FIRMWARE_VERSION_H


/* Bring-up jig firmware, NOT the shipping application. Major rev 9 marks
 * every RGS_BringUp build so a unit running the jig is unmistakable over
 * the Jetson's EEPROM interface (main.c publishes these bytes); the product
 * app in RGS_PuttingGate.X keeps major rev 0. */
#define FIRMWARE_REV_MSB        3
#define FIRMWARE_REV_LSB        1

#endif /* FIRMWARE_VERSION_H */
