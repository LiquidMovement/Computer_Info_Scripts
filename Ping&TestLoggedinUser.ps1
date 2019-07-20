$user = Read-Host "enter username"

$test = Get-WmiObject -ComputerName 'XXXX' -Class Win32_ComputerSystem | Select-Object Username

$testName = $test.Username

if((Test-NetConnection -ComputerName 'XXXX') -and ("CORP\$user" -eq $testName)){
    Write-Host "hello sunshine"
}
else{
    Write-Host "wuh oh"
}