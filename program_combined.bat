@echo off
REM ===========================================================================
REM program_combined.bat  -  ICSP a combined bootloader+app hex, no project
REM
REM   program_combined.bat                      <- newest combined_*.hex here
REM   program_combined.bat <file.hex>
REM
REM Uses MPLAB IPE's command line (ipecmd.exe) directly, so there is nothing to
REM import and no project to keep in step with the hex. The combined image is
REM the output of combine_hex.bat and belongs to none of the three projects,
REM which is exactly why wrapping it in one is awkward.
REM
REM IMPORTANT: MPLAB X IDE and IPE cannot both hold the programmer. Close any
REM debug session in the IDE (or the IDE itself) before running this, or you
REM get a "tool in use / cannot connect" failure.
REM
REM Flags used:
REM   -TPPK4     tool is a PICkit 4     (the projects use "pk4hybrid")
REM   -P<dev>    target device
REM   -F<file>   image to programme
REM   -M         programme the entire device (memory regions from the hex)
REM   -OL        release from reset when finished, so the board runs
REM
REM If your programmer is an ICD4 rather than a PICkit 4, change TOOL to ICD4.
REM ===========================================================================

setlocal

set "IPECMD=C:\Program Files\Microchip\MPLABX\v6.25\mplab_platform\mplab_ipe\ipecmd.exe"
set "DEVICE=24FJ64GA004"
set "TOOL=PK4"

if not exist "%IPECMD%" ( echo ERROR: ipecmd not found at "%IPECMD%" & exit /b 1 )

REM ---- pick the image: argument, else the newest combined_*.hex beside this
if not "%~1"=="" (
    set "IMAGE=%~1"
) else (
    set "IMAGE="
    for /f "delims=" %%F in ('dir /b /o-d "%~dp0combined_*.hex" 2^>nul') do (
        if not defined IMAGE set "IMAGE=%~dp0%%F"
    )
)

if "%IMAGE%"=="" (
    echo ERROR: no image given and no combined_*.hex found in %~dp0
    echo        run combine_hex.bat first, e.g.  combine_hex.bat RGS_BringUp.X
    exit /b 1
)
if not exist "%IMAGE%" ( echo ERROR: image not found: "%IMAGE%" & exit /b 1 )

echo tool   : %TOOL%
echo device : %DEVICE%
echo image  : %IMAGE%
echo.
echo "%IPECMD%" -TP%TOOL% -P%DEVICE% -F"%IMAGE%" -M -OL
echo.

"%IPECMD%" -TP%TOOL% -P%DEVICE% -F"%IMAGE%" -M -OL
if errorlevel 1 (
    echo.
    echo ERROR: programming failed.
    echo   - is MPLAB X IDE holding the programmer? close it and retry
    echo   - is the target powered? a PICkit 4 will not power this board
    echo   - wrong TOOL? set TOOL=ICD4 at the top of this file for an ICD4
    exit /b 1
)

echo.
echo Programmed OK: %IMAGE%
echo The persistent store at 0xA000-0xA7FF was left erased, so the first
echo RGS_BringUp run will provision it.
endlocal
