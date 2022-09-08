Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:chrome_enterprise_dirname,
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
if( -not (Test-Path -Path "$env:tempsoft_path\$env:chrome_enterprise_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:chrome_enterprise_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:chrome_enterprise_dirname\*" -Destination "$env:tempsoft_path\$env:chrome_enterprise_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Google Chrome Enterprise..."
$InstallExitCode = InstallMSI -MSIName "$env:chrome_enterprise_dirname" -MSIArgs "/qn REBOOT=ReallySuppress"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	# COPY MASTER PREFERENCES FILE
	Write-Host "Copying Google Chrome Master Preferences file..."
	Copy-Item -Path "$env:tempsoft_path\$env:chrome_enterprise_dirname\master_preferences.txt" -Destination "${env:ProgramFiles}\Google\Chrome\Application\master_preferences.txt" -Recurse -Force | Out-Null
	Remove-Item "${env:ProgramFiles}\Google\Chrome\Application\master_preferences" -Force | Out-Null
	Rename-Item "${env:ProgramFiles}\Google\Chrome\Application\master_preferences.txt" master_preferences -Force | Out-Null
		
	# DELETE START MENU & DESKTOP SHORTCUT(S)
	Write-Host "Deleting Google Chrome Start Menu & Desktop shortcut(s)..."
	Remove-Item -Path "C:\Users\Public\Desktop\Google Chrome.lnk" -Recurse -Force | Out-Null
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk" -Recurse -Force | Out-Null
		
	# UNINSTALL GOOGLE UPDATER
	Write-Host "Uninstall and Disable Google Updater..."
	Stop-Service -Name "gupdate" -Force -Confirm:$false
	Set-Service -Name "gupdate" -StartupType Disabled -Confirm:$false
	Stop-Service -Name "gupdatem" -Force -Confirm:$false
	Set-Service -Name "gupdatem" -StartupType Disabled -Confirm:$false
	Stop-Service -Name "GoogleChromeElevationService" -Force -Confirm:$false
	Set-Service -Name "GoogleChromeElevationService" -StartupType "Disabled" -Confirm:$false
	Start-Process -Wait -NoNewWindow "${env:ProgramFiles(x86)}\Google\Update\GoogleUpdate.exe" -ArgumentList "-uninstall" | Out-Null
	Unregister-ScheduledTask -TaskName *Google* -Confirm:$false | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Update" -Value 1 -PropertyType dword -Name "DisableAutoUpdateChecksCheckboxValue" -Force | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Update" -Value 0 -PropertyType dword -Name "AutoUpdateCheckPeriodMinutes" -Force | Out-Null
	New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Google\Update" -Value 0 -PropertyType dword -Name "UpdateDefault" -Force | Out-Null
	Rename-Item -Path "${env:ProgramFiles(x86)}\Google\Update\GoogleUpdate.exe" "${env:ProgramFiles(x86)}\Google\Update\NoGoogleUpdate.exe" -Force -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL	
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:chrome_enterprise_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y