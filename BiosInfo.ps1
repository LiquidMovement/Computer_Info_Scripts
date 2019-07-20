#param ($x)
$x = read-host "Enter Machine Name"
Invoke-Command -ComputerName $x {Get-WmiObject win32_bios}