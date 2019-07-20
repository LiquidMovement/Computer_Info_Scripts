#$adcomp = get-content "c:\temp\comps.txt"
$timestamp = get-date -Format d | foreach {$_ -replace "/", "-"}
$filename = "c:\usersloggedin\report\Logged_in_Users_$timestamp.txt"
$adcomp = Get-ADComputer -Filter {OperatingSystem -notlike "*server*"} | Select-Object name -ExpandProperty name | sort name

    foreach ($comp in $adcomp) {
        if (test-connection -ComputerName $comp -Count 1 -Quiet ) { 
            if ($event = Get-WmiObject –ComputerName $comp –Class Win32_ComputerSystem | Select-Object -expand UserName | ForEach-Object {$_ -replace "....\\" , ""}) {
                    $dept = get-aduser -Identity $event -Properties department | Select-Object -expand department
                    $firstlast = get-aduser -Identity $event -Properties name | Select-Object -expand name
                    write-output "$comp - $event - $firstlast - $dept"
                    $count = $count+1
                    "$comp - $event - $firstlast - $dept" | out-file -FilePath $filename -Append 
            
           } else {
                Write-Output "$comp WMI Error/No User"
                "$comp - WMI Error/No User" | out-file -FilePath $filename -Append
                }

          } else {
                Write-Output "$comp network Error!!"
                "$comp - network Error!!" | out-file -FilePath $filename -Append
                }
     }

write-output "`n Total machines: $count" | out-file -FilePath $filename -Append