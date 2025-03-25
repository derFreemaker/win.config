# Browser
New-Alias -Name brave -Value "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" -Force

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

