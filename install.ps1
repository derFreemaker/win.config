#Requires -RunAsAdministrator

Write-Warning "setting up enviorment variables..."

if ([Environment]::GetEnvironmentVariable("USERCONFIG", "User") -isnot [string])
{
    [Environment]::SetEnvironmentVariable("USERCONFIG", "$env:USERPROFILE\.config", "User")
}

Write-Warning "installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Warning "installing oh-my-posh..."
Invoke-Expression 'winget install JanDeDobbeleer.OhMyPosh -s winget'
Copy-Item -Path "$env:USERCONFIG\pwsh\entry.ps1" -Destination $PROFILE

Write-Warning "installing modules..."
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSReadLine -Force
Write-Warning "setted up terminal!"

# Invoke-Expression "$env:USERCONFIG\pwsh\addAliases.ps1"

Write-Warning "loading powershell profile..."
Invoke-Expression ". $PROFILE"

Write-Warning "setting up some tools..."
Invoke-Expression 'choco install gsudo make -y'

# Write-Warning "setting up neovim..."
# Invoke-Expression 'choco install ripgrep fd nodejs.install neovim -y'

# Write-Warning "adding config..."
# if (!(Test-Path -Path "$env:LOCALAPPDATA\nvim"))
# {
#   New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
# }
# Copy-Item -Path "$env:USERCONFIG\nvim\entry.lua" -Destination "$env:LOCALAPPDATA\nvim\init.lua"

# Write-Warning "setted up neovim"

Write-Warning "finished!"
