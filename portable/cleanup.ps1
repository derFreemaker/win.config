Write-Output "cleaning up..."

. "$PSScriptRoot/../utils.ps1"

$driveLetter = $pwd.drive.name + ":"
$Global:DriveLetter = $driveLetter

. "$driveLetter\Tools\misc\load.ps1"

# getting paths and removing from PATH ENV Variable
$paths = Get-Paths -DriveLetter $driveLetter
for ($i = 0; $i -lt $paths.Count; $i++) {
    Remove-From-ENV -VariableName "PATH_FREEMAKER_PORTABLE" -Value $paths[$i]
}

Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE"
