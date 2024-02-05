@echo off

echo installing powershell...

winget install --id Microsoft.Powershell --source winget
echo.

if %ERRORLEVEL% == 0 goto :complete
echo could not install powershell
echo maybe allready installed?
goto :EOS

:complete
echo installed powershell!
echo please proceed by executing install.ps1 in the installed powershell (latest: Powershell 7)

:EOS