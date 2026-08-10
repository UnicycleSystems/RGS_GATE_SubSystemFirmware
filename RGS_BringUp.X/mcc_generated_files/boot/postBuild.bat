REM Give all arguments a more readable local variable name
Set compilerDir=%1
Set projectDir=%~2
Set imageDir=%~3
Set imageName=%~4
Set isDebug=%5

REM Local Variables
Set reset=[0m
Set cyan=[46m

if %isDebug%=="true" (
echo %cyan% NOTE: You have built in DEBUG mode, therefore a .hex file was not generated. If you would like to generate a .hex file, please build in production mode. For more information, please open MCC and click on the question mark symbol next to the 16-bit Bootloader Library under Resource Management. %reset%
exit 0
)

hexmate r0-47FF,"%projectDir%\%imageDir%\%imageName%" r4808-FFFFFFFF,"%projectDir%\%imageDir%\%imageName%" -O"%projectDir%\%imageDir%\temp_original_copy.X.production.hex" -FILL=w1:0x00,0x00,0x00,0x00@0x4800:0x4807
REM RGS: the CRC/FILL range below MUST match BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH
REM in boot_config.h. Byte address = 2 x PC address, and the instruction at the
REM top of the range occupies 4 bytes, so PC 0x9FFE -> bytes 0x13FFC-0x13FFF and
REM the range ends 0x13FFF. It was 0x14FFF (PC 0xA7FE) before the application
REM region was shortened to make room for the persistent flash banks; leaving it
REM stale makes postBuild checksum blank words the header does not cover, and the
REM bootloader then rejects the image with a CRC mismatch.
hexmate r4800-FFFFFFFF,"%projectDir%\%imageDir%\temp_original_copy.X.production.hex" -O"%projectDir%\%imageDir%\temp_crc.X.production.hex" -FILL=w1:0xFF,0xFF,0xFF,0x00@0x4800:0x13FFF +-CK=4800-13FFF@15000w-4g5p814141AB
hexmate r15000-15001s-10800,"%projectDir%\%imageDir%\temp_crc.X.production.hex" r15002-15003s-107FE,"%projectDir%\%imageDir%\temp_crc.X.production.hex" r4806-FFFFFFFF,"%projectDir%\%imageDir%\%imageName%" r4802-4803,"%projectDir%\%imageDir%\%imageName%" r0-47FF,"%projectDir%\%imageDir%\%imageName%" -O"%projectDir%\%imageDir%\%imageName%"
del "%projectDir%\%imageDir%\temp_original_copy.X.production.hex"
del "%projectDir%\%imageDir%\temp_crc.X.production.hex"