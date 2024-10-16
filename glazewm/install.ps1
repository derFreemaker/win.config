Write-Host "installing glazewm..."

Invoke-Expression "winget install glazewm"
Invoke-Expression "winget uninstall zebar"

Remove-Item -Path "$env:USERPROFILE/.glzr" -Recurse -Force
