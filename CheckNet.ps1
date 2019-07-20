If(test-connection -ComputerName www.Google.com -Quiet){
    Write-Host "Hello"
    #Get-NetAdapter | Select name, status, LinkSpeed        #uncomment if details provided are desired by this cmd
    Write-Host " " 
    #Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Get-NetIPInterface | Where ConnectionState -eq 'Connected'         #uncomment if details provided are desired by this cmd
}
Else{
    Write-Host "Failed"
}