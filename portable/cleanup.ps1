Write-Output "cleaning up..."

. "$PSScriptRoot/../utils.ps1"

Remove-From-ENV -VariableName "PATH" -Value $env:PATH_PROTABLE
Set-ENV -VariableName "PATH_PORTABLE"

Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE"
Set-ENV -VariableName "DRIVE_FREEMAKER_PORTABLE"
