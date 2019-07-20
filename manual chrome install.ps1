$machine = Read-Host -Prompt "Input Machine name"
$session = New-PSSession -ComputerName $machine

Copy-Item "\\<NETWORK PATH>\Chrome\googlechromestandaloneenterprisex86-64.0.328.140.msi" -Destination "\\$machine\c$\temp\chrome.msi" -Force

Invoke-Command -session $session -ScriptBlock { Start-Process "msiexec.exe" -ArgumentList "/i c:\temp\chrome.msi" -Wait }
Remove-PSSession $session