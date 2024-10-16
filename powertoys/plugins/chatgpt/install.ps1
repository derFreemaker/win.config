Write-Host "installing powertoys plugin for chatgpt..."

$temp = New-TemporaryFile
Invoke-WebRequest -Uri "https://github.com/ferraridavide/ChatGPTPowerToys/releases/download/v0.85.1/Community.PowerToys.Run.Plugin.ChatGPT.x64.zip" -OutFile $temp
Invoke-Expression "7z e $temp -o'$env:LOCALAPPDATA/Microsoft/PowerToys/PowerToys Run/Plugins/ChatGPT'"
