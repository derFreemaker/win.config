if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

if ($null -ne $env:USERCONFIG_FREEMAKER_PORTABLE) {
    Write-Warning "portable modus is still active!"
    Write-Warning "This is NOT the portable terminal."
}

. "$PSScriptRoot/core_init.ps1"

$Global:USERCONFIG_FREEMAKER_INIT = 1
