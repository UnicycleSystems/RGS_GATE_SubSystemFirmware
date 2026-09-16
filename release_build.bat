@echo off
REM ===========================================================================
REM release_build.bat  -  clean-build all three projects and publish the hexes
REM
REM   release_build.bat
REM
REM Does the lot, in order:
REM
REM   0. Publishes the shared EEPROM map from CommonFiles\header to
REM      C:\SubSystemFirmware: EEpromBlockLabels.h copied as-is, and
REM      EEpromBlockLabels_h_InPython.py GENERATED from it by
REM      eeprom_header_to_python.py (needs Python 3.6+ on PATH)
REM   1. Bootloader_V2      default              -> ...\Bootloader
REM   2. RGS_BringUp        standalone + default -> ...\BringUp\Standalone
REM                                                 ...\BringUp\Default
REM   3. PuttingGate        standalone + default -> ...\PuttingGate\Standalone
REM                                                 ...\PuttingGate\Default
REM   4. Combined bootloader + BringUp default   -> ...\BringUp\Combined
REM   5. Empties C:\SubSystemFirmware\BringUp_FirstRun and puts that same
REM      combined image there - the one file a virgin board gets programmed
REM      with, so the folder must never offer a choice
REM   6. Empties C:\SubSystemFirmware\Production and puts the fresh
REM      PuttingGate DEFAULT build there
REM
REM Naming: <Project>_<CFG>_<maj>_<min>.hex, CFG = SA (standalone) or DF
REM (default), version read from each project's firmware_version.h. The
REM combined image is RGS_Boot_Bring_Uni_<boot ver>__<bringup ver>.hex, in
REM that order.
REM
REM Deliberately a separate script rather than a post-build step: building in
REM MPLAB must NOT touch C:\SubSystemFirmware. Publishing is a manual act.
REM
REM Builds are CLEAN builds driven by MPLAB's own make, so the generated
REM makefiles are regenerated from configurations.xml first - that is what
REM stops a stale Makefile-<conf>.mk silently building the wrong file list.
REM
REM NOTHING IS EVER OVERWRITTEN in the release tree. If a target file already
REM exists it is renamed <name>_prevN.hex first, N counting UP so the highest
REM number is the most recent previous copy. That matters because these folders
REM are an archive: rebuilding without bumping firmware_version.h would
REM otherwise silently replace a released image with a different binary
REM carrying the same version number.
REM   (Exceptions: C:\SubSystemFirmware\Production and BringUp_FirstRun are
REM    emptied outright, by design - each holds exactly one image and history
REM    lives in the archive. The two EEPROM map files from step 0 are simply
REM    overwritten; git keeps their history.)
REM
REM Compiler warnings are counted and listed for every build. A build FAILURE
REM aborts the whole script, so a bad build can never reach Production.
REM Full logs are kept per project+config at %TEMP%\rgs_build_*.log.
REM ===========================================================================

setlocal enabledelayedexpansion

set "ROOT=%~dp0"
set "MPLABBIN=C:\Program Files\Microchip\MPLABX\v6.25\mplab_platform\bin"
set "MAKEBIN=C:\Program Files\Microchip\MPLABX\v6.25\gnuBins\GnuWin32\bin"
set "HEXMATE=C:\Program Files\Microchip\MPLABX\v6.25\mplab_platform\bin\hexmate.exe"
set "DEST=C:\SubSystemFirmware\PreviousReleasedHexFiles"
set "PROD=C:\SubSystemFirmware\Production"
set "FIRSTRUN=C:\SubSystemFirmware\BringUp_FirstRun"
set "SUBSYS=C:\SubSystemFirmware"
set "MAPH=%ROOT%CommonFiles\header\EEpromBlockLabels.h"
set "MAPCONV=%ROOT%eeprom_header_to_python.py"

if not exist "%MAKEBIN%\make.exe" ( echo ERROR: make.exe not found in "%MAKEBIN%" & exit /b 1 )
if not exist "%HEXMATE%"          ( echo ERROR: hexmate not found: "%HEXMATE%"    & exit /b 1 )
if not exist "%MPLABBIN%\prjMakefilesGenerator.bat" ( echo ERROR: prjMakefilesGenerator not found & exit /b 1 )
if not exist "%MAPCONV%"          ( echo ERROR: converter not found: "%MAPCONV%"  & exit /b 1 )

