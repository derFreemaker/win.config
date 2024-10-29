Write-Host "setting up glazewm..."

New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE/.glzr/glazewm" -Value (Get-Device-Directory-Path "$env:USERCONFIG_FREEMAKER/glazewm") -Force
New-Shortcut -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\GlazeWM.lnk" -Target "C:/Program Files/glzr.io/GlazeWM/glazewm.exe" -Force
