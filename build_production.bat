@echo off
REM Always builds the PRODUCTION image of the 'default' (bootloader-loadable)
REM configuration -- CRC-signed hex included -- regardless of whatever image
REM type the MPLAB X toolbar is currently latched to. Double-click me or run
REM from a terminal.

cd /d "%~dp0"

set MAKE=C:\Program Files\Microchip\MPLABX\v6.05\gnuBins\GnuWin32\bin\make.exe
if not exist "%MAKE%" set MAKE=C:\Program Files\Microchip\MPLABX\v6.25\gnuBins\GnuWin32\bin\make.exe
if not exist "%MAKE%" (
    echo ERROR: MPLAB X make.exe not found -- edit MAKE path in this script.
    exit /b 1
)

"%MAKE%" CONF=default TYPE_IMAGE=PRODUCTION_IMAGE
if errorlevel 1 (
    echo.
    echo *** BUILD FAILED ***
    exit /b 1
)

echo.
echo *** Production hex ready: ***
dir "dist\default\production\RGS_PuttingGate.X.production.hex" | findstr /i production
