if ($Global:USERCONFIG_FREEMAKER_PORTABLE_INIT -eq 1) {
    exit
}

if ($null -eq $env:USERCONFIG_FREEMAKER_PORTABLE) {
    . "$PSScriptRoot/../portable/setup.ps1"
}

. "$PSScriptRoot/../core_init.ps1"

$Global:USERCONFIG_FREEMAKER_PORTABLE_INIT = 1