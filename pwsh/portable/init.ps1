if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

. "$PSScriptRoot/../../utils.ps1"

if ($null -eq $env:USERCONFIG_FREEMAKER_PORTABLE) {
    . "$PSScriptRoot/../../portable/setup.ps1"
}

$env:USERCONFIG_FREEMAKER = $env:USERCONFIG_FREEMAKER_PORTABLE
$env:ChocolateyInstall = Get-ENV -VariableName "ChocolateyInstall"
$env:ChocolateyToolsLocation = Get-ENV -VariableName "ChocolateyToolsLocation"

. "$PSScriptRoot/../core_init.ps1"

$Global:USERCONFIG_FREEMAKER_INIT = 1
