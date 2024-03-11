# Write-Host "adding nvim config..."
if (!(Test-Path -Path "$env:LOCALAPPDATA\nvim"))
{
  New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
}
Copy-Item -Path "$env:USERCONFIG_FREEMAKER\nvim\entry.lua" -Destination "$env:LOCALAPPDATA\nvim\init.lua"
