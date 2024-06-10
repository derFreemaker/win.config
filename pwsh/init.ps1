if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

if ($null -ne $env:USERCONFIG_FREEMAKER_PORTABLE) {
    if (!(Test-Path -Path $env:DRIVE_FREEMAKER_PORTABLE)) {
        . "$PSScriptRoot/../portable/cleanup.ps1"
    }

    Write-Warning "portable mode is active"
    . "$PSScriptRoot/portable/init.ps1"
} else {    
    . "$PSScriptRoot/core_init.ps1"
}

$Global:USERCONFIG_FREEMAKER_INIT = 1
