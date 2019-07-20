﻿Write-Host "Script needs to be run as DA or as Admin"
Write-Host "`n"
$PC = Read-Host "Enter PC Number/Name"

$powerplan=get-wmiobject -namespace "root\cimv2\power" -class Win32_powerplan -ComputerName $PC | where {$_.IsActive}

$powerSettings = $powerplan.GetRelated("win32_powersettingdataindex") | foreach {
 $powersettingindex = $_;

 $powersettingindex.GetRelated("Win32_powersetting") | select @{Label="Power Setting";Expression={$_.instanceid}},
 @{Label="AC/DC";Expression={$powersettingindex.instanceid.split("\")[2]}},
 @{Label="Summary";Expression={$_.ElementName}},
 @{Label="Description";Expression={$_.description}},
 @{Label="Value";Expression={$powersettingindex.settingindexvalue}}
 }

$powerSettings | ft "AC/DC",Summary,Value -autosize