Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:vmwareosot_dirname,
  [string]$env:vmwareosot_inst,
  [string]$env:vmwareosot_tempxml,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:vmwareosot_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:vmwareosot_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:vmwareosot_dirname\*" -Destination "$env:tempsoft_path\$env:vmwareosot_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Running the VMware OS Optimization Tool..."
Start-Process -PassThru -FilePath "$env:tempsoft_path\$env:vmwareosot_dirname\$env:vmwareosot_inst" -ArgumentList "-o -v -t `"$env:tempsoft_path\$env:vmwareosot_dirname\$env:vmwareosot_tempxml`"" -Wait -NoNewWindow

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:vmwareosot_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y