function Get-ENV {
    param(
        [string]$VariableName
    )

    return [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)
}

function Add-ENV {
    param(
        [string]$VariableName,
        [string]$Value
    )

    $current = [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)

    if ($current -notlike "*$Value*") {
        [System.Environment]::SetEnvironmentVariable($VariableName, "$current;$Value", [System.EnvironmentVariableTarget]::User)
    }
}

function Set-ENV {
    param(
        [string]$VariableName,
        [string]$Value
    )

    [System.Environment]::SetEnvironmentVariable($VariableName, $Value, [System.EnvironmentVariableTarget]::User)
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