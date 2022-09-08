Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:vlc_player_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:vlc_player_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:vlc_player_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:vlc_player_dirname\*" -Destination "$env:tempsoft_path\$env:vlc_player_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing VideoLAN VLC media player..."
$InstallExitCode = InstallMSI -MSIName "$env:vlc_player_dirname" -MSIArgs "/S"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	Write-Host "Deleting VideoLAN VLC Player Start Menu & Desktop shortcut(s)..."
	#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN" -Recurse -Force | Out-Null
	Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\Documentation.lnk" -Force -Confirm:$false | Out-Null
	Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\Release Notes.lnk" -Force -Confirm:$false | Out-Null
	Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\VideoLAN\VideoLAN Website.lnk" -Force -Confirm:$false | Out-Null
	Remove-Item -Path "C:\Users\Public\Desktop\VLC media player.lnk" -Force -Confirm:$false | Out-Null
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:vlc_player_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y