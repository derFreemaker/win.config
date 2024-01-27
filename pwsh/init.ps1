Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine
Import-Module "C:\Program Files\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"

Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

oh-my-posh init pwsh --config "$env:USERCONFIG/pwsh/oh-my-posh.theme.json" | Invoke-Expression
