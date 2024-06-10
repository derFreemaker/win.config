Write-Output "cleaning up..."

. "$PSScriptRoot/../utils.ps1"

foreach ($value in $env:PATH_PORTABLE -split ";") {
    Remove-From-ENV -VariableName "PATH" -Value $value
}
Set-ENV -VariableName "PATH_PORTABLE" -Value $null

Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE" -Value $null
Set-ENV -VariableName "DRIVE_FREEMAKER_PORTABLE" -Value $null
