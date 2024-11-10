@echo off

set SCRIPT_DIR=%~dp0
set PATH=%SCRIPT_DIR%lua\;%PATH%

%SCRIPT_DIR%/lua-config/bin/lua-config.bat %*
