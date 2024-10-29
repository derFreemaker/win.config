function Get-ENV {
    param (
        [string]$VariableName
    )

    return [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)
}

function Set-ENV {
    param(
        [string]$VariableName,
        [string]$Value
    )

    [System.Environment]::SetEnvironmentVariable($VariableName, $Value, [System.EnvironmentVariableTarget]::User)
    Set-Item "Env:$VariableName" -Value "$Value"
}

function Add-ENV {
    param(
        [string]$VariableName,
        [string]$Value
    )

    $current = [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)

    if ($current -notlike "*$Value*") {
        [System.Environment]::SetEnvironmentVariable($VariableName, "$Value;$current", [System.EnvironmentVariableTarget]::User)
        Set-Item "Env:$VariableName" -Value "$Value;$current"
    }
}

function Remove-FromENV {
    param(
        [string]$VariableName,
        [string]$Value
    )
    
    $current = [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)
    
    $all = $current -split ";"
    for ($i = 0; $i -lt $all.Count; $i++) {
        if ($all[$i] -eq $Value) {
            $all[$i] = ""
            break
        }
    }
    
    $new = $all | Where-Object -FilterScript {
        $_ -ne ""
    }

    Set-ENV -VariableName $VariableName -Value ($new -join ";")
}

function Install-Font {
    param(
        [string]$Path
    )

    $Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    $Destination.CopyHere($Path, 0x10)
}

function New-Shortcut {
    param(
        [string]$Path,
        [string]$Target
    )

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($Path)
    $shortcut.TargetPath = $Target
    $shortcut.Save()
}

function Get-Device-File-Path {
    param(
        [string]$directory,
        [string]$file
    )
    if (-not $directory.EndsWith("\")) {
        $directory += "\"
    }

    $computer_name = ($env:COMPUTERNAME).ToLower()

    if ((Test-Path -Path ($directory + $computer_name) -PathType Container) -and
        (Test-Path -Path ($directory + $computer_name + "\" + $file) -PathType Leaf)) {
        return $directory + $computer_name + "\" + $file
    }

    return $directory + $file
}

function Get-Device-Directory-Path {
    param(
        [string]$path
    )
    if (-not $path.EndsWith("\")) {
        $path += "\"
    }

    $computer_name = ($env:COMPUTERNAME).ToLower()

    if ((Test-Path -Path ($path + $computer_name) -PathType Container)) {
        return $path + $computer_name + "\"
    }
    return $path
}
