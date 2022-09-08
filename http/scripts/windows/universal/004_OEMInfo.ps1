Param(
  [string]$env:uuid,
  [string]$env:organization_name,
  [string]$env:support_hours,
  [string]$env:support_phone_number,
  [string]$env:support_url
)

$ErrorActionPreference = 'Stop'

$RegPath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\OEMInformation"

Write-Host "Set Windows OEM Information..."
Clear-Item -Path $RegPath | Out-Null
New-Item -Path $RegPath -type Directory -Force | Out-Null
New-ItemProperty -path $RegPath -Name Logo -PropertyType String -Value "C:\Windows\OEM\OEMLogo.bmp" | Out-Null
New-ItemProperty -path $RegPath -Name Manufacturer -PropertyType String -Value $env:organization_name | Out-Null
New-ItemProperty -path $RegPath -Name Model -PropertyType String -Value "Image ID = $env:uuid" | Out-Null
New-ItemProperty -path $RegPath -Name SupportHours -PropertyType String -Value $env:support_hours | Out-Null
New-ItemProperty -path $RegPath -Name SupportPhone -PropertyType String -Value $env:support_phone_number | Out-Null
New-ItemProperty -path $RegPath -Name SupportURL -PropertyType String -Value $env:support_url | Out-Null