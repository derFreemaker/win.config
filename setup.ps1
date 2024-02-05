. .\utils.ps1

$currentDir = Get-Location
$currentDirPath = $currentDir.Path

Write-Output "Current Directory: $currentDirPath"

Write-Host "setting up enviorment variables..."

# user config
Set-ENV -VariableName "USERCONFIG" -Value "$env:USERPROFILE\.config", "User"
$env:USERCONFIG = "$env:USERPROFILE\.config"

# user scripts
Add-ENV -VariableName "Path" -Value "$env:USERCONFIG\scripts"
$env:PATH = "$env:PATH;$env:USERCONFIG\scripts"

Invoke-Expression ".\pwsh\setup.ps1"

Write-Host "reloading enviorment..."
Invoke-Expression "refreshenv"
