#Requires -RunAsAdministrator

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDirectory = Split-Path $scriptPath -Parent

Invoke-Expression $scriptDirectory\utils.ps1

Write-Warning "setting up enviorment variables..."

Add-ENV -VariableName "Path" -Value "C:\Users\oskar\.config\scripts"
Add-ENV -VariableName "Path" -Value "C:\Program Files\CMake\bin"
Set-ENV -VariableName "USERCONFIG" -Value "$env:USERPROFILE\.config", "User"

Write-Warning "installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Warning "installing oh-my-posh..."
Invoke-Expression 'winget install JanDeDobbeleer.OhMyPosh -s winget'
Copy-Item -Path "$env:USERCONFIG\pwsh\entry.ps1" -Destination $PROFILE

Write-Warning "installing modules..."
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSReadLine -Force
Write-Warning "setted up terminal!"

Write-Warning "installing some tools..."
Invoke-Expression 'choco install make cmake gsudo ripgrep fd nodejs.install -y'

# Write-Warning "setting up neovim..."
# Invoke-Expression 'choco install neovim -y'

# Write-Warning "adding config..."
# if (!(Test-Path -Path "$env:LOCALAPPDATA\nvim"))
# {
#   New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
# }
# Copy-Item -Path "$env:USERCONFIG\nvim\entry.lua" -Destination "$env:LOCALAPPDATA\nvim\init.lua"

# Write-Warning "setted up neovim"

Write-Warning "loading powershell profile..."
Invoke-Expression ". $PROFILE"

Write-Warning "reloading enviorment..."
Invoke-Expression "refreshenv"

Write-Warning "finished!"
