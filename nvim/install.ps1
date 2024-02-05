# Write-Host "setting up neovim..."
# Invoke-Expression 'choco install neovim -y'

# Write-Host "adding config..."
# if (!(Test-Path -Path "$env:LOCALAPPDATA\nvim"))
# {
#   New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\nvim"
# }
# Copy-Item -Path "$env:USERCONFIG\nvim\entry.lua" -Destination "$env:LOCALAPPDATA\nvim\init.lua"

# Write-Host "setted up neovim"
