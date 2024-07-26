# Chocolatey
Write-Host "upgrade chocolatey packages..."
Invoke-Expression "choco upgrade mingw make gsudo ripgrep fd nodejs.install bazelisk buildifier -y"

# Git & co
Write-Host "upgrading git tools..."
Invoke-Expression "winget upgrade --id Git.Git"
Invoke-Expression "winget upgrade --id GitHub.GitHubDesktop"
Invoke-Expression "winget upgrade --id Axosoft.GitKraken"
Invoke-Expression "winget upgrade --id GitHub.cli"

# some other Programs
Write-Host "upgrading some other programs..."
Invoke-Expression "winget upgrade --id 7zip.7zip"
Invoke-Expression "winget upgrade --id Brave.Brave"
Invoke-Expression "winget upgrade --id Notepad++.Notepad++"
Invoke-Expression "winget upgrade --id JetBrains.Toolbox"
Invoke-Expression "winget upgrade --id Postman.Postman"
Invoke-Expression "winget upgrade --id Balena.Etcher"
Invoke-Expression "winget upgrade --id AnyDeskSoftwareGmbH.AnyDesk"
Invoke-Expression "winget upgrade --id LocalSend.LocalSend"

