Write-Host "install powertoys..."

Invoke-Expression "winget install microsoft.powertoys"

. ".\powertoys\plugins\everything\install.ps1"
. ".\powertoys\plugins\chatgpt\install.ps1"
