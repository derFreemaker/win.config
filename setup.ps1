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

. .\pwsh\setup.ps1

. .\nvim\setup.ps1

Write-Host "reloading profile..."
Invoke-Expression ". $PROFILE"