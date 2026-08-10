@echo off
REM ===========================================================================
REM combine_hex.bat  -  build a single ICSP image: Bootloader_V2 + one app
REM
REM   combine_hex.bat RGS_BringUp.X [output.hex]
REM   combine_hex.bat PuttingGate.X [output.hex]
REM
REM Produces a hex that programmes the bootloader AND the application in one
REM ICSP pass. On power-up the bootloader verifies the app, sets its handoff
REM magic and resets into it, so the unit runs the app immediately while the
REM bootloader stays resident for later UART updates.
REM
REM Both projects must have been built in the "default" (bootloadable)
REM configuration. "standalone" links from 0x200 and has no application
REM header - it would collide with the bootloader.
REM
REM ---------------------------------------------------------------------------
REM ADDRESS RANGES. hexmate works in BYTE addresses; on PIC24 a byte address is
REM 2x the PC address, and each instruction occupies 4 bytes.
REM
REM   PC 0x0000-0x23FF  ->  bytes r0-47FF        bootloader + vectors
REM   PC 0x2400-0x9FFE  ->  bytes r4800-13FFF    application image
REM   PC 0xA000-0xA7FF  ->  bytes 14000-14FFF    PERSISTENT STORE - omitted
REM                                              from BOTH inputs on purpose so
REM                                              it programmes ERASED and the
REM                                              first bring-up run provisions it
REM   PC 0xA800-0xABFE  ->  bytes r15000-...     reserved + CONFIG1/CONFIG2,
REM                                              taken from the BOOTLOADER,
REM                                              which owns the fuses
REM
REM The 0x9FFE boundary must match BOOT_CONFIG_PROGRAMMABLE_ADDRESS_HIGH in
REM boot_config.h. If that ever changes, update r4800-13FFF here, the CRC range
REM in postBuild.bat, and rebuild - three places, no shared constant.
REM ===========================================================================

setlocal

if "%~1"=="" (
    echo Usage: combine_hex.bat ^<AppProject.X^> [output.hex]
    echo    e.g. combine_hex.bat RGS_BringUp.X
    exit /b 1
)

set "APPPROJ=%~1"
set "ROOT=%~dp0"
set "HEXMATE=C:\Program Files\Microchip\MPLABX\v6.25\mplab_platform\bin\hexmate.exe"
set "BL=%ROOT%Bootloader_V2.X\dist\default\production\Bootloader_V2.X.production.hex"
set "APP=%ROOT%%APPPROJ%\dist\default\production\%APPPROJ:.X=%.X.production.hex"

if "%~2"=="" (
    set "OUT=%ROOT%combined_%APPPROJ:.X=%.hex"
) else (
    set "OUT=%~2"
)

if not exist "%HEXMATE%" ( echo ERROR: hexmate not found at "%HEXMATE%" & exit /b 1 )
if not exist "%BL%"      ( echo ERROR: bootloader hex not found: "%BL%"   & echo        build Bootloader_V2.X ^(default^) first & exit /b 1 )
if not exist "%APP%"     ( echo ERROR: application hex not found: "%APP%" & echo        build %APPPROJ% in the "default" configuration first & exit /b 1 )

echo bootloader : %BL%
echo application: %APP%
echo output     : %OUT%

"%HEXMATE%" r0-47FF,"%BL%" r4800-13FFF,"%APP%" r15000-FFFFFFFF,"%BL%" -O"%OUT%"
if errorlevel 1 ( echo ERROR: hexmate failed & exit /b 1 )

echo.
echo Combined image written: %OUT%
echo Programme it with ICSP. The persistent store at 0xA000-0xA7FF is left
echo erased, so the first RGS_BringUp run will provision it.
endlocal
