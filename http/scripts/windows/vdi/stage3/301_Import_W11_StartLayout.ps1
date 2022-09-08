Param(
  [string]$env:softwarerepo,
  [string]$env:w11_startlayout_dirname,
  [string]$env:w11_startlayout_xmlfile,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Import Default Start Menu Tiles and Taskbar Icons..."
Copy-Item -Path "$env:softwarerepo\$env:w11_startlayout_dirname\$env:w11_startlayout_xmlfile" -Destination "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell" -Force | Out-Null

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y