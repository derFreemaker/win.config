Write-Output "remove registry edits..."

Write-Output "remove 'remove shortcut arrow'..."
Invoke-Expression "sudo reg import $PSScriptRoot\remove_remove_shortcut_arrow_icon.reg"

Write-Output "removed registry edits!"
