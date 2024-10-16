#Requires -RunAsAdministrator
$CurrentDir = Get-Location

if ($CurrentDir -eq $PSScriptRoot) {
    Write-Host "going into: $PSScriptRoot"
    Set-Location $PSScriptRoot
}

. ".\utils.ps1"

. ".\chocolatey\install.ps1"

. ".\pwsh\install.ps1"

. ".\tools\install.ps1"

. ".\nvim\install.ps1"

. ".\glazewm\install.ps1"

. ".\explorer_blur\install.ps1"

Write-Output "refresh session environment..."
Update-SessionEnvironment

. ".\reg\apply_regedits.ps1"

Write-Host "complete!"

if ($CurrentDir -eq $PSScriptRoot) {
    Write-Host "going back: $CurrentDir"
    Set-Location $CurrentDir
}
