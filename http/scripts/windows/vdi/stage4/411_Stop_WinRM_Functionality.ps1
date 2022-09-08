$ErrorActionPreference = 'Stop'

# Stop WinRM Functionality
Write-Host "Stopping the WinRM functionality..."

# Delete WinRM firewall rule
netsh advfirewall firewall delete rule name="WINRM-HTTPS-In-TCP"

# Delete Selfsigned Certificate for WinRM by subject (name)
Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -match 'packer' } | Remove-Item -Force | Out-Null

# Stop WinRM service
Stop-Service -Name "winrm" -Force -Confirm:$false
Set-Service -Name "winrm" -StartupType Disabled -Confirm:$false

# Disable Built-in Local Administrator account
Disable-LocalUser -Name "Administrator" | Out-Null