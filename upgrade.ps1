#Requires -RunAsAdministrator
. .\utils.ps1

Write-Output "upgrading all chocolatey packages..."
Invoke-Expression "choco upgrade all -y"

. .\pwsh\upgrade.ps1

. .\tools\upgrade.ps1

Write-Output "refresh session environment..."
Update-SessionEnvironment

Write-Host "complete!"
