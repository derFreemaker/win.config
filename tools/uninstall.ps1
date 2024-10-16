Write-Warning "uninstalling tools..."
Invoke-Expression "choco uninstall make cmake cmake.install gsudo ripgrep fd nodejs.install -y"
