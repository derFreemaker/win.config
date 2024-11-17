Write-Output "remove registry edits..."

Write-Output "adding shortcut arrow..."
Invoke-Expression "sudo reg import $PSScriptRoot\add_shortcut_arrow_icon.reg"

Write-Output "enabling bing search results..."
Invoke-Expression "sudo reg import $PSScriptRoot\enable_bin_search_results.reg"

Write-Output "removed registry edits!"
