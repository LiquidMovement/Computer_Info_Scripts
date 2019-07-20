#param ($x)
$x = read-host "Enter Machine Name"
Invoke-Command -ComputerName $x {Get-WMIObject -class Win32_ComputerSystem | select username}