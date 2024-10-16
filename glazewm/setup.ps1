Write-Host "setting up glazewm..."

New-Item -ItemType Directory -Path "$env:USERPROFILE/.glzr" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE/.glzr/glazewm" -Value "$env:USERCONFIG_FREEMAKER/glazewm" -Force
