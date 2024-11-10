@echo off

set "SCRIPT_DIR=%~dp0"

%SCRIPT_DIR%/lua-config/bin/lua-config.bat %*
