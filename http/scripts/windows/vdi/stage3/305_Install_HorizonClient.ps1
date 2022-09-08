Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:horizon_client_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:horizon_client_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:horizon_client_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:horizon_client_dirname\*" -Destination "$env:tempsoft_path\$env:horizon_client_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing VMware Horizon Client..."
$InstallExitCode = InstallMSI -MSIName "$env:horizon_client_dirname" -MSIArgs "/silent /norestart DESKTOP_SHORTCUT=0 STARTMENU_SHORTCUT=1 AUTO_UPDATE_ENABLED=0"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:horizon_client_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y