Write-Output "setting up..."

. "$PSScriptRoot/../utils.ps1"

$driveLetter = $pwd.drive.name + ":"
$Global:DriveLetter = $driveLetter

. "$driveLetter\Tools\misc\load.ps1"

# adding paths to enviorment variable ("PATH")
$paths = Get-Paths -DriveLetter $driveLetter
for ($i = 0; $i -lt $paths.Count; $i++) {
    Add-ENV -VariableName "PATH_FREEMAKER_PORTABLE" -Value $paths[$i]
}

Set-ENV -VariableName "USERCONFIG_FREEMAKER_PORTABLE" -Value "$driveLetter\.config"
Set-ENV -VariableName "TOOLS_FREEMAKER_PORTABLE" -Value "$driveLetter\Tools"

