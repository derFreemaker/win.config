Write-Host "adding nvim config..."
if (Test-Path -Path "$env:LOCALAPPDATA\nvim")
{
	Write-Error "unable to add nvim config directory already exists: $env:LOCALAPPDATA\nvim"
	return
}

New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Value "$env:USERCONFIG_FREEMAKER\nvim"

Invoke-Expression 'git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"'
