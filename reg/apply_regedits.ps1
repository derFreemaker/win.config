Write-Output "applying registry edits..."

Write-Output "remove shortcut arrow..."
Invoke-Expression "sudo reg import $PSScriptRoot\remove_shortcut_arrow_icon.reg"

Write-Output "disabling search bing results..."
Invoke-Expression "sudo reg import $PSScriptRoot\disable_bin_search_results.reg"

Write-Output "applyed registry edits!"
