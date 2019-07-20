Function OpenSession{
    try{
        $CMD1 = Enter-PSSession $PC
        $job1 = Start-Job {$CMD1}
        Wait-Job $job1
        $CMD2 = {([wmiclass]'ROOT\ccm\ClientSdk:CCM_Application').Install('XXXX/XXXX', 5, $True, 0, 'Normal', $False)}
        $job2 = Start-Job {$CMD2}
        Wait-Job $job2
        
    }
    catch{
        Write-Host "Something failed, there's probably a bunch of angry red letters on your screen."
    }
}

Function CloseSession{
    Start-Sleep -s 35
    Write-Host "Start Sleep Over"
    Exit-PSSession
}

Write-Host "Enter PC Name : "
$PC = Read-Host

OpenSession
Write-Host "Complete Open"
Exit-PSSession
Write-Host "Exit successful"
Pause
