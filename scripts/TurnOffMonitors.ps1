# Turn-Off-Monitors.ps1
# Script to turn off monitors when run over SSH

# Create the monitor control code as a temporary script
$MonitorControlScript = @'
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class MonitorControl {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
}
"@
$HWND_BROADCAST = 0xFFFF
$WM_SYSCOMMAND  = 0x0112
$SC_MONITORPOWER = 0xF170
# Turn monitors off (2 = off)
[MonitorControl]::SendMessage($HWND_BROADCAST, $WM_SYSCOMMAND, $SC_MONITORPOWER, 2)
'@

# Save the script to a temporary file
$TempScript = "$env:TEMP\MonitorOff.ps1"
$MonitorControlScript | Out-File -FilePath $TempScript -Encoding UTF8

try {
    # Execute the script in the interactive session (Session 1) using schtasks
    # This creates a temporary scheduled task that runs immediately in the interactive session
    $TaskName = "TurnOffMonitors_$(Get-Random)"
    
    # Create and run the scheduled task with current time + 5 seconds
    schtasks /create /tn $TaskName /tr "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$TempScript`"" /sc once /st 23:59 /f *>$null
    schtasks /run /tn $TaskName | Out-Null
    
    # Wait a moment for the task to execute
    Start-Sleep -Seconds 2
    
    # Clean up the scheduled task
    schtasks /delete /tn $TaskName /f | Out-Null
}
catch {
    Write-Error "Failed to turn off monitors: $_"
}
finally {
    # Clean up the temporary script file
    if (Test-Path $TempScript) {
        Remove-Item $TempScript -Force
    }
}
