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

# Event IDs for all type of errors
$backupErrorStopId = 11
$scheduleBackupFailedId = 18
$backupStartId = 1
$backupSuccessStopId = 3
$backupWarningStopId = 10
$cbpVersionUpgradeNtfId = 14
$cbpStorageQuotaExceededNtfId = 16

# Event IDs human readable error messages
$backupErrorStopMessage = "The backup operation has completed with errors."
$scheduleBackupFailedMessage = "Scheduled backup failed in initialization phase"
$backupStartMessage = "The backup operation has started."
$backupSuccessStopMessage = "The backup operation has completed."
$backupWarningStopMessage = "The backup operation has completed with warnings."
$cbpVersionUpgradeNtfMessage = "A newer version of Windows Azure Backup Agent is required"
$cbpStorageQuotaExceededNtfMessage = "Storage quota limit is approaching 80 percent."

# Counters for last 7 Days
$backupErrorStopEventCountWeek = 0
$scheduleBackupFailedEventCountWeek = 0
$backupStartEventCountWeek = 0
$backupSuccessStopEventCountWeek = 0
$backupWarningStopEventCountWeek = 0
$cbpVersionUpgradeNtfEventCountWeek = 0
$cbpStorageQuotaExceededNtfEventCountWeek = 0

# Counters for last 24 Hrs
$backupErrorStopEventCountDay = 0
$scheduleBackupFailedEventCountDay = 0
$backupStartEventCountDay = 0
$backupSuccessStopEventCountDay = 0
$backupWarningStopEventCountDay = 0
$cbpVersionUpgradeNtfEventCountDay = 0
$cbpStorageQuotaExceededNtfEventCountDay = 0

cls
$log = ""
$yesterday = (Get-Date) - (New-TimeSpan -Day 1)
$week = (Get-Date) - (New-TimeSpan -Day 6)

#Get Log Counts for each event ids for week
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '11' }
$backupErrorStopEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '18' }
$scheduleBackupFailedEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '1' }
$backupStartEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '3' }
$backupSuccessStopEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '10' }
$backupWarningStopEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '14' }
$cbpVersionUpgradeNtfEventCountWeek = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$week } | Where-Object { $_.Id -eq '16' }
$cbpStorageQuotaExceededNtfEventCountWeek = $log.Count

#Get Log Counts for each event ids for yesterday
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '11' }
$backupErrorStopEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '18' }
$scheduleBackupFailedEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '1' }
$backupStartEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '3' }
$backupSuccessStopEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '10' }
$backupWarningStopEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '14' }
$cbpVersionUpgradeNtfEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '16' }
$cbpStorageQuotaExceededNtfEventCountDay = $log.Count

# Initialize object for response
$obj = @{}

# MARS Agent Update required
if ($cbpVersionUpgradeNtfEventCountDay -gt 0) {
    # Return an update response
    $obj.updateStatus = "Update"
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