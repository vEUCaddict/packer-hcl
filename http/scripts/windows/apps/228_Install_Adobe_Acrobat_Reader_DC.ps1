Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:acrobat_reader_dc_dirname,
  [string]$env:acrobat_reader_dc_patch_filename,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:acrobat_reader_dc_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:acrobat_reader_dc_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:acrobat_reader_dc_dirname\*" -Destination "$env:tempsoft_path\$env:acrobat_reader_dc_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Adobe Acrobat Reader DC..."
$InstallExitCode = InstallMSI -MSIName "$env:acrobat_reader_dc_dirname" -MSIArgs "/q /b REBOOT=ReallySuppress"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL

	#UPDATE ADOBE ACROBAT READER DC TO LATEST PATCH LEVEL
	Write-Host "Update Adobe Acrobat Reader DC to lastest patch level..."
	Start-Process msiexec -Wait -NoNewWindow -ArgumentList "/p `"$env:tempsoft_path\$env:acrobat_reader_dc_dirname\$env:acrobat_reader_dc_patch_filename`" /qn"

	#DISABLE ADOBE ACROBAT READER AUTO UPDATE
	Write-Host "Disable Adobe Acrobat Reader Auto Update features..."
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Adobe\Adobe ARM\1.0\ARM" -Value 0 -PropertyType dword -Name "iCheck" -Force | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Adobe\Adobe ARM\1.0\ARM" -Value 0 -PropertyType dword -Name "iCheckReader" -Force | Out-Null
	New-Item -Path "HKLM:\Software\Wow6432Node\Policies\Adobe" -Force -Confirm:$false | Out-Null
	New-Item -Path "HKLM:\Software\Wow6432Node\Policies\Adobe\Acrobat Reader" -Force -Confirm:$false | Out-Null
	New-Item -Path "HKLM:\Software\Wow6432Node\Policies\Adobe\Acrobat Reader\DC" -Force -Confirm:$false | Out-Null
	New-Item -Path "HKLM:\Software\Wow6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Force -Confirm:$false | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Value 0 -PropertyType dword -Name "bUpdater" -Force | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown" -Value 0 -PropertyType dword -Name "bProtectedMode" -Force | Out-Null

	Stop-Service -Name "AdobeARMservice" -Force
	Set-Service -Name "AdobeARMservice" -StartupType "Disabled"

	# DELETE ADOBE ACROBAT READER DC START MENU & DESKTOP SHORTCUT(S)
	# Write-Host "Deleting Adobe Acrobat Reader DC Start Menu & Desktop shortcut(s)..."
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Acrobat Reader DC.lnk" -Force -Confirm:$false | Out-Null

	Write-Host "Disable AutoUpdate Scheduled Task from Adobe Acrobat at User Logon..."
	$taskName = "Adobe Acrobat Update Task"
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
Remove-Item -Path "$env:tempsoft_path\$env:acrobat_reader_dc_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y