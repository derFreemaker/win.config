# Wake the machine
ssh Waker './wake_mybuild.sh'

# Wait until the machine responds to ping
Write-Host "Waiting for MyBuild11 to come online..."
while (-not (Test-Connection -ComputerName MyBuild11 -Count 1 -Quiet)) {
    Start-Sleep -Seconds 2
}

# Connect via SSH
ssh MyBuild11

