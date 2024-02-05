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

    $currentValue = [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)

    if ($currentValue -eq $null) {
        [System.Environment]::SetEnvironmentVariable($VariableName, $Value, [System.EnvironmentVariableTarget]::User)
    }
}

function Remove-ENV {
    param(
        [string]$VariableName,
        [string]$Value
    )

    $current = [System.Environment]::GetEnvironmentVariable($VariableName, [System.EnvironmentVariableTarget]::User)

    if ($current -like "*$Value*") {
        $new = $current -replace [regex]::Escape($Value), ""
        $new = $new -replace ";;", ";"
        [System.Environment]::SetEnvironmentVariable($VariableName, $new, [System.EnvironmentVariableTarget]::User)
    }
}