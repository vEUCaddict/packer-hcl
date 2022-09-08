# HIDE MOST DEFENDER SECURITY CENTER ITEMS IN WINDOWS 10 (USED FOR W10 GOLDEN IMAGE)

Param(
  [string]$env:organization_name,
  [string]$env:support_phone_number,
  [string]$env:support_url
)

$ErrorActionPreference = 'Stop'

# HIDE WINDOWS DEFENDER SECURITY CENTER WARNING ICON FOR SIGNING IN WITH A LOCAL PROFILE
Write-Host "Hiding Security Center warning icon for having a local profile..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows Security Health\State" ) ) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Security Health\State" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Security Health\State" -Value 0 -PropertyType dword -Name "AccountProtection_MicrosoftAccount_Disconnected" -Force | Out-Null

# HIDE ACCOUNT PROTECTION SECTION IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the Account Protection section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# HIDE FIREWALL & NETWORK PROTECTION SECTION IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the Firewall & Network Protection section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# HIDE APP & BROWSER CONTROL IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the App & Browser Control section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# HIDE DEVICE SECURITY IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the Device Security section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# HIDE DEVICE PERFORMANCE & HEALTH IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the Device Performance & Health section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# HIDE FAMILY OPTIONS SECTION IN WINDOWS DEFENDER SECURITY CENTER
Write-Host "Hiding the Family Options section in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" -Value 1 -PropertyType dword -Name "UILockdown" -Force | Out-Null

# SECURITY CENTER ENTERPRISE CUSTOMIZATION
Write-Host "Customize Company Information in the Security Center..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Name CompanyName -PropertyType String -Value $env:organization_name | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Name Phone -PropertyType String -Value $env:support_phone_number | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Name Url -PropertyType String -Value $env:support_url | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Name EnableForToasts -PropertyType DWORD -Value 1 | Out-Null
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Enterprise Customization" -Name EnableInApp -PropertyType DWORD -Value 1 | Out-Null