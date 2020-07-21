# **************************************
# Network Receipt Printers Installer
# Author: Kevin Carbonaro
# Date: 22-July-2020
# **************************************

# Change the printer driver name as required. Use get-printerdriver for list of drivers and their names.

$epsonDriverName = "EPSON TM-T20II Receipt5"

$networkPrinters = @(
    [pscustomobject]@{printerName  ="Pizza (Upstairs)"; driverName = $epsonDriverName; portName = "192.168.10.15"}
    [pscustomobject]@{printerName  ="Bar (Upstairs)"; driverName = $epsonDriverName; portName = "192.168.10.35"}
    [pscustomobject]@{printerName  ="Kitchen (Upstairs)"; driverName = $epsonDriverName; portName = "192.168.10.30"}
    [pscustomobject]@{printerName  ="Chef (Upstairs)"; driverName = $epsonDriverName; portName = "192.168.10.16"}
    [pscustomobject]@{printerName  ="BarFood (Upstairs)"; driverName = $epsonDriverName; portName = "192.168.10.121"}
    [pscustomobject]@{printerName  ="Salad (Downstairs)"; driverName = $epsonDriverName; portName = "192.168.10.32"}
    [pscustomobject]@{printerName  ="Pizza (Downstairs)"; driverName = $epsonDriverName; portName = "192.168.10.34"}
    [pscustomobject]@{printerName  ="Pass (Downstairs)"; driverName = $epsonDriverName; portName = "192.168.10.33"}
)

$usbPrinters = @(
    [pscustomobject]@{printerName  ="POS3 Cash (Upstairs)"; driverName = $epsonDriverName;}
)

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

Function isPrinterDriverInstalled($printerDriver) {
        $result = Get-PrinterDriver -Name $printerDriver

        if ($result.Name -eq $printerDriver) {
            return true
        }
        else {
            return false
        }
}

Function RemoveNetworkPrinters($networkPrintersData) {
    foreach ( $printer in $networkPrintersData ) {
        write-host "Checking if printer:", $printer.printerName, "exists..."
        $printerCheck = Get-Printer -Name $printer.printerName

        if ($printerCheck.Name -eq $printer.printerName) {
            write-host "Printer:", $printer.printerName, "exists and will be removed"
            remove-printer $printer.printerName
        }
        else {
            write-host "Printer:", $printer.printerName, "does not exist."
        }
    }
}

Function RemoveNetworkPrinterPorts($networkPrintersData) {
    foreach ( $printer in $networkPrintersData ) {
        write-host "Checking if port:", $printer.portName, "exists..."
        $portCheck = Get-PrinterPort -Name $printer.portName

        if ($portCheck.Name -eq $printer.portName) {
            write-host "Port:", $printer.portName, "exists and will be removed"
            Remove-PrinterPort $printer.portName
        }
        else {
            write-host "Port:", $printer.portName, "does not exist."
        }
    }
}

Function AddNetworkPrinterPorts($networkPrintersData) {
    foreach ( $printer in $networkPrintersData ) {
        write-host "Checking if port:", $printer.portName, "exists..."
        $portCheck = Get-PrinterPort -Name $printer.portName

        if ($portCheck.Name -eq $printer.portName) {
            write-host "Port:", $printer.portName, "exists."
        }
        else {
            write-host "Port:", $printer.portName, "does not exist and will be created."
            Add-PrinterPort -Name $printer.portName -PrinterHostAddress $printer.portName
        }
    }
}

Function AddNetworkPrinters($networkPrintersData) {
    foreach ( $printer in $networkPrintersData ) {
        write-host "Checking if printer:", $printer.printerName, "exists..."
        $printerCheck = Get-Printer -Name $printer.printerName

        if ($printerCheck.Name -eq $printer.printerName) {
            write-host "Printer:", $printer.printerName, "exists."
        }
        else {
            write-host "Printer:", $printer.printerName, "does not exist and will be created."
            Add-Printer -Name $printer.printerName -DriverName $printer.driverName -PortName $printer.portName
        }
    }
}

cls

write-host "Checking if printer driver", $printerDriver, "is installed."
$printerDriverInstalled = isPrinterDriverInstalled($epsonDriverName)

if ($result.Name -eq $printerDriver) {
    write-host "Printer:", $epsonDriverName, "exists."
}
else {
    write-host "Printer:", $epsonDriverName, "does not exist and must be installed first. Please install driver from IT Folder."
    pause
    exit
}

RemoveNetworkPrinters($networkPrinters)
RemoveNetworkPrinterPorts($networkPrinters)
AddNetworkPrinterPorts($networkPrinters)
AddNetworkPrinters($networkPrinters)
write-host "Please review the following printer details to confirm they are correct."
Get-Printer

#Not Implemented yet
#Add-Printer -ConnectionName "\\pos3\Pos3 Cash (Upstairs)"