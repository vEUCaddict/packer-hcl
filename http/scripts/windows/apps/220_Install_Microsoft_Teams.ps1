Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:teams_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:teams_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:teams_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:teams_dirname\*" -Destination "$env:tempsoft_path\$env:teams_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Microsoft Teams - Machine Wide Installer..."
$InstallExitCode = InstallMSI -MSIName "$env:teams_dirname" -MSIArgs "/qn ALLUSER=1 ALLUSERS=1"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
  
  # LET TEAMS KNOW IT IS A NON PERSISTENT VDI IMAGE
  Write-Host "Let Microsoft Teams installer know that it is a non-persistent VDI image..."
  if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Teams" ) ) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Force -Confirm:$false | Out-Null }
  New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Teams" -Name "IsWVDEnvironment" -Type dword -Value "1" | Out-Null

  # DELETE START MENU & DESKTOP SHORTCUT(S)
  Write-Host "Deleting Microsoft Teams Desktop shortcut(s)..."
  #Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Teams.lnk" -Force -Confirm:$false | Out-Null
  #Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Teams.lnk" -Force -Confirm:$false | Out-Null

  # DISABLE AUTOSTART DURING LOGON
  Write-Host "Deleting Microsoft Teams AutoStart Functionality..."
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "Teams" -Force -Confirm:$false | Out-Null
  #Remove-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" -Name "TeamsMachineInstaller" -Force -Confirm:$false | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:teams_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y