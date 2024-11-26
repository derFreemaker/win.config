$env:Path = "$PSScriptRoot\lua;$env:Path"
. "$PSScriptRoot/lua-config/bin/lua-config.bat" ($args -join ' ')
