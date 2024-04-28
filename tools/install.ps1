Write-Host "installing some tools..."
Invoke-Expression "choco install mingw make gsudo ripgrep fd nodejs.install bazel buildifier -y"

# cmake
Invoke-Expression 'choco install cmake.install cmake --installargs "ADD_CMAKE_TO_PATH=User" -y'
# can be removed when path gets added with install
Add-ENV -VariableName "Path" -Value "C:\Program Files\CMake\bin"
$env:PATH = "$env:PATH;C:\Program Files\CMake\bin"

# Git & co
Write-Host "installing git tools..."
Invoke-Expression "winget install --id Git.Git"
Invoke-Expression "winget install --id GitHub.GitHubDesktop"
Invoke-Expression "winget install --id Axosoft.GitKraken"
Invoke-Expression "winget install --id GitHub.cli"

# some other Programs
Write-Host "installing some other programs..."
Invoke-Expression "winget install --id 7zip.7zip"
Invoke-Expression "winget install --id Brave.Brave"
Invoke-Expression "winget install --id Notepad++.Notepad++"
Invoke-Expression "winget install --id JetBrains.Toolbox"
Invoke-Expression "winget install --id Postman.Postman"
Invoke-Expression "winget install --id Balena.Etcher"
Invoke-Expression "winget install --id AnyDeskSoftwareGmbH.AnyDesk"
Invoke-Expression "winget install --id Docker.DockerDesktop"
Invoke-Expression "winget install --id OpenWhisperSystems.Signal"
