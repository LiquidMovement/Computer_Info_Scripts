$PC = Read-Host "Enter PC"
#Enter-Pssession $PC
#Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -ne "ERROR"} | Disable-PnpDevice -confirm:$false
#Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Write-Output
#Write-Host "`n"
#Write-Host "Verify device has entered 'ERROR' status."
#Write-Host "`n"
#pause
#sleep 10
#Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -eq "ERROR"} | Enable-PnpDevice -confirm:$false
#Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"}  | Write-Host $_.
#Write-Host "Complete, session removed. Verify with user the monitor is functioning."
#Pause
#Exit-PSSession

$session = New-PSSession -ComputerName $PC
$correct = $true
$count = 1

    Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -ne "ERROR"} | Disable-PnpDevice -confirm:$false}
    sleep 5
    $off = Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Format-Table status,FriendlyName }
    $off
    Write-Host "`n"
    Write-Host "Verify device has entered 'ERROR' status."
    Write-Host "`n"
    pause
    Write-Host "`n"
    Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -eq "ERROR"} | Enable-PnpDevice -confirm:$false}
    $on = Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Format-Table status,FriendlyName}
    $on

    while($correct -eq $true){
        $answer = Read-Host "Is the monitor functioning? (Y/N)"
        $count++
        if($answer -like "N"){
            Write-Host "`nYou answered $answer, running attempt $count."
            Write-Host "`n"
            $correct = $true
            sleep 3

            Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -ne "ERROR"} | Disable-PnpDevice -confirm:$false}
            sleep 5
            $off = Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Format-Table status,FriendlyName }
            $off
            Write-Host "`n"
            Write-Host "Verify device has entered 'ERROR' status."
            Write-Host "`n"
            pause
            Write-Host "`n"
            Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Where-Object {$_.Status -eq "ERROR"} | Enable-PnpDevice -confirm:$false}
            $on = Invoke-Command -Session $session -ScriptBlock {Get-PnpDevice | Where-Object {$_.FriendlyName -match "MCT USB3.0 External Graphics Device"} | Format-Table status,FriendlyName}
            $on
        }
        else{
           $correct = $false 
        }
    }
Remove-PSSession -Session $session
Write-Host "`nComplete, session removed."
Pause
Exit