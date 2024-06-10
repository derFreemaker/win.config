if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

. "$PSScriptRoot/../../utils.ps1"
. "$PSScriptRoot/../../scripts/load.ps1"

if ($null -eq $env:USERCONFIG_FREEMAKER_PORTABLE) {
    . "$PSScriptRoot/../../portable/setup.ps1"
}

Update-SessionEnvironment

$env:USERCONFIG_FREEMAKER = $env:USERCONFIG_FREEMAKER_PORTABLE

$env:ChocolateyInstall = "$env:DRIVE_FREEMAKER_PORTABLE\Tools\Chocolatey"
# $env:Path = "$env:ChocolateyInstall\bin;$env:Path"

. "$PSScriptRoot/../core_init.ps1"

$Global:USERCONFIG_FREEMAKER_INIT = 1
