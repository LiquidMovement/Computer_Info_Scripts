Write-Host "Script needs to be run as DA or as Admin"
Write-Host "`n"

$PC = Read-Host "Enter PC Number/Name"

Get-WmiObject -Namespace root\cimv2\power -Class win32_PowerPlan -ComputerName $PC | Select-Object -Property ElementName, IsActive | Format-Table -Property * -AutoSize
Pause