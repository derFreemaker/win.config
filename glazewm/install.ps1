Write-Host "installing glazewm..."

Invoke-Expression "winget install glazewm"
Invoke-Expression "winget uninstall zebar"

if (Test-Path -Path "$env:USERPROFILE/.glzr") {
    Remove-Item -Path "$env:USERPROFILE/.glzr" -Recurse -Force
}
