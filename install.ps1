#Requires -RunAsAdministrator
. ".\utils.ps1"

. ".\chocolatey\install.ps1"

. ".\pwsh\install.ps1"

. ".\tools\install.ps1"

. ".\nvim\install.ps1"

. ".\glazewm\install.ps1"

Write-Output "refresh session environment..."
Update-SessionEnvironment

. ".\reg\apply_regedits.ps1"

Write-Host "complete!"