REM Python runs the EEPROM map converter (step 0). Checked by RUNNING it, not
REM with "where": Windows ships a python.exe stub that only opens the Store.
python -c "import sys; sys.exit(0 if sys.version_info >= (3, 6) else 1)" >nul 2>&1
if errorlevel 1 ( echo ERROR: Python 3.6 or later not found on PATH - needed for step 0 & exit /b 1 )

set "PATH=%MAKEBIN%;%PATH%"

echo ============================================================
echo  RGS release build
echo ============================================================
echo.

REM ---- read the three firmware versions -------------------------------------
call :getver "%ROOT%Bootloader_V2.X\firmware_version.h" BOOTVER || exit /b 1
call :getver "%ROOT%RGS_BringUp.X\firmware_version.h"   BRINGVER || exit /b 1
call :getver "%ROOT%PuttingGate.X\firmware_version.h"   PGVER   || exit /b 1

echo   Bootloader_V2 : v%BOOTVER:_=.%
echo   RGS_BringUp   : v%BRINGVER:_=.%
echo   PuttingGate   : v%PGVER:_=.%
echo.

REM ---- 0. publish the shared EEPROM map --------------------------------------
REM EEpromBlockLabels.h is the one definition of the emulated EEPROM, shared by
REM the firmware and the Jetson. It is published from the SAME copy the builds
REM below compile, so a release's map always matches its firmware; and it goes
REM first, so a header that will not convert stops the release before minutes
REM of building rather than after.
REM
REM The .py is GENERATED, never hand-edited: the converter translates only what
REM it can translate exactly and refuses anything else, naming the line. It
REM imports its own output before replacing the old file, so a failure leaves
REM the previous copy in place.
REM
REM Both files are overwritten, not archived: scripts import the .py by that
REM name from that folder, so _prevN copies would only clutter it, and git
REM keeps the history.
echo [0] publishing EEPROM map to %SUBSYS%
if not exist "%MAPH%" ( echo     ERROR: %MAPH% not found & exit /b 1 )
python "%MAPCONV%" "%MAPH%" "%SUBSYS%\EEpromBlockLabels_h_InPython.py" >nul
if errorlevel 1 ( echo     ERROR: EEpromBlockLabels.h did not convert - see above & exit /b 1 )
copy /Y "%MAPH%" "%SUBSYS%\EEpromBlockLabels.h" >nul
if errorlevel 1 ( echo     ERROR: copy of EEpromBlockLabels.h failed & exit /b 1 )
echo     -^> %SUBSYS%\EEpromBlockLabels_h_InPython.py
echo     -^> %SUBSYS%\EEpromBlockLabels.h
echo.

REM ---- 1. Bootloader, default ------------------------------------------------
call :buildconf Bootloader_V2.X default            || exit /b 1
call :publish   Bootloader_V2.X default Bootloader_V2 DF %BOOTVER% "%DEST%\Bootloader" || exit /b 1

REM ---- 2. RGS_BringUp, both configurations -----------------------------------
call :buildconf RGS_BringUp.X standalone           || exit /b 1
call :publish   RGS_BringUp.X standalone RGS_BringUp SA %BRINGVER% "%DEST%\BringUp\Standalone" || exit /b 1
call :buildconf RGS_BringUp.X default              || exit /b 1
call :publish   RGS_BringUp.X default    RGS_BringUp DF %BRINGVER% "%DEST%\BringUp\Default"    || exit /b 1

REM ---- 3. PuttingGate, both configurations -----------------------------------
call :buildconf PuttingGate.X standalone           || exit /b 1
call :publish   PuttingGate.X standalone RGS_PuttingGate SA %PGVER% "%DEST%\PuttingGate\Standalone" || exit /b 1
call :buildconf PuttingGate.X default              || exit /b 1
call :publish   PuttingGate.X default    RGS_PuttingGate DF %PGVER% "%DEST%\PuttingGate\Default"    || exit /b 1

REM ---- 4. combined bootloader + BringUp default ------------------------------
REM Byte addresses are 2x the PC address on PIC24. r4800-13FFF is the
REM application region 0x2400-0x9FFE; 0xA000-0xA7FF (bytes 14000-14FFF) is the
REM persistent store and is taken from NEITHER input so it programmes erased;
REM r15000+ carries CONFIG1/CONFIG2 from the bootloader, which owns the fuses.
set "COMBINED=RGS_Boot_Bring_Uni_%BOOTVER%__%BRINGVER%.hex"
set "BLHEX=%ROOT%Bootloader_V2.X\dist\default\production\Bootloader_V2.X.production.hex"
set "BUHEX=%ROOT%RGS_BringUp.X\dist\default\production\RGS_BringUp.X.production.hex"

