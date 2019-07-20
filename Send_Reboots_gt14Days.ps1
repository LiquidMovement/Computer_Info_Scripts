$csv = Import-Csv -Path "\\<NETWORK PATH>\Get_UpTime\PCTimes.csv" -Header PC,Days,Hours,Minutes
$date = Get-Date -format MMddyyyy

foreach($entry in $csv){

    $PC = $entry.PC
    $Days = $entry.Days

    if($PC -eq "On Call Tech - Rows 1 & 2 Must Be DELETED if You Approve the Reboot List For Tonight" -or $PC -eq "PC"){
        "No reboots. Either the approval rows were not deleted by the On Call tech, or there are no PCs beyond 14 days of Up Time." | Out-file "\\<NETWORK PATH>\Get_UpTime\PCReboots_$date.txt"
        exit
    }
    else{
        if($Days -ge 14 -and $PC -inotlike "*IT*"){
            #send reboot
            "$PC uptime greater than 14 Days. Reboot sent" | Out-file "\\<NETWORK PATH>\Get_UpTime\PCReboots_$date.txt" -Append
        }
        else{
            #do nada
        }

        if($Days -eq "Failed"){
            "$PC Failed to connect" | Out-file "\\v\Get_UpTime\PCReboots_$date.txt" -Append
        }
        else{
            #do nada
        }
    }
}


$limit = (Get-Date).AddDays(-31)

foreach($file in $files){
    Get-ChildItem -Path "\\<NETWORK PATH>\Get_UpTime\" -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.lastwritetime -lt $limit } | Remove-Item -Force
}