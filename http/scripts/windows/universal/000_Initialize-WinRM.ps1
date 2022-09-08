# A Packer config that works with this example would be:
#
#
#    "winrm_username": "Administrator",
#    "winrm_password": "SuperS3cr3t!!!",
#    "winrm_insecure": true,
#    "winrm_use_ssl": true
#
#

# Create username and password
#net user Administrator SuperS3cr3t!!!
wmic useraccount where "name='Administrator'" set PasswordExpires=FALSE

Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

# Don't set this before Set-ExecutionPolicy as it throws an error
$ErrorActionPreference = "stop"

# Remove HTTP listener
Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

# Create a self-signed certificate to let ssl work
$CertificateThumbprint = (New-SelfSignedCertificate -DnsName "packer" -CertStoreLocation "Cert:\LocalMachine\My").Thumbprint

# WinRM
Write-Host "Setting up WinRM"

# Create WinRM listener
$listener = @{
    ResourceURI = "winrm/config/Listener"
    SelectorSet = @{Address="*";Transport="HTTPS"}
    ValueSet = @{CertificateThumbprint=$CertificateThumbprint}
  }
 New-WSManInstance @listener

# Enable WinRM Basic Authentication
Set-WSManInstance -ResourceURI WinRM/Config/Service/Auth -ValueSet @{Basic = "true"}

# Make sure appropriate firewall port openings exist
$rule = @{
    Name = "WINRM-HTTPS-In-TCP"
    DisplayName = "Windows Remote Management (HTTPS-In)"
    Description = "Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]"
    Enabled = "true"
    Direction = "Inbound"
    Profile = "Any"
    Action = "Allow"
    Protocol = "TCP"
    LocalPort = "5986"
  }
 New-NetFirewallRule @rule

# Restart WinRM, and set it so that it auto-launches on startup.
Stop-Service -Name "winrm" -Force -Confirm:$false
Set-Service -Name "winrm" -StartupType Automatic -Confirm:$false
Start-Service -Name "winrm" -Confirm:$false