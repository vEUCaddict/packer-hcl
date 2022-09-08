Param(
  [string]$env:psfunction_path,
  [string]$env:sadomjoin,
  [string]$env:domainname,
  [string]$env:appvolcapou
)

$ErrorActionPreference = 'Stop'

Write-Host "Adding App Volumes Capture VM to the domain..."
[Byte[]] $key = (1..16)
$Encrypted = Get-Content "$env:psfunction_path\DOMJOIN.pwd" | ConvertTo-SecureString -Key $key
$Credential = New-Object System.Management.Automation.PSCredential($env:sadomjoin,$Encrypted)
Add-Computer -DomainName "$env:domainname" -Credential $Credential -OUPath "$env:appvolcapou" -Confirm:$false -Force