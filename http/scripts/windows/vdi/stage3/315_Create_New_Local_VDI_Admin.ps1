Param(
  [string]$env:psfunction_path,
  [string]$env:localvdiadmin
)

$ErrorActionPreference = 'Stop'

Write-Host "Creating a new local administrator account for VDI purposes..."
[Byte[]] $key = (1..16)
$Encrypted = Get-Content "$env:psfunction_path\LOCADM.pwd" | ConvertTo-SecureString -Key $key
New-LocalUser "$env:localvdiadmin" -Password $Encrypted -FullName "$env:localvdiadmin" -Description "VDI Local Administrator Account" | Out-Null
Set-LocalUser -Name "$env:localvdiadmin" -PasswordNeverExpires 1 | Out-Null
Add-LocalGroupMember -Group "Administrators" -Member "$env:localvdiadmin" | Out-Null