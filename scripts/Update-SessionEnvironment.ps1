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
    
    
    # should not include machine in environment variables if in portable mode
    if ($null -ne $Global:USERCONFIG_FREEMAKER_PORTABLE) {
        Get-EnvironmentVariableNames -Scope 'Machine' |
        ForEach-Object {
            Set-Item "Env:$_" -Value $null
        }

        $ScopeList = 'Process'
        #ordering is important here, $user should override $machine...
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
        $paths = 'User' |
        ForEach-Object {
            (Get-EnvironmentVariable -Name 'PATH_FREEMAKER_PORTABLE' -Scope $_) -split ';'
        } |
        Select-Object -Unique
        $Env:PATH = $paths -join ';'
    }
    else {
        $ScopeList = 'Process', 'Machine'
        #ordering is important here, $user should override $machine...
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
    }
    
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

Set-Alias refreshenv Update-SessionEnvironment -Force
