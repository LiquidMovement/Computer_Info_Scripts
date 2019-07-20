$pcs = Get-Content c:\temp\computers.txt

foreach($pc in $pcs)
{
    $osInfo = Get-wmiobject -class "Win32_OperatingSystem" -computername $pc
    $lastBootUpTime = $osInfo.ConvertToDateTime($osInfo.LastBootUpTime)
   
        Get-Process | Out-File -encoding ASCII c:\temp\test.txt

 
}