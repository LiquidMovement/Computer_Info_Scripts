$comps = Get-Content -path "C:\temp\PClist.txt"

foreach($comp in $comps){

    if(test-connection $comp){
        $info = Get-CimInstance -ClassName win32_computersystem -ComputerName $comp
        $model = $info.Model
        $mem = $info.TotalPhysicalMemory
        $user = $info.UserName
        "$user,$comp,$model,$mem" | out-file "C:\temp\PCInfo.csv" -Append
    }
    else{
        "$comp couldn't connect" | out-file "C:\temp\PCInfo.csv" -Append
    }
}