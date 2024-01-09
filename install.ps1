#Requires -RunAsAdministrator

Write-Warning "setting up enviorment variables..."

if ([Environment]::GetEnvironmentVariable("USERCONFIG", "User") -isnot [string])
{
    [Environment]::SetEnvironmentVariable("USERCONFIG", "$env:USERPROFILE\.config", "User")
}

Write-Warning "installing oh-my-posh..."
Invoke-Expression 'winget install JanDeDobbeleer.OhMyPosh -s winget'
Copy-Item -Path "$env:USERCONFIG\pwsh\entry.ps1" -Destination $PROFILE

Write-Warning "installing modules..."
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSReadLine -Force
Write-Warning "setted up terminal!"

Write-Warning "adding aliases..."
function Get-GitStatus { & git status -sb $args }
function Get-GitCommit { & git commit -ev $args }
function Get-GitAdd { & git add --all $args }
function Get-GitTree { & git log --graph --oneline --decorate $args }
function Get-GitPush { & git push $args }
function Get-GitPull { & git pull $args }
function Get-GitFetch { & git fetch $args }
function Get-GitCheckout { & git checkout $args }
function Get-GitBranch { & git branch $args }
function Get-GitRemote { & git remote -v $args }
function Update-GitSubmodules { & git submodule update --remote $args }

New-Alias -Name gs -Value Get-GitStatus -Force -Option AllScope
New-Alias -Name gc -Value Get-GitCommit -Force -Option AllScope
New-Alias -Name ga -Value Get-GitAdd -Force -Option AllScope
New-Alias -Name gt -Value Get-GitTree -Force -Option AllScope
New-Alias -Name gps -Value Get-GitPush -Force -Option AllScope
New-Alias -Name gpl -Value Get-GitPull -Force -Option AllScope
New-Alias -Name gf -Value Get-GitFetch -Force -Option AllScope
New-Alias -Name gco -Value Get-GitCheckout -Force -Option AllScope
New-Alias -Name gb -Value Get-GitBranch -Force -Option AllScope
New-Alias -Name gr -Value Get-GitRemote -Force -Option AllScope
New-Alias -Name gsbu -Value Update-GitSubmodules -Force -Option AllScope

Write-Warning "loading powershell profile..."
Invoke-Expression ". $PROFILE"

# Write-Warning "setting up neovim..."
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
# Invoke-Expression 'choco install ripgrep fd gsudo make nodejs.install neovim -y'

# Write-Warning "adding config..."
# if (!(Test-Path -Path "$env:LOCALAPPDATA\nvim"))
# {
#   New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
# }
# Copy-Item -Path "$env:USERCONFIG\nvim\entry.lua" -Destination "$env:LOCALAPPDATA\nvim\init.lua"

# Write-Warning "setted up neovim"

Write-Warning "finished!"
