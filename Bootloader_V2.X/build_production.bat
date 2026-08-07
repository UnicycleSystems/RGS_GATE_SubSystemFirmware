@echo off
REM Builds the PRODUCTION bootloader image, and produces a version-stamped copy
REM RGS_PG_BOOT_<MSB>_<LSB>.hex (version read from firmware_version.h).
REM Double-click me or run from a terminal.

cd /d "%~dp0"

set MAKE=C:\Program Files\Microchip\MPLABX\v6.05\gnuBins\GnuWin32\bin\make.exe
if not exist "%MAKE%" set MAKE=C:\Program Files\Microchip\MPLABX\v6.25\gnuBins\GnuWin32\bin\make.exe
if not exist "%MAKE%" (
    echo ERROR: MPLAB X make.exe not found -- edit MAKE path in this script.
    exit /b 1
)

echo *** Cleaning (forcing a full rebuild) ***
"%MAKE%" CONF=default TYPE_IMAGE=PRODUCTION_IMAGE clean

"%MAKE%" CONF=default TYPE_IMAGE=PRODUCTION_IMAGE
if errorlevel 1 (
    echo.
    echo *** BUILD FAILED ***
    exit /b 1
)

echo.
echo *** Production hex ready: ***
dir "dist\default\production\Bootloader_V2.X.production.hex" | findstr /i production

REM ---- version-stamped image -> staging location --------------------------
REM Version read from firmware_version.h (single source of truth). The
REM standard .production.hex stays in dist (MPLAB's own use); the versioned
REM deliverable is placed ONLY in the staging folder below.
set "DEST=c:\SubSystemFirmware\BootLoaderHex"
set "VERHDR=firmware_version.h"
set "MSB="
set "LSB="
for /f "tokens=3" %%A in ('findstr /B /C:"#define FIRMWARE_REV_MSB" "%VERHDR%"') do set "MSB=%%A"
for /f "tokens=3" %%A in ('findstr /B /C:"#define FIRMWARE_REV_LSB" "%VERHDR%"') do set "LSB=%%A"
if "%MSB%"=="" (
    echo WARNING: could not read FIRMWARE_REV_MSB from %VERHDR% -- versioned image skipped.
) else (
    if not exist "%DEST%" mkdir "%DEST%"
    copy /Y "dist\default\production\Bootloader_V2.X.production.hex" "%DEST%\RGS_PG_BOOT_%MSB%_%LSB%.hex" >nul
    echo *** Boot image staged:  %DEST%\RGS_PG_BOOT_%MSB%_%LSB%.hex ***
)
