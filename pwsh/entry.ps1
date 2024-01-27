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
function Update-GitSubmodules { & git submodule update --remote --recursive $args }
function Restore-Git { & git restore $args }

New-Alias -Name gs -Value Get-GitStatus -Force
New-Alias -Name gc -Value Get-GitCommit -Force
New-Alias -Name ga -Value Get-GitAdd -Force
New-Alias -Name gt -Value Get-GitTree -Force
New-Alias -Name gps -Value Get-GitPush -Force
New-Alias -Name gpl -Value Get-GitPull -Force
New-Alias -Name gf -Value Get-GitFetch -Force
New-Alias -Name gco -Value Get-GitCheckout -Force
New-Alias -Name gb -Value Get-GitBranch -Force
New-Alias -Name gr -Value Get-GitRemote -Force
New-Alias -Name gsmu -Value Update-GitSubmodules -Force
New-Alias -Name grst -Value Restore-Git -Force

Invoke-Expression -Command "$env:USERCONFIG\pwsh\init.ps1"
