$ErrorActionPreference = 'Stop'

Write-Host "Disable Scheduled Tasks at User Logon to improve logon time..."

$taskName = "Device Install Reboot Required"
$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
if ($taskExists.TaskName -eq "$taskName") { 
	Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
	Write-Host "Scheduled Task: `"$($taskExists.TaskName)`" is set to disabled!"
} 
else { 
	Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
}

$taskName = "Adobe Flash Player Updater"
$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
if ($taskExists.TaskName -eq "$taskName") { 
	Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
	Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
} 
else { 
	Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
}

$taskName = "nWizard*"
$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
if ($taskExists.TaskName -eq "$taskName") { 
	Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
	Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
} 
else { 
	Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
}

<# ENABLE ONLY WHEN ONEDRIVE IS NOT USED!
$taskName = "OneDrive Standalone Update Task v2"
$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
if ($taskExists.TaskName -eq "$taskName") { 
	Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
	Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
} 
else { 
	Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
}
#>