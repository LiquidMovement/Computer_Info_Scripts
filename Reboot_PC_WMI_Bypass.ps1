$PCs = 'XXXX'

foreach($PC in $PCs){
    shutdown /m \\$PC /f /r /t 00
}