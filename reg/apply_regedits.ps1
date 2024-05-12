Write-Output "applying registry edits..."

Write-Output "remove shortcut arrow..."
Invoke-Expression "sudo reg import $PSScriptRoot\remove_shortcut_arrow_icon.reg"

Write-Output "applyed registry edits!"
