$computer = Read-Host "Enter PC Name"
$msg = "Hey Pete there are no more casual day emails."
#Start-Sleep -Seconds 500
Write-Host "Sending now"

Invoke-WmiMethod -Class Win32_Process -ComputerName $computer -Name Create -ArgumentList "C:\Windows\System32\msg.exe * $msg"