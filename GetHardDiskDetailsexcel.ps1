# ==============================================================================================
# 
# NAME: GetHardDiskDetailsexcel.ps1
#
# 
# COMMENT: Retrieves information about hard disk size
# 1. illustrates use of: constant, variables, wmi class
# 2. uses where object to filter out on only physical disks (disk type 3)
# 3. outputs to excel
# ==============================================================================================
# *** $aryComputers = Get-Content ./machinelist.txt

# Get updated Machine List
 Import-Module ActiveDirectory
$comp = Get-ADComputer -Filter {OperatingSystem -like "*server*"}| Select-Object DistinguishedName, name | Sort-Object name | where-object { ($_.DistinguishedName -notlike "*OU=AWS-RemoteAccess*") -and ($_.DistinguishedName -notlike "*OU=Test Desktops*") }
$comp.name | Out-String > "\\<NETWORK PATH>\Machinelist\MachineList.Txt"


Set-Variable -name intDriveType -value 3 -option constant #constant for local disk

# get current directory and current location

function Get-ScriptDirectory
{
 $Invocation = (Get-Variable MyInvocation -Scope 1).Value
 Split-Path $Invocation.MyCommand.Path
}

$path = "\\<NETWORK PATH>\it\DiskCheck"

$excel = New-Object -comobject Excel.Application
$excel.visible = $True

$workbook = $excel.Workbooks.Add()
$cells = $workbook.Worksheets.Item(1)

$cells.Cells.Item(1,1) = "ComputerName"
$cells.Cells.Item(1,2) = "DeviceID"
$cells.Cells.Item(1,3) = "FreeSpace-GB"
$cells.Cells.Item(1,4) = "Size-GB"

$cellformat = $cells.UsedRange
$cellformat.Interior.ColorIndex = 19
$cellformat.Font.ColorIndex = 11
$cellformat.Font.Bold = $True
$cellformat.EntireColumn.AutoFit()
$counter = 2


$machinelist = get-content "\\<NETWORK PATH>\Machinelist\MachineList.Txt"
foreach ($individualcomputer in $machinelist){
Trap {
   Continue
   }
 $check=Get-WmiObject -class win32_logicaldisk -computername $individualcomputer
  if ($check){
$getdata = Get-WmiObject -class win32_logicaldisk -computername $individualcomputer | where {$_.drivetype -eq $intDriveType}  |
        Select-Object @{name="ComputerName";expression={$strComputer}}, DeviceID, @{name="FreeSpace";Expression={[math]::round($_.freespace / 1GB,2)}},
        @{name="Size";Expression={[math]::round($_.size / 1GB,2)}}
foreach ($drivedata in $getdata){
 $cells.Cells.Item($counter, 1) = $individualcomputer
 $cells.Cells.Item($counter, 2) = $drivedata.DeviceID
 $cells.Cells.Item($counter, 3) = $drivedata.FreeSpace
 $cells.Cells.Item($counter, 4) = $drivedata.Size
 $counter = $counter + 1
 }
 }
 else{
 $cells.Cells.Item($counter, 1) = $individualcomputer
 $cells.Cells.Item($counter, 2) = "Error"
 $cells.Cells.Item($counter, 3) = "Error"
 $cells.Cells.Item($counter, 4) = "Error"
 $counter = $counter + 1
 }
  }

# format current date to mm-dd-yyyy
$cdate = get-date -UFormat "%m-%d-%Y"

# format file name to current directory with name of server-disk-utilization_mm-dd-yyyy.xlsx
 $filename = $path + "\server-disk-utilization_" + $cdate + ".xlsx"

# if file exists remove it
if(Test-Path $filename){Remove-Item $filename -force}


$workbook.SaveAs($filename)
# $workbook.Close()
# $excel.Quit()

# cleanly kill processes
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
Remove-Variable excel

