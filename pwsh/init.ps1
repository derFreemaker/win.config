if ($Global:USERCONFIG_FREEMAKER_INIT -eq 1) {
    exit
}

if ($null -ne $env:USERCONFIG_FREEMAKER_PORTABLE) {
    if (!(Test-Path -Path $env:DRIVE_FREEMAKER_PORTABLE)) {
        Write-Warning "portable was still active!"
        . "$PSScriptRoot/../portable/cleanup.ps1"
        $cleanup = "executed"
    }
}

if ($null -ne $env:ChocolateyInstall) {
    Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}
else {
    . "$env:USERCONFIG_FREEMAKER/scripts/Update-SessionEnvironment.ps1"
}

if ($null -ne $cleanup) {
    Update-SessionEnvironment
}

if ($null -ne $env:USERCONFIG_FREEMAKER_PORTABLE) {
    Write-Warning "portable mode is active!"
    . "$PSScriptRoot/portable/init.ps1"
} else {
    . "$PSScriptRoot/core_init.ps1"
}

$Global:USERCONFIG_FREEMAKER_INIT = 1
