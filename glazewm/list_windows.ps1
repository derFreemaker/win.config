## This script will list all the titles of the current windows and their class

# Add User32.dll functions to PowerShell
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class User32 {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern bool EnumWindows(EnumWindowsProc callback, IntPtr extraData);

    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern bool IsWindowVisible(IntPtr hWnd);

    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern IntPtr GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
}
"@

# Callback function to process each window handle
$enumWindowsCallback = {
    param (
        [IntPtr] $hWnd,  # Window handle
        [IntPtr] $lParam
    )

    # Check if window is visible
    if ([User32]::IsWindowVisible($hWnd)) {
        # Initialize $processId before passing by reference
        $processId = 0
        $null = [User32]::GetWindowThreadProcessId($hWnd, [ref]$processId)

        # Get window title
        $windowTitle = New-Object -TypeName System.Text.StringBuilder -ArgumentList 256
        [User32]::GetWindowText($hWnd, $windowTitle, $windowTitle.Capacity) > 0 | Out-Null

        # Get window class
        $windowClass = New-Object -TypeName System.Text.StringBuilder -ArgumentList 256
        [User32]::GetClassName($hWnd, $windowClass, $windowClass.Capacity) > 0 | Out-Null

        # Add the window details to the list if title or class is not empty
        if ($windowTitle.Length -gt 0 -or $windowClass.Length -gt 0) {
            $windows += [pscustomobject]@{
                ProcessId = $processId
                Handle    = $hWnd
                Title     = $windowTitle.ToString()
                Class     = $windowClass.ToString()
            }

            # Debugging message to ensure windows are captured
            Write-Host "Captured Window - ProcessId: $processId, Title: $($windowTitle.ToString()), Class: $($windowClass.ToString())"
        }
    }

    return $true # Continue enumeration
}

# Start enumerating windows (main and child)
[User32]::EnumWindows($enumWindowsCallback, [IntPtr]::Zero)