echo [4] combining bootloader + BringUp -^> %COMBINED%
if not exist "%DEST%\BringUp\Combined" mkdir "%DEST%\BringUp\Combined"
call :archive "%DEST%\BringUp\Combined\%COMBINED%" || exit /b 1
"%HEXMATE%" r0-47FF,"%BLHEX%" r4800-13FFF,"%BUHEX%" r15000-FFFFFFFF,"%BLHEX%" -O"%DEST%\BringUp\Combined\%COMBINED%"
if errorlevel 1 ( echo     ERROR: hexmate failed & exit /b 1 )
echo     -^> %DEST%\BringUp\Combined\%COMBINED%
echo.

REM ---- 5. refresh the BringUp_FirstRun folder --------------------------------
REM The same combined image as step 4, but as the ONE file a virgin board gets
REM programmed with. Emptied first for the same reason as Production below: a
REM folder that is meant to answer "which image?" must not offer a choice.
REM
REM The archive copy in step 4 keeps the history; this one is disposable and
REM always the latest, so it is deleted rather than archived.
echo [5] refreshing %FIRSTRUN%
if not exist "%FIRSTRUN%" mkdir "%FIRSTRUN%"
del /Q "%FIRSTRUN%\*" 2>nul
copy /Y "%DEST%\BringUp\Combined\%COMBINED%" "%FIRSTRUN%\%COMBINED%" >nul
if errorlevel 1 ( echo     ERROR: copy to BringUp_FirstRun failed & exit /b 1 )
echo     -^> %FIRSTRUN%\%COMBINED%
echo.

REM ---- 6. refresh the Production folder --------------------------------------
REM Emptied first, deliberately: Production holds exactly one image, the field
REM application, and a stale second file there is worse than none.
set "PGNAME=RGS_PuttingGate_DF_%PGVER%.hex"
echo [6] refreshing %PROD%
if not exist "%PROD%" mkdir "%PROD%"
del /Q "%PROD%\*" 2>nul
copy /Y "%ROOT%PuttingGate.X\dist\default\production\PuttingGate.X.production.hex" "%PROD%\%PGNAME%" >nul
if errorlevel 1 ( echo     ERROR: copy to Production failed & exit /b 1 )
echo     -^> %PROD%\%PGNAME%
echo.

echo ============================================================
echo  Release build complete.
echo    bootloader v%BOOTVER:_=.%   BringUp v%BRINGVER:_=.%   PuttingGate v%PGVER:_=.%
echo    BringUp_FirstRun now holds %COMBINED%
echo    Production       now holds %PGNAME%
echo ============================================================
endlocal
exit /b 0


REM ===========================================================================
REM :getver  <firmware_version.h>  <outvar>
REM Version text is taken LITERALLY, so an author-written leading zero
REM survives: MSB 1 / LSB 00 gives "1_00", not "1_0".
REM ===========================================================================
:getver
set "_MSB=" & set "_LSB=" & set "_NM=0" & set "_NL=0"
if not exist "%~1" ( echo ERROR: %~1 not found & exit /b 1 )

REM /B anchors the match to the START of the line, so a commented-out
REM "//#define FIRMWARE_REV_MSB 3" is no longer matched.
REM
REM Without /B, findstr matched the comment as well, the for loop assigned on
REM EVERY match, and the LAST one won - so a stale commented-out value
REM silently overrode the real one and the hex was published under a version
REM nobody had set. It went unnoticed because Bootloader_V2 has no such
REM comment, so that one file always looked right.
REM
REM Counting first, and demanding exactly one, means a second ACTIVE define
REM is an error rather than a coin toss - the compiler would take the last,
REM this used to take the last, and neither is something to rely on.
for /f %%A in ('findstr /B /C:"#define FIRMWARE_REV_MSB" "%~1" ^| find /c /v ""') do set "_NM=%%A"
for /f %%A in ('findstr /B /C:"#define FIRMWARE_REV_LSB" "%~1" ^| find /c /v ""') do set "_NL=%%A"
if not "!_NM!"=="1" ( echo ERROR: expected exactly ONE active FIRMWARE_REV_MSB in %~1 - found !_NM! & exit /b 1 )
if not "!_NL!"=="1" ( echo ERROR: expected exactly ONE active FIRMWARE_REV_LSB in %~1 - found !_NL! & exit /b 1 )

