#Requires -RunAsAdministrator

# Write-Warning "removing neovim..."
# Invoke-Expression 'choco uninstall neovim nodejs.install make fd ripgrep gsudo -y'

# Remove-Item -Force -Recurse "$env:LOCALAPPDATA\nvim" -ErrorAction Ignore
# Remove-Item -Force -Recurse "$env:LOCALAPPDATA\nvim-data" -ErrorAction Ignore

# Write-Warning "cleaning up path enviorment variable..."
# Remove unwanted elements
# $path = ($env:PATH.Split(';') | Where-Object { $_ -ne "C:\tools\neovim\nvim-win64\bin" }) -join ';'
# Set it
# [System.Environment]::SetEnvironmentVariable(
#     'PATH',
#     $path,
#     'User'
# )

# Write-Warning "removed neovim!"

Write-Warning "removing terminal setup..."

if (Test-Path -Path $PROFILE)
{
    Remove-Item -Path $PROFILE -ErrorAction Ignore
}

Invoke-Expression 'winget uninstall JanDeDobbeleer.OhMyPosh -s winget'
Uninstall-Module -Name Terminal-Icons
Uninstall-Module -Name PSReadLine

Write-Warning "uninstalling tools..."
Invoke-Expression 'choco uninstall gsudo make -y'

Write-Warning "removing Chocolatey..."
Remove-Item -Force -Recurse "$env:ChocolateyInstall" -ErrorAction Ignore
    
Write-Warning "removing enviorment variables..."
[Environment]::SetEnvironmentVariable("USERCONFIG", "", "User")
    
Write-Warning "finished!"
