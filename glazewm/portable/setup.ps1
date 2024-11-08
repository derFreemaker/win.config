Write-Output "copying window manager config..."
New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr" -Force
New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr/glazewm" -Force
Copy-Item -Path "$env:USERCONFIG_FREEMAKER/glazewm/config.yaml" -Destination "$env:USERPROFILE/.glzr/glazewm/config.yaml" -Force
