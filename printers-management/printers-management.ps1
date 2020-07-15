#Get-Printer
#Get-PrinterPort
#Get-PrinterDriver
#Get-PrintJob

#Add-Printer
#Add-PrinterPort
#Add-PrinterDriver

#Remove-Printer
#Remove-PrinterPort
#Remove-PrinterDriver
#Remove-PrintJob


Function ClearPrintJobs {
    Stop-Service spooler
    Write-Host '1. Stopping Spooler Service ...' -ForegroundColor Green
    Remove-Item -Path $env:windir\system32\spool\PRINTERS\*.*
    Write-Host "2. Clearing content in $env:windir\system32\spool\PRINTERS" -ForegroundColor Green
    Write-Host '3. Starting Spooler Service ...' -ForegroundColor Green
    $start=Start-Service Spooler -ErrorAction Ignore
    If ((Get-Service spooler).status -eq 'Stopped')
    {Write-Host '!!! Error. Spooler could not be started or stopped. Check Service. !!!' -ForegroundColor Red}
}

#ClearPrintJobs