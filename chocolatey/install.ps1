Write-Host "installing chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "reloading environment..."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + "; " + [System.Environment]::GetEnvironmentVariable("Path", "User")