Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:powershell_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:powershell_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:powershell_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:powershell_dirname\*" -Destination "$env:tempsoft_path\$env:powershell_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Microsoft PowerShell..."
$InstallExitCode = InstallMSI -MSIName "$env:powershell_dirname" -MSIArgs "/quiet ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL

  # DISABLE AUTOUPDATE CHECKS
  Write-Host "Disabling PowerShell 7 AutoUpdate Checks..."
  [System.Environment]::SetEnvironmentVariable('POWERSHELL_UPDATECHECK','Off',[System.EnvironmentVariableTarget]::Machine)
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:powershell_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y