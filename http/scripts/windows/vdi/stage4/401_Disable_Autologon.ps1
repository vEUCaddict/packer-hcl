# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\Test-RegistryValue.ps1" -Force # Checks if Registry value exists

$ErrorActionPreference = 'Stop'

Write-Host "Stop the AutoLogon of the Local Administrator account during image building..."
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "DefaultPassword" ) ) { } else { Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Force -Confirm:$false }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "AutoAdminLogon" ) ) { } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Type String -Value "0" }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "DefaultDomainName" ) ) { } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Type String -Value "" }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "AutoLogonCount" ) ) { } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Type Dword -Value "0" }