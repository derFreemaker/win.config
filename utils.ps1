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

if ($null -eq (Get-Command Update-SessionEnvironment)) {

    
    function Update-SessionEnvironment {
<#
.SYNOPSIS
Updates the environment variables of the current powershell session with
any environment variable changes that may have occurred.
#>

        $refreshEnv = $false
        $invocation = $MyInvocation
        if ($invocation.InvocationName -eq 'refreshenv') {
            $refreshEnv = $true
        }
    
        if ($refreshEnv) {
            Write-Output 'Refreshing environment variables from the registry for powershell.exe. Please wait...'
        }
        else {
            Write-Verbose 'Refreshing environment variables from the registry.'
        }
    
        $userName = $env:USERNAME
        $architecture = $env:PROCESSOR_ARCHITECTURE
    
        #ordering is important here, $user should override $machine...
        $ScopeList = 'Process', 'Machine'
        if ('SYSTEM', "${env:COMPUTERNAME}`$" -notcontains $userName) {
            # but only if not running as the SYSTEM/machine in which case user can be ignored.
            $ScopeList += 'User'
        }
        foreach ($Scope in $ScopeList) {
            Get-EnvironmentVariableNames -Scope $Scope |
            ForEach-Object {
                Set-Item "Env:$_" -Value (Get-EnvironmentVariable -Scope $Scope -Name $_)
            }
        }
    
        #Path gets special treatment b/c it munges the two together
        $paths = 'Machine', 'User' |
        ForEach-Object {
        (Get-EnvironmentVariable -Name 'PATH' -Scope $_) -split ';'
        } |
        Select-Object -Unique
        $Env:PATH = $paths -join ';'
    
        # reset user and architecture
        if ($userName) {
            $env:USERNAME = $userName;
        }
        if ($architecture) {
            $env:PROCESSOR_ARCHITECTURE = $architecture;
        }
    
        if ($refreshEnv) {
            Write-Output 'Finished'
        }
    }

    Set-Alias refreshenv Update-SessionEnvironment
}