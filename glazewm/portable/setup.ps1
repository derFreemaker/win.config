Write-Output "copying window manager config..."
New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr/glazewm" -Force
Copy-Item -Path "$env:USERCONFIG_FREEMAKER_PORTABLE/glazewm/config.yaml" -Destination "$env:USERPROFILE/.glzr/glazewm/config.yaml" -Force

Start-Process -FilePath "$env:DRIVE_FREEMAKER_PORTABLE/Tools/GlazeWM/glazewm.exe"
