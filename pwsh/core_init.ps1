# Browser
New-Alias -Name brave -Value "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" -Force

# Git
function Get-GitStatus { & git status -sb $args }
New-Alias -Name gs -Value Get-GitStatus -Force
function Get-GitCommit { & git commit -ev $args }
New-Alias -Name gc -Value Get-GitCommit -Force
function Get-GitAdd { & git add --all $args }
New-Alias -Name ga -Value Get-GitAdd -Force
function Get-GitTree { & git log --graph --oneline --decorate $args }
New-Alias -Name gt -Value Get-GitTree -Force
function Get-GitPush { & git push $args }
New-Alias -Name gps -Value Get-GitPush -Force
function Get-GitPull { & git pull --rebase $args }
New-Alias -Name gpl -Value Get-GitPull -Force
function Get-GitFetch { & git fetch $args }
New-Alias -Name gf -Value Get-GitFetch -Force
function Get-GitCheckout { & git checkout $args }
New-Alias -Name gco -Value Get-GitCheckout -Force
function Get-GitBranch { & git branch $args }
New-Alias -Name gb -Value Get-GitBranch -Force
function Get-GitRemote { & git remote -v $args }
New-Alias -Name gr -Value Get-GitRemote -Force
function Update-GitSubmodules { & git submodule update --remote --recursive $args }
New-Alias -Name gsmu -Value Update-GitSubmodules -Force
function Restore-Git { & git restore $args }
New-Alias -Name grst -Value Restore-Git -Force
function Git-Cherry-Pick { & git cherry-pick $args }
New-Alias -Name gcp -Value Git-Cherry-Pick -Force

# Neovim
New-Alias -Name vim -Value nvim -Force

Import-Module -Name Terminal-Icons

if ($null -eq (Get-Module PSReadLine)) {
    Import-Module -Name PSReadLine
}

if ([System.IO.File]::Exists("C:\Program Files\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1")) {
    Import-Module "C:\Program Files\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
}

oh-my-posh init pwsh --config "$env:USERCONFIG_FREEMAKER/pwsh/oh-my-posh.toml" | Invoke-Expression