for /f "tokens=3" %%A in ('findstr /B /C:"#define FIRMWARE_REV_MSB" "%~1"') do set "_MSB=%%A"
for /f "tokens=3" %%A in ('findstr /B /C:"#define FIRMWARE_REV_LSB" "%~1"') do set "_LSB=%%A"
if "!_MSB!"=="" ( echo ERROR: could not read FIRMWARE_REV_MSB from %~1 & exit /b 1 )
if "!_LSB!"=="" ( echo ERROR: could not read FIRMWARE_REV_LSB from %~1 & exit /b 1 )
set "%~2=!_MSB!_!_LSB!"
exit /b 0

REM ===========================================================================
REM :buildconf  <Project.X>  <conf>
REM Regenerate the makefiles from configurations.xml FIRST. MPLAB does not
REM always do this itself, and a stale Makefile-<conf>.mk builds the wrong
REM file list without saying so.
REM ===========================================================================
:buildconf
echo [build] %~1  (%~2)
set "_LOG=%TEMP%\rgs_build_%~1_%~2.log"
if not exist "%ROOT%%~1\nbproject\configurations.xml" ( echo     ERROR: no such project & exit /b 1 )

REM Regenerating the makefiles is not optional - a stale Makefile-<conf>.mk
REM builds the wrong file list without complaining. Exit 0 = ok, 2 = failed.
call "%MPLABBIN%\prjMakefilesGenerator.bat" "%ROOT%%~1" >"%_LOG%" 2>&1
if errorlevel 1 (
    echo     ** MAKEFILE GENERATION FAILED ** - last 20 lines:
    powershell -NoProfile -Command "Get-Content '%_LOG%' -Tail 20"
    exit /b 1
)

pushd "%ROOT%%~1"

REM A failed clean must abort: it would leave stale objects that make happily
REM links, so the build would "succeed" without being the clean build claimed.
make.exe CONF=%~2 clean >>"%_LOG%" 2>&1
if errorlevel 1 (
    echo     ** CLEAN FAILED ** - last 20 lines:
    powershell -NoProfile -Command "Get-Content '%_LOG%' -Tail 20"
    popd
    exit /b 1
)

make.exe CONF=%~2 build >>"%_LOG%" 2>&1
if errorlevel 1 (
    echo     ** BUILD FAILED ** - last 20 lines:
    powershell -NoProfile -Command "Get-Content '%_LOG%' -Tail 20"
    popd
    exit /b 1
)
popd

REM Surface warnings. They are invisible otherwise, and an unprototyped call
REM or a discarded qualifier is exactly the sort of thing worth seeing.
set "_W=0"
for /f %%N in ('findstr /C:"warning:" "%_LOG%" ^| find /c /v ""') do set "_W=%%N"
if "!_W!"=="0" (
    echo     no warnings
) else (
    echo     !_W! warning^(s^):
    for /f "tokens=*" %%L in ('findstr /C:"warning:" "%_LOG%"') do echo        %%L
)
exit /b 0

REM ===========================================================================
REM :archive  <full path to file>
REM If the file exists, rename it <base>_prevN<ext> with the next free N, so
REM the caller can then write the new file without destroying anything.
REM N counts UP: the HIGHEST _prevN is the most recent previous copy.
REM ===========================================================================
:archive
if not exist "%~1" exit /b 0
set "_AD=%~dp1"
set "_AB=%~n1"
set "_AX=%~x1"
set /a _AN=1
:archive_next
if exist "%_AD%%_AB%_prev!_AN!%_AX%" (
    set /a _AN+=1
    goto :archive_next
)
move /Y "%~1" "%_AD%%_AB%_prev!_AN!%_AX%" >nul
if errorlevel 1 ( echo     ERROR: could not archive "%~1" & exit /b 1 )
echo     archived existing as %_AB%_prev!_AN!%_AX%
exit /b 0

REM ===========================================================================
REM :publish  <Project.X> <conf> <OutName> <SA^|DF> <ver> <destdir>
REM ===========================================================================
:publish
set "_SRC=%ROOT%%~1\dist\%~2\production\%~1.production.hex"
set "_OUT=%~3_%~4_%~5.hex"
if not exist "%_SRC%" ( echo     ERROR: built hex not found: "%_SRC%" & exit /b 1 )
if not exist "%~6" mkdir "%~6"
call :archive "%~6\%_OUT%" || exit /b 1
copy /Y "%_SRC%" "%~6\%_OUT%" >nul
if errorlevel 1 ( echo     ERROR: copy to "%~6" failed & exit /b 1 )
echo     -^> %~6\%_OUT%
exit /b 0
