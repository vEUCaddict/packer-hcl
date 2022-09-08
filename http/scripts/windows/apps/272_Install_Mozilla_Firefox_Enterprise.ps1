Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:firefox_enterprise_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:firefox_enterprise_dirname\*" -Destination "$env:tempsoft_path\$env:firefox_enterprise_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Mozilla Firefox Enterprise..."
$InstallExitCode = InstallMSI -MSIName "$env:firefox_enterprise_dirname" -MSIArgs "/TaskbarShortcut=false /DesktopShortcut=false /StartMenuShortcut=true /MaintenanceService=false /PreventRebootRequired=true"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	# CONFIG MOZILLA FIREFOX FIRST TIME START
	Write-Host "Copying Preconfigured Mozilla FireFox Settings..."
	Copy-Item -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname\local-settings.js" -Destination "${env:ProgramFiles}\Mozilla Firefox\defaults\pref" -Recurse -Force | Out-Null
	Copy-Item -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname\mozilla.cfg" -Destination "${env:ProgramFiles}\Mozilla Firefox" -Recurse -Force | Out-Null
	Copy-Item -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname\override.ini" -Destination "${env:ProgramFiles}\Mozilla Firefox\browser" -Recurse -Force | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL	
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:firefox_enterprise_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y