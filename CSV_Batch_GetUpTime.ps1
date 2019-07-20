if(test-path "\\<NETWORK PATH>\Get_UpTime\PCTimes.csv"){
    Remove-Item "\\<NETWORK PATH>\Get_UpTime\PCTimes.csv" -Force
}


$PCs = Get-ADComputer -Filter {OperatingSystem -notlike "*server*"} |
     Select-Object name -ExpandProperty name | sort name

"PC, Days, Hours, Minutes" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Append
"On Call Tech - Rows 1 & 2 Must Be DELETED if You Approve the Reboot List For Tonight" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Append

foreach($PC in $PCs){
    
    if($PC -eq "vrtvmapl" -or $PC -eq "VRTISE01" -or $PC -eq "VRTISE02"){
        #do nada
    }
    else{
        if(Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $PC){
            $lastBoot = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $PC | select LastBootUpTime

            $now = Get-Date
            $bootTime = $lastBoot.LastBootUpTime

            $UpTime = $now.Subtract($bootTime)
            $days = $UpTime.Days
            $hours = $UpTime.Hours
            $minutes = $UpTime.Minutes

            if($days -ge 14){
                "$PC, $days, $hours, $minutes" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Append
            }
        }
        else{
            "$PC, Failed, to, Connect" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Append
        }
    }

}

$lines = Import-csv -Path "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Delimiter ","

$lines | Export-Csv -Path "\\<NETWORK PATH>\Get_UpTime\PCTimes.csv" -NoTypeInformation

ii "\\<NETWORK PATH>\Get_UpTime\PCTimes.csv"

Remove-Item -Path "\\<NETWORK PATH>\Get_UpTime\PCTimes.txt" -Force