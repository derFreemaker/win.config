Write-Host "uninstalling powertoys..."

Invoke-Expression "winget uninstall microsoft.powertoys"

. ".\powertoys\plugins\everything\uninstall.ps1"
. ".\powertoys\plugins\chatgpt\uninstall.ps1"
