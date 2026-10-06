@echo off
REM ===========================================================================
REM  release_build.bat - thin wrapper around release_build.py
REM
REM  The build logic moved to Python on 2026-10-06. It needs a C header parsed,
REM  file timestamps compared across directories and conditional publishing;
REM  batch can do all of that but not safely, and this is also a step towards
REM  building on Linux. This file exists so the command you type is unchanged.
REM
REM  Everything - what gets built, how it is named, where it goes - is in
REM  release_build.py next to this file.
REM ===========================================================================
setlocal

python "%~dp0release_build.py" %*
set "_RC=%ERRORLEVEL%"

if not "%_RC%"=="0" (
    echo.
    echo release_build.py exited with code %_RC%
)

endlocal & exit /b %_RC%
