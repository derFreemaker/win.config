Write-Host "installing some tools..."
Invoke-Expression "choco install make gsudo ripgrep fd nodejs.install -y"

# cmake
Invoke-Expression 'choco install cmake.install cmake --installargs "ADD_CMAKE_TO_PATH=User" -y'
# can be removed when path gets added with install
Add-ENV -VariableName "Path" -Value "C:\Program Files\CMake\bin"
$env:PATH = "$env:PATH;C:\Program Files\CMake\bin"