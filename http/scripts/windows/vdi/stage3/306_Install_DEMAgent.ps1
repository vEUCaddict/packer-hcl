Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:dem_agent_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:dem_agent_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:dem_agent_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:dem_agent_dirname\*" -Destination "$env:tempsoft_path\$env:dem_agent_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing VMware Dynamic Environment Manager (DEM) Agent..."
$InstallExitCode = InstallMSI -MSIName "$env:dem_agent_dirname" -MSIArgs "/qn ADDLOCAL=FlexEngine,FlexProfilesSelfSupport"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	Write-Host "Deleting VMware Dynamic Environment Manager (DEM) Start Menu & Desktop shortcut(s)..."
	Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VMware DEM" -Recurse -Force -Confirm:$false | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:dem_agent_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y