$fragment1 = Get-Process -Name GoogleDriveFS | Select-Object Name,Id,Path | ConvertTo-Html -Fragment -PreContent "<h2>Processes</h2>" | Out-String
$fragment2 = Get-SysInfo -ComputerName localhost | ConvertTo-Html -Fragment -PreContent "<h2>SysInfo</h2>" | Out-String
ConvertTo-Html -Body "<h1>report</h1>",$fragment1,$fragment2 | Out-File -FilePath "C:\temp\Report.html"