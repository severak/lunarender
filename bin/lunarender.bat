@ECHO OFF
REM passes command line args to lunarender.lua
SETLOCAL
SET _BIN=%~dp0
%_BIN%lua %_BIN%lunarender.lua %*