Write-Warning "removing Chocolatey..."
Remove-Item -Force -Recurse "$env:ChocolateyInstall" -ErrorAction Ignore
