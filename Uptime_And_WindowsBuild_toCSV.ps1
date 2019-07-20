
if(test-path "\\<NETWORK PATH>\Get_UpTime\PC_Version.csv"){
    Remove-Item "\\<NETWORK PATH>\Get_UpTime\PC_Version.csv" -Force
}


$PCs = Get-ADComputer -Filter {OperatingSystem -notlike "*server*"} |
     Select-Object name -ExpandProperty name | sort name

"PC, Days, Hours, Minutes, Version" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Append
"On Call Tech - Rows 1 & 2 Must Be DELETED if You Approve the Reboot List For Tonight" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Append

foreach($PC in $PCs){
    
    if($PC -eq "XXX" -or $PC -eq "XXX" -or $PC -eq "XXX"){
        #do nada
    }
    else{
        if(Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $PC){
            $lastBoot = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $PC | select BuildNumber,LastBootUpTime

            $now = Get-Date
            $bootTime = $lastBoot.LastBootUpTime
            $version = $lastboot.BuildNumber

            $UpTime = $now.Subtract($bootTime)
            $days = $UpTime.Days
            $hours = $UpTime.Hours
            $minutes = $UpTime.Minutes

            "$PC, $days, $hours, $minutes, $version" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Append
        }
        else{
            "$PC, Failed, to, Connect" | Out-File "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Append
        }
    }

}

$lines = Import-csv -Path "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Delimiter ","

$lines | Export-Csv -Path "\\<NETWORK PATH>\Get_UpTime\PC_Version.csv" -NoTypeInformation

ii "\\<NETWORK PATH>\Get_UpTime\PC_Version.csv"

Remove-Item -Path "\\<NETWORK PATH>\Get_UpTime\PCVersion.txt" -Force