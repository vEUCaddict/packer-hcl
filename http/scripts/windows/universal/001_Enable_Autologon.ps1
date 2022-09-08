Param(
  [string]$env:psfunction_path,
  [string]$env:winrm_username,
  [SecureString]$env:winrm_password,
  [string]$env:vm_name
)

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\Test-RegistryValue.ps1" -Force # Checks if Registry value exists

$ErrorActionPreference = 'Stop'

Write-Host "Enable Temporary Autologon for the local Administrator account..."
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "DefaultUserName" ) ) { New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Type String -Value "$env:winrm_username" | Out-Null } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Type String -Value "$env:winrm_username" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "DefaultPassword" ) ) { New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Type String -Value "$env:winrm_password" | Out-Null } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Type String -Value "$env:winrm_password" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "DefaultDomainName" ) ) { New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Type String -Value "$env:vm_name" } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Type String -Value "$env:vm_name" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "AutoAdminLogon" ) ) { New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Type String -Value "1" | Out-Null } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Type String -Value "1" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "AutoLogonCount" ) ) { New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Type Dword -Value "5" | Out-Null } else { Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoLogonCount" -Type Dword -Value "5" | Out-Null }