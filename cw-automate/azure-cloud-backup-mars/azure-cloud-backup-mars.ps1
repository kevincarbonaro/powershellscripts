# Azure Cloud Backup (MARS) Event Logs

#Level          Symbol                                EventID	 EventMessage
#----------------------------------------------------------------------------------------------------------
#Error	        BACKUP_ERROR_STOP_EVENT               11	     The backup operation has completed with errors.
#Error	        SCHEDULE_BACKUP_FAILED_EVENT	      18	     Scheduled backup failed in initialization phase
#Informational	BACKUP_START_EVENT	                   1	     The backup operation has started.
#Informational	BACKUP_SUCCESS_STOP_EVENT	           3	     The backup operation has completed.
#Warning	    BACKUP_WARNING_STOP_EVENT	          10	     The backup operation has completed with warnings.
#Warning	    CBP_VERSION_UPGRADE_NTF_EVENT	      14	     A newer version of Windows Azure Backup Agent is required
#Warning	    CBP_STORAGE_QUOTA_EXCEEDED_NTF_EVENT  16	     Storage quota limit is approaching 80 percent

# Counters for last 24 Hrs
$backupSuccessStopEventCountDay = 0
$cbpVersionUpgradeNtfEventCountDay = 0

cls
$log = ""
$yesterday = (Get-Date) - (New-TimeSpan -Day 1)

#Get Log Counts for each event ids for yesterday
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '3' }
$backupSuccessStopEventCountDay = $log.Count

$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '14' }
$cbpVersionUpgradeNtfEventCountDay = $log.Count

# Initialize object for response
$obj = @{}

# MARS Agent Update required
if ($cbpVersionUpgradeNtfEventCountDay -gt 0) {
    # Return an update response
    $obj.updateStatus = "Update"
} else {
    $obj.updateStatus = ""
}

# Check if the last backup was successful or failed
if ($backupSuccessStopEventCountDay -eq 0) {
    # No Backup was successful yet
    # Return a failure response
    $obj.lastBackupStatus = "Failed"
} else {
    # Backup was successful
    # Return a success response
    $obj.lastBackupStatus = "Success"
}

# Prepare response object for CW Automate
$obj.eventLogYesterday = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Format-Table | Out-String
$Final = [string]::Join("|",($obj.GetEnumerator() | %{$_.Name + "=" + $_.Value}))

Write-Output $Final

# To read the output of this script in CW Automate
# Function: Variable Set
# Set Type: Split NameValue Parameter
# Parameter: @AllVariables@ or whatever was set