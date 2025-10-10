. "$env:USERCONFIG_FREEMAKER/scripts/load.ps1"

# Neovim alias
New-Alias -Name vim -Value nvim -Force

# Load Terminal-Icons if available
if (Get-Module -ListAvailable Terminal-Icons -ErrorAction SilentlyContinue) {
    Import-Module Terminal-Icons
} else {
    Write-Warning "Terminal-Icons module not found - install with: Install-Module -Name Terminal-Icons -Repository PSGallery"
}

# Load and configure PSReadLine if available
if (Get-Module -ListAvailable PSReadLine -ErrorAction SilentlyContinue) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionViewStyle ListView
} else {
    Write-Warning "PSReadLine module not found - install with: Install-Module -Name PSReadLine -Repository PSGallery"
}

# Load posh-git for Git integration if available
if (Get-Module -ListAvailable posh-git -ErrorAction SilentlyContinue) {
    Import-Module posh-git
} else {
    Write-Warning "posh-git module not found - install with: Install-Module -Name posh-git -Repository PSGallery"
}

# Initialize zoxide if available
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& zoxide init --cmd cd powershell | Out-String)
} else {
    Write-Warning "zoxide command not found - install with: winget install ajeetdsouza.zoxide"
}

# Load Completions
. "$env:USERCONFIG_FREEMAKER/completion/pwsh/tailscale.ps1"

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:USERCONFIG_FREEMAKER/pwsh/oh-my-posh.toml" | Invoke-Expression
} else {
    Write-Warning "oh-my-posh command not found - install with: winget install JanDeDobbeleer.OhMyPosh"
}

if ("MYBUILD11" -eq $env:COMPUTERNAME -and $null -ne $env:SSH_CLIENT) {
    . "$env:USERCONFIG_FREEMAKER/scripts/TurnOffMonitors.ps1"
}
