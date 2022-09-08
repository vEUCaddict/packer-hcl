Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:edge_enterprise_dirname,
  [string]$env:edge_enterprise_version,
  [string]$env:username,
  [SecureString]$env:password,
  [string]$env:winrm_username,
  [SecureString]$env:winrm_password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:edge_enterprise_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:edge_enterprise_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:edge_enterprise_dirname\*" -Destination "$env:tempsoft_path\$env:edge_enterprise_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Microsoft Edge Enterprise..."
$msedge_file = (Get-Item "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe").VersionInfo
if ($msedge_file.ProductVersion -eq "$env:edge_enterprise_version" -or $msedge_file.ProductVersion -gt "$env:edge_enterprise_version" ) {
	Write-Host "This version of higher Microsoft Edge Enterprise ($env:edge_enterprise_version) is already installed, probably during autoupdate in Windows!"

	# DELETE START MENU SHORTCUT(S) IN WINDOWS 10
	#$winversion = (Get-WmiObject Win32_OperatingSystem).Version
	#if ($winversion -like "10.0.1*" ) {
	#	Write-Host "Deleting Microsoft Edge Enterprise desktop shortcut..."
	#	Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Edge.lnk" -Recurse -Force | Out-Null
	#	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Recurse -Force | Out-Null
	#}

	# DISABLE AUTOUPDATE FUNCTIONALITY
	Write-Host "Disable AutoUpdate Scheduled Tasks from Microsoft Edge at User Logon..."
	$taskName = "MicrosoftEdgeUpdateTaskMachineCore"
	$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
	if ($taskExists.TaskName -eq "$taskName") { 
		Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
		Write-Host "Scheduled Task: `"$($taskExists.TaskName)`" is set to disabled!"
	} 
	else { 
		Write-Host "Scheduled Task: `"$($taskExists.TaskName)`" doesn't exists..."
	}

	$taskName = "MicrosoftEdgeUpdateTaskMachineUA"
	$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
	if ($taskExists.TaskName -eq "$taskName") { 
		Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
		Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
	} 
	else { 
		Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
	}

	$taskName = "MicrosoftEdgeUpdateBrowserReplacementTask"
	$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
	if ($taskExists.TaskName -eq "$taskName") { 
		Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
		Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
	} 
	else { 
		Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
	}

	Write-Host "Disable Microsoft Edge update services..."
	Stop-Service -Name "edgeupdate" -Force -Confirm:$false
	Set-Service -Name "edgeupdate" -StartupType "Disabled" -Confirm:$false
	Stop-Service -Name "edgeupdatem" -Force -Confirm:$false
	Set-Service -Name "edgeupdatem" -StartupType "Disabled" -Confirm:$false
	Stop-Service -Name "MicrosoftEdgeElevationService" -Force -Confirm:$false
	Set-Service -Name "MicrosoftEdgeElevationService" -StartupType "Disabled" -Confirm:$false
	if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Force -Confirm:$false | Out-Null }
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "AutoUpdateCheckPeriodMinutes" -Type dword -Value "0" | Out-Null
	Rename-Item -Path "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\NoMicrosoftEdgeUpdate.exe" -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}
else {
	$InstallExitCode = InstallMSI -MSIName "$env:edge_enterprise_dirname" -MSIArgs "/qn REBOOT=ReallySuppress"
	if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) { 
		# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL

		# DELETE START MENU SHORTCUT(S) IN WINDOWS 10
		#$winversion = (Get-WmiObject Win32_OperatingSystem).Version
		#if ($winversion -like "10.0.1*" ) {
		#	Write-Host "Deleting Microsoft Edge Enterprise desktop shortcut..."
		#	Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Edge.lnk" -Recurse -Force | Out-Null
		#	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Recurse -Force | Out-Null
		#}
		
		# DISABLE AUTOUPDATE FUNCTIONALITY
		Write-Host "Disable AutoUpdate Scheduled Tasks from Microsoft Edge at User Logon..."
		$taskName = "MicrosoftEdgeUpdateTaskMachineCore"
		$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
		if ($taskExists.TaskName -eq "$taskName") { 
			Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
			Write-Host "Scheduled Task: `"$($taskExists.TaskName)`" is set to disabled!"
		} 
		else { 
			Write-Host "Scheduled Task: `"$($taskExists.TaskName)`" doesn't exists..."
		}

		$taskName = "MicrosoftEdgeUpdateTaskMachineUA"
		$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
		if ($taskExists.TaskName -eq "$taskName") { 
			Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
			Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
		} 
		else { 
			Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
		}

		$taskName = "MicrosoftEdgeUpdateBrowserReplacementTask"
		$taskExists = Get-ScheduledTask -TaskName "$taskName" -ErrorAction SilentlyContinue
		if ($taskExists.TaskName -eq "$taskName") { 
			Get-ScheduledTask -TaskName $taskExists.TaskName | Disable-ScheduledTask | Out-Null 
			Write-Host "Scheduled Task: `"$($taskName)`" is set to disabled!"
		} 
		else { 
			Write-Host "Scheduled Task: `"$($taskName)`" doesn't exists..."
		}
		
		Write-Host "Disable Microsoft Edge update services..."
		Stop-Service -Name "edgeupdate" -Force -Confirm:$false
		Set-Service -Name "edgeupdate" -StartupType "Disabled" -Confirm:$false
		Stop-Service -Name "edgeupdatem" -Force -Confirm:$false
		Set-Service -Name "edgeupdatem" -StartupType "Disabled" -Confirm:$false
		Stop-Service -Name "MicrosoftEdgeElevationService" -Force -Confirm:$false
		Set-Service -Name "MicrosoftEdgeElevationService" -StartupType "Disabled" -Confirm:$false
		if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Force -Confirm:$false | Out-Null }
		New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "AutoUpdateCheckPeriodMinutes" -Type dword -Value "0" | Out-Null
		Rename-Item -Path "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\NoMicrosoftEdgeUpdate.exe" -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
	}
	else {
		# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
	}
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:edge_enterprise_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y