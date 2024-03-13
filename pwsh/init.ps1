if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

if ($null -ne $env:USERCONFIG_FREEMAKER_PORTABLE) {
    . "$PSScriptRoot/../portable/cleanup.ps1"
}

. "$PSScriptRoot/core_init.ps1"

$Global:USERCONFIG_FREEMAKER_INIT = 1
