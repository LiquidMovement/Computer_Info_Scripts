$adcomp = Get-ADComputer -Filter {OperatingSystem -notlike "*server*"} |
     Select-Object name -ExpandProperty name | sort name

foreach ($comp in $adcomp) {
    $os = Get-WmiObject -ComputerName $comp win32_operatingsystem
    $uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
    $Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes" 
   Write-Output "$comp $Display"
   }