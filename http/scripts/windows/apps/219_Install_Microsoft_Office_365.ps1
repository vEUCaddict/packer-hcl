Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:office_365_dirname,
  [string]$env:office_365_confinst,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:office_365_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:office_365_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:office_365_dirname\*" -Destination "$env:tempsoft_path\$env:office_365_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Microsoft Office 365 Apps for Enterprise..."
$InstallExitCode = InstallMSI -MSIName "$env:office_365_dirname" -MSIArgs "/configure `"$env:tempsoft_path\$env:office_365_dirname\$env:office_365_confinst`""
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
		
	#"Removing Microsoft Office 365 Apps for Enterprise - Start Menu Shortcuts..." > ADVISE IS NOT TO DELETE (OUTLOOK) SHORTCUT(S), BECAUSE OF E-MAIL NOTIFICATIONS WON'T WORK WITH CUSTOM START MENU SHORTCUTS
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Access 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Project.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Publisher 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Skype for Business.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visio.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneNote 2016.lnk" -Recurse -Force
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneDrive for Business.lnk" -Recurse -Force
	
	Write-Host "Disable Telemetry Scheduled Tasks from Microsoft Office 2016 at User Logon..."
	$taskName = "OfficeTelemetryAgentLogOn2016"
	$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
	if ($taskExists.TaskName -eq "$taskName") { 
		Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
		Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
	} 
	else { 
		Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
	}

	$taskName = "OfficeTelemetryAgentFallBack2016"
	$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
	if ($taskExists.TaskName -eq "$taskName") { 
		Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
		Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
	} 
	else { 
		Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
	}
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:office_365_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y