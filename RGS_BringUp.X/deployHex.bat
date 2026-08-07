@echo off
REM Copy the built production hex into the shared firmware drop, named by
REM build configuration and firmware revision:
REM
REM   C:\SubSystemFirmware\BatteryConfigBuilds\<conf>\RGS_BATT_<conf>_<MSB>_<LSB>.hex
REM
REM Runs as the (last) post-build step of both configurations. For the
REM bootloadable "default" build it MUST run after postBuild.bat, which is
REM what CRC-signs the image - copying before that would drop an unsigned
REM hex the bootloader will reject.
REM
REM Args: %1 projectDir  %2 imageDir  %3 imageName  %4 confName  %5 isDebug

setlocal

set projectDir=%~1
set imageDir=%~2
set imageName=%~3
set confName=%~4
set isDebug=%~5

set dropRoot=C:\SubSystemFirmware\BatteryConfigBuilds
set versionFile=%projectDir%\firmware_version.h

if "%isDebug%"=="true" (
  echo [deployHex] Debug build - no hex produced, nothing to drop.
  exit /b 0
)

REM Firmware revision is the single source of truth in firmware_version.h
set MSB=
set LSB=
for /f "tokens=3" %%a in ('findstr /c:"define FIRMWARE_REV_MSB" "%versionFile%"') do set MSB=%%a
for /f "tokens=3" %%a in ('findstr /c:"define FIRMWARE_REV_LSB" "%versionFile%"') do set LSB=%%a

if "%MSB%"=="" (
  echo [deployHex] ERROR: FIRMWARE_REV_MSB not found in "%versionFile%"
  exit /b 1
)
if "%LSB%"=="" (
  echo [deployHex] ERROR: FIRMWARE_REV_LSB not found in "%versionFile%"
  exit /b 1
)

set srcHex=%projectDir%\%imageDir%\%imageName%
if not exist "%srcHex%" (
  echo [deployHex] ERROR: built hex not found: "%srcHex%"
  exit /b 1
)

set outDir=%dropRoot%\%confName%
if not exist "%outDir%" mkdir "%outDir%"
if not exist "%outDir%" (
  echo [deployHex] ERROR: could not create "%outDir%"
  exit /b 1
)

set outName=RGS_BATT_%confName%_%MSB%_%LSB%.hex

REM Fail the build rather than leave a stale hex in the drop: flashing an
REM out-of-date image because a copy silently failed is the worse outcome.
copy /Y "%srcHex%" "%outDir%\%outName%" >nul
if errorlevel 1 (
  echo [deployHex] ERROR: copy failed to "%outDir%\%outName%"
  echo [deployHex]        ^(file open elsewhere, or drop directory not writable?^)
  exit /b 1
)

echo [deployHex] %outDir%\%outName%
exit /b 0
