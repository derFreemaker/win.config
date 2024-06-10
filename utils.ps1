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

function Remove-From-ENV {
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
    $Destination.CopyHere($Path,0x10)
}
