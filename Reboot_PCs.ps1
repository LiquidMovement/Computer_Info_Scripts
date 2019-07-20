$PCs = Get-Content "C:\Scripts\temp\Reboot_PCs.txt"

foreach($PC in $PCs){

    shutdown /m \\$PC /f /r /t 00 

}