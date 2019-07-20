$computer = Read-Host "Enter PC Number"

$ComputerMemory =  Get-WmiObject -Class WIN32_OperatingSystem -ComputerName $computer
$Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)

"$Memory %"

Pause