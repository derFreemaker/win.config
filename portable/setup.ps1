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

if (($null -eq (Get-Env -VariableName "ChocolateyInstall")) -and ($null -eq (Get-Item "$driveLetter\Tools\chocolatey"))) {
    # install Chocolatey

    Set-ENV -VariableName "ChocolateyInstall" -Value "$driveLetter\Tools\chocolatey"
    Set-ENV -VariableName "ChocolateyToolsLocation" -Value "$driveLetter\Tools\chocolateyTools"

    Write-Host "installing chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    Write-Host "reloading environment..."
}
