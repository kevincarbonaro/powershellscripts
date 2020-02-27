# Veeam Backups Event Log Monitor

# Author: Kevin Carbonaro

# Event ID	 Name	                        Description	                                                                                                                       Severity
# 110        Backup job started	            <Job type> job '<Job name>' has been started.                                                                                      Info
# 190	     Backup job finished	        The <Job type> Job '<Job name>' has finished with <State name> state.                                                              Info,Warning,Error
# 24010	     License installed	            <license type> License key for Veeam Backup & Replication <edition> has been installed.                                            Info
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
$licenseSupportExpiredId = 24050

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
$backupJobFinishedInfoCountWeek = 0
$backupJobFinishedWarningCountWeek = 0
$backupJobFinishedErrorCountWeek = 0
$licenseInstalledCountWeek = 0
$licenseExpiringCountWeek = 0
$licenseEvaluationExpiringCountWeek = 0
$licenseExpiredCountWeek = 0
$licenseSupportExpiringCountWeek = 0
$licenseSupportExpired = 0

# Counters for last 24 Hrs
$backupJobStartedCountDay = 0
$backupJobFinishedInfoCountDay = 0
$backupJobFinishedWarningCountDay = 0
$backupJobFinishedErrorCountDay = 0
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

#Get Log Counts for each  ids for week
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '110' }
$backupJobStartedCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedInfoCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedWarningCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedErrorCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24010' }
$licenseInstalledCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24020' }
$licenseExpiringCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24022' }
$licenseEvaluationExpiringCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24030' }
$licenseExpiredCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24040' }
$licenseSupportExpiringCountWeek = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$week } | Where-Object { $_.Id -eq '24050' }
$licenseSupportExpiredCountWeek = $log.Count

#Get Log Counts for each event ids for yesterday
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '110' }
$backupJobStartedCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedInfoCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedWarningCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '190' }
$backupJobFinishedErrorCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24010' }
$licenseInstalledCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24020' }
$licenseExpiringCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24022' }
$licenseEvaluationExpiringCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24030' }
$licenseExpiredCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24040' }
$licenseSupportExpiringCountDay = $log.Count
$log = Get-Win -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Where-Object { $_.Id -eq '24050' }
$licenseSupportExpiredCountDay = $log.Count

# Initialize object for response
$obj = @{}

# ******************** TO DO LOGIC *******************
if ($backupSuccessStopEventCountDay -eq 0) {
    # No Backup was successful yet
    # Return a failure response
    $obj.lastBackupStatus = "Failed"
} else {
    # Backup was successful
    # Return a success response
    $obj.lastBackupStatus = "Success"    
}

# Prepare object for CW Automate
$obj.eventLogYesterday = Get-WinEvent -FilterHashtable @{ LogName='Veeam Backup'; StartTime=$yesterday } | Format-Table | Out-String
$Final = [string]::Join("|",($obj.GetEnumerator() | %{$_.Name + "=" + $_.Value}))

Write-Output $Final

# To read the output of this script in CW Automate
# Function: Variable Set
# Set Type: Split NameValue Parameter
# Parameter: @AllVariables@ or whatever was set
