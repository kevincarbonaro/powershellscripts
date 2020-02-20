# Script to fix the Windows Mobile 2003 Device Center Service Logon properties
# Author: Kevin Carbonaro
# Credits: Clint Cuschieri - CimInstance Research

$serviceName = "wcescomm"
$cimFilter = "Name='" + $serviceName + "'"
$serviceStatus = Get-CimInstance win32_service -filter $cimFilter


if ($serviceStatus.state -ne "Running") {
    Stop-Service $serviceName
    Get-CimInstance win32_service -filter $cimFilter | Invoke-CimMethod -Name Change -Arguments @{StartName=”LocalSystem”}
    Start-Service $serviceName
}