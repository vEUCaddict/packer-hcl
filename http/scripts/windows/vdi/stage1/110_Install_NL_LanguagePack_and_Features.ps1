# INSTALL MICROSOFT WINDOWS 10 - DUTCH LANGUAGE PACK

Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:dutchlp_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:dutchlp_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:dutchlp_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:dutchlp_dirname\*" -Destination "$env:tempsoft_path\$env:dutchlp_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing the Windows 10 - Dutch Language Pack..."
dism /online /Add-Package /PackagePath:"$env:tempsoft_path\$env:dutchlp_dirname\Microsoft-Windows-Client-LanguagePack-Package_nl-nl~31bf3856ad364e35~amd64~nl-nl~.cab" /Quiet /NoRestart

Write-Host "Installing the Windows 10 - Dutch Basic Language Feature..."
dism /online /Add-Package /PackagePath:"$env:tempsoft_path\$env:dutchlp_dirname\Microsoft-Windows-LanguageFeatures-Basic-nl-nl-Package~31bf3856ad364e35~amd64~~.cab" /Quiet /NoRestart

Write-Host "Installing the Windows 10 - Dutch Handwriting Language Feature..."
dism /online /Add-Package /PackagePath:"$env:tempsoft_path\$env:dutchlp_dirname\Microsoft-Windows-LanguageFeatures-Handwriting-nl-nl-Package~31bf3856ad364e35~amd64~~.cab" /Quiet /NoRestart

Write-Host "Installing the Windows 10 - Dutch OCR Language Feature..."
dism /online /Add-Package /PackagePath:"$env:tempsoft_path\$env:dutchlp_dirname\Microsoft-Windows-LanguageFeatures-OCR-nl-nl-Package~31bf3856ad364e35~amd64~~.cab" /Quiet /NoRestart

Write-Host "Installing the Windows 10 - Dutch TextToSpeech Language Feature..."
dism /online /Add-Package /PackagePath:"$env:tempsoft_path\$env:dutchlp_dirname\Microsoft-Windows-LanguageFeatures-TextToSpeech-nl-nl-Package~31bf3856ad364e35~amd64~~.cab" /Quiet /NoRestart

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y