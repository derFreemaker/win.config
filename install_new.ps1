$driveLetter = $pwd.drive.name + ":"
$Global:DriveLetter = $driveLetter

$env:PATH = "$PSScriptRoot/lua/;" + $env:PATH
Invoke-Expression "$PSScriptRoot/lua-config/bin/lua-config.bat device --install"
