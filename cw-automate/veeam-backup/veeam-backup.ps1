# Veeam Backups Event Log Monitor

# Author: Kevin Carbonaro

# Event ID	 Name	                        Description	                                                                                                                       Severity
# 110        Backup job started	            <Job type> job '<Job name>' has been started.                                                                                      Info
# 190	     Backup job finished	        The <Job type> Job '<Job name>' has finished with <State name> state.                                                              Info,Warning,Error
# 24010	     License installed	            <license type> License key for Veeam Backup & Replication <edition> has been installed.                                           Info
# 24020	     License expiring	            <license type> License key for Veeam Backup & Replication <edition>  is about to expire in <number of days> of Days.               Warning
# 24022	     License evaluation expiring	<licanse type> Evalution license key for Veeam Backup & Replication <edition>  is about to expire in <nuymber of days> of Days.    Warning
# 24030	     License expired	            <license type> License key for Veeam Backup & Replication <edition> has expired.                                                   Error
# 24040	     License support expiring	    Support contract for Veeam Backup & Replication is about to expire in <number of days> of Days.                                    Warning
# 24050	     License support expired	    Support contract for Veeam Backup & Replication has expired. Contact Veeam sales representative to renew your support contract.    Error


# Event IDs for all type of errors
$backupJobStartedId = 110
$backupJobFinishedId = 190
$licenseInstalledId = 24010
$licenseExpiringId = 24020
$licenseEvaluationExpiringId = 24022
$licenseExpiredId = 24030
$licenseSupportExpiringId = 24040
$licenseSupportExpired = 24050

# Event IDs human readable error messages
$backupJobStartedMessage = "Backup Job has started."
$backupJobFinishedInfoMessage = "Backup Job has finished successfully."
$backupJobFinishedWarningMessage = "Backup Job has finished with warning."
$backupJobFinishedErrorMessage = "Backup Job has finished with errors."
$licenseInstalledMessage = "License has been installed"
$licenseExpiringMessage = "License is expiring."
$licenseEvaluationExpiringMessage = "Evaluation license is expiring."
$licenseExpiredMessage = "License expired."
$licenseSupportExpiringMessage = "Support contract license is expiring."
$licenseSupportExpired = "Support contract license has expired."

# Counters for last 7 Days
$backupJobStartedCountWeek = 0
$backupJobFinishedCountWeek = 0
$licenseInstalledCountWeek = 0
$licenseExpiringCountWeek = 0
$licenseEvaluationExpiringCountWeek = 0
$licenseExpiredCountWeek = 0
$licenseSupportExpiringCountWeek = 0
$licenseSupportExpired = 0

# Counters for last 24 Hrs
$backupJobStartedCountDay = 0
$backupJobFinishedCountDay = 0
$licenseInstalledCountDay = 0
$licenseExpiringCountDay = 0
$licenseEvaluationExpiringCountDay = 0
$licenseExpiredCountDay = 0
$licenseSupportExpiringCountDay = 0
$licenseSupportExpired = 0

cls
$log = ""
$yesterday = (Get-Date) - (New-TimeSpan -Day 1)
$week = (Get-Date) - (New-TimeSpan -Day 6)

# **************************************************************************
# ***** TODO: Modify below code for Veeam backup Job Monitoring Logic ******
# **************************************************************************

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
$cbpVersionUpgraeNtfEventCountWeek = $log.Count
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
$cbpVersionUpgraeNtfEventCountDay = $log.Count
$log = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '16' }
$cbpStorageQuotaExceededNtfEventCountDay = $log.Count

if ($backupSuccessStopEventCountDay -eq 0) {
    # No Backup was successful yet
    # Return a failure response
    $obj = @{}
    $obj.lastBackupStatus = "Failed"
    $obj.eventLogYesterday = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Format-Table | Out-String
    $Final = [string]::Join("|",($obj.GetEnumerator() | %{$_.Name + "=" + $_.Value}))
} else {
    # Backup was successful
    # Return a success response
    $obj = @{}
    $obj.lastBackupStatus = "Success"
    $obj.eventLogYesterday = Get-WinEvent -FilterHashtable @{ LogName='CloudBackup'; StartTime=$yesterday } | Format-Table | Out-String
    $Final = [string]::Join("|",($obj.GetEnumerator() | %{$_.Name + "=" + $_.Value}))
}

Write-Output $Final

# To read the output of this script in CW Automate
# Function: Variable Set
# Set Type: Split NameValue Parameter
# Parameter: @AllVariables@ or whatever was set
