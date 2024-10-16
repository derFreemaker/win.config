Write-Host "uninstall glazewm..."

Invoke-Expression "winget uninstall glazewm"

Remove-Item "$env:USERPROFILE/.glzr" -Recurse -Force
Remove-Item "$env:APPDATA/Microsoft/Windows/Start Menu/Programs/Startup/GlazeWM.lnk" -Force
