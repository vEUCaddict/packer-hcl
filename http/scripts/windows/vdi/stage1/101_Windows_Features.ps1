Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:dotnetframeworklegacy_dirname,
  [string]$env:dotnetframeworklegacy_inst,
  [string]$env:username,
  [SecureString]$env:password
)

Write-Host "Disabling Windows Features..."

$disablefeatures = @(
    #"Microsoft-Windows-Printing-XPSServices-Package"
    #"Windows-Defender-Default-Definitions"
    "Printing-Foundation-InternetPrinting-Client"
    "Printing-Foundation-Features"
    "WorkFolders-Client"
)

$ErrorActionPreference = 'Stop'

foreach ($disablefeature in $disablefeatures) {
  Write-Host "Disabling $disablefeature"
        Disable-WindowsOptionalFeature -Online -FeatureName $disablefeature -NoRestart | Out-Null
}

Write-Host "Enabling Windows Features..."

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:dotnetframeworklegacy_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:dotnetframeworklegacy_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:dotnetframeworklegacy_dirname\*" -Destination "$env:tempsoft_path\$env:dotnetframeworklegacy_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Enabling Microsoft .NET Framework 3.5..."
dism /online /add-package /packagepath:"$env:tempsoft_path\$env:dotnetframeworklegacy_dirname\$env:dotnetframeworklegacy_inst" /NoRestart | Out-Null

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:dotnetframeworklegacy_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y