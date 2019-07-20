$computer = "LocalHost" 
$namespace = "root\CIMV2" 
$array = @()
$array1 = New-Object PSObject

$gather1=Get-WmiObject -class Win32_ComputerSystem -computername $computer -namespace $namespace | select SystemType,Model
$gather2=Get-WmiObject -class Win32_BIOS -computername $computer -namespace $namespace | select SMBIOSBIOSVersion,SerialNumber
    
$array1 | Add-Member -MemberType NoteProperty -Name "SystemType" -Value $($gather1.SystemType)
$array1 | Add-Member -MemberType NoteProperty -Name "Model" -Value $($gather1.Model)
$array1 | Add-Member -MemberType NoteProperty -Name "SMBIOSBIOSVersion" -Value $($gather2.SMBIOSBIOSVersion)
$array1 | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value $($gather2.SerialNumber)
$array += $array1
   
$array

