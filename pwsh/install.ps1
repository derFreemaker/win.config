Write-Host "installing oh-my-posh..."
Invoke-Expression "choco install oh-my-posh -y"

Write-Host "installing modules..."
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSReadLine -Force

Write-Host "setted up terminal!"