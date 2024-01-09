Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

oh-my-posh init pwsh --config "$env:USERCONFIG/pwsh/oh-my-posh.theme.json" | Invoke-Expression
