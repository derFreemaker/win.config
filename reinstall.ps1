#Requires -RunAsAdministrator

Write-Warning "uninstalling..."
Write-Output ""

Invoke-Command .\uninstall.ps1

Write-Output ""
Write-Warning "uninstalled!"
Write-Warning "installing..."
Write-Output ""

Invoke-Command .\install.ps1

Write-Output ""
Write-Warning "installed!"
