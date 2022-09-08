Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:bginfo_dirname,
  [string]$env:bginfo_conffile,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:Programfiles\$env:bginfo_dirname" ) ) { New-Item -ItemType directory -Path "$env:Programfiles\$env:bginfo_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:bginfo_dirname\*" -Destination "$env:Programfiles\$env:bginfo_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Microsoft BGinfo..."
Start-Process -Wait -NoNewWindow "$env:Programfiles\$env:bginfo_dirname\bginfo64.exe" -ArgumentList "`"$env:Programfiles\$env:bginfo_dirname\$env:bginfo_conffile`" /timer:0 /nolicprompt /silent"

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y