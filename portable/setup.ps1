Write-Output "setting up..."

. "$PSScriptRoot/../utils.ps1"

$driveLetter = $pwd.drive.name + ":"
$Global:DriveLetter = $driveLetter

. "$driveLetter\Tools\misc\load.ps1"

# adding paths to enviorment variable ("PATH")
$paths = Get-Paths -DriveLetter $driveLetter
$paths_str = $paths -join ";"

Add-ENV -VariableName "PATH" -Value $paths_str
Set-ENV -VariableName "PATH_FREEMAKER_PORTABLE" -Value $paths_str

Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE" -Value "$driveLetter\.config"
Set-ENV -VariableName "DRIVE_FREEMAKER_PORTABLE" -Value "$driveLetter"

# window manger
. "$PSScriptRoot/../glazewm/portable/setup.ps1"
