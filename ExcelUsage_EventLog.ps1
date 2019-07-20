$date = (get-date).AddDays(-10)
$count = 0 
$adcomp = get-content "c:\temp\comps.txt" 
   
    #$adcomp = Get-ADComputer -Filter {OperatingSystem -notlike "*server*"} | Select-Object name -ExpandProperty name | sort name

    foreach ($comp in $adcomp) {
        if (test-connection -ComputerName $comp -Count 1 -Quiet ) { 
            $event = get-winevent -ComputerName $comp -LogName "Microsoft-Windows-AppLocker/EXE and DLL" | where-object {$_.message -eq "%PROGRAMFILES%\MICROSOFT OFFICE\OFFICE15\EXCEL.EXE was allowed to run." -and $_.timecreated -gt $date}
   
                if ($event){
                    $item = "$comp has used Excel within the last 10 days"
                    $count = $count+1
                    $item | out-file -FilePath "c:\temp\excel-usage.txt" -Append 

                }
                else{
                    $note = "$comp has not used Excel within the last 10 days."
                    $note | out-file -FilePath "c:\temp\excel-usage.txt" -Append
                }
          }
          else{
            $noCon = "$comp was unable to connect"
            $noCon | out-file -FilePath "c:\temp\excel-usage.txt" -Append
          }
     }

write-output "`n Total machines: $count" | out-file -FilePath "c:\temp\excel-usage.txt" -Append