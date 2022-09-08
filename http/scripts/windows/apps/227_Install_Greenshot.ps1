Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:greenshot_dirname,
  [string]$env:greenshot_inst,
  [string]$env:greenshot_conffile,
  [string]$env:username,
  [SecureString]$env:password
)

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:greenshot_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:greenshot_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:greenshot_dirname\*" -Destination "$env:tempsoft_path\$env:greenshot_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Greenshot..."
Start-Process -NoNewWindow -FilePath "$env:tempsoft_path\$env:greenshot_dirname\$env:greenshot_inst" -ArgumentList "/SILENT /NOCANCEL /RESTARTEXITCODE=0"
Start-Sleep 90
# STOP OPENWITH PROCESS
if ($Null -eq (Get-Process -ProcessName "OpenWith" -ErrorAction SilentlyContinue)) { 
  Write-Host "There is no OpenWith process running..." 
}
else { 
  Write-Host "OpenWith is running, now stop it..."
  Stop-Process -ProcessName "OpenWith" -Force | Out-Null
}

# STOP MICROSOFT EDGE PROCESS
if ($Null -eq (Get-Process -ProcessName "msedge" -ErrorAction SilentlyContinue)) { 
  Write-Host "There is no Microsoft Edge Enterprise process running..." 
}
else { 
  Write-Host "Microsoft Edge Enterprise is running, now stop it..."
  Stop-Process -ProcessName "msedge" -Force | Out-Null
}

# STOP GREENSHOT PROCESS
if ($Null -eq (Get-Process -ProcessName "Greenshot" -ErrorAction SilentlyContinue)) { 
  Write-Host "There is no Greenshot process running..." 
}
else { 
  Write-Host "Greenshot is running, now stop it..."
  Stop-Process -ProcessName "Greenshot" -Force | Out-Null
}
Start-Sleep 5

# COPY GREENSHOT CONFIGURATION FILE
Write-Host "Copying Greenshot configuration file..."
Copy-Item -Path "$env:tempsoft_path\$env:greenshot_dirname\$env:greenshot_conffile" -Destination "$env:Programfiles\Greenshot\$env:greenshot_conffile" -Recurse -Force | Out-Null
		
# DELETE START MENU & DESKTOP SHORTCUT(S)
Write-Host "Deleting Greenshot Start Menu & Desktop shortcut(s)..."
#Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Greenshot" -Recurse -Force | Out-Null
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Greenshot\License.txt.lnk" -Force -Confirm:$false | Out-Null
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Greenshot\Readme.txt.lnk" -Force -Confirm:$false | Out-Null
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Greenshot\Uninstall Greenshot.lnk" -Force -Confirm:$false | Out-Null
	
# DISABLE AUTO START ON WINDOWS VDI
Write-Host "Disabling Automatic Start at Windows login..."
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Greenshot" -Force -Confirm:$false | Out-Null

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:greenshot_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y