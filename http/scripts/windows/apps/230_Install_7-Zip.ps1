Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:sevenzip_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:sevenzip_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:sevenzip_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:sevenzip_dirname\*" -Destination "$env:tempsoft_path\$env:sevenzip_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing 7-Zip..."
$InstallExitCode = InstallMSI -MSIName "$env:sevenzip_dirname" -MSIArgs "/qn"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	Write-Host "Deleting 7-Zip Start Menu & Desktop shortcut(s)..."
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip" -Recurse -Force | Out-Null
	Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\7-Zip\7-Zip Help.lnk" -Force -Confirm:$false | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:sevenzip_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y