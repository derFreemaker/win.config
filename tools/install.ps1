Write-Host "installing some tools..."
Invoke-Expression "choco install mingw make gsudo ripgrep fd nodejs.install bazel buildifier -y"

# cmake
Invoke-Expression 'choco install cmake.install cmake --installargs "ADD_CMAKE_TO_PATH=User" -y'
# can be removed when path gets added with install
Add-ENV -VariableName "Path" -Value "C:\Program Files\CMake\bin"
$env:PATH = "$env:PATH;C:\Program Files\CMake\bin"

# Git & co
Invoke-Expression winget install --id Git.Git
Invoke-Expression winget install --id GitHub.GitHubDesktop
Invoke-Expression winget install --id Axosoft.GitKraken
Invoke-Expression winget install --id GitHub.cli

# 7zip
Invoke-Expression winget install --id 7zip.7zip

# Brave
Invoke-Expression winget install --id Brave.Brave

# JetBrains
Invoke-Expression winget install --id JetBrains.Toolbox