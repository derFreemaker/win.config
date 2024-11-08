Write-Output "cleaning up window manager files..."
Remove-Item -Path "$env:USERPROFILE/.glzr" -Recurse -Force
