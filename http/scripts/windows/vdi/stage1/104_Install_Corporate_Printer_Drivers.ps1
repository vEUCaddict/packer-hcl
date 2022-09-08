# INSTALL CORPORATE PRINTER DRIVERS

Param(
  [string]$env:softwarerepo,
  [string]$env:tempdriver_path,
  [string]$env:printer1_ipaddr,
  [string]$env:printerdriver1_dirname,
  [string]$env:printerdriver1_inf,
  [string]$env:printerdriver1_name,
  [string]$env:printer1_name,
  [string]$env:printer2_ipaddr,
  [string]$env:printerdriver2_dirname,
  [string]$env:printerdriver2_inf,
  [string]$env:printerdriver2_name,
  [string]$env:printer2_name,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

Write-Host "Create a drivemapping to the driver repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from driver repository to image VM..."
if( -not (Test-Path -Path "$env:tempdriver_path\$env:printerdriver1_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempdriver_path\$env:printerdriver1_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\Drivers\$env:printerdriver1_dirname\*" -Destination "$env:tempdriver_path\$env:printerdriver1_dirname\" -Force -Recurse -Confirm:$false

if( -not (Test-Path -Path "$env:tempdriver_path\$env:printerdriver2_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempdriver_path\$env:printerdriver2_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\Drivers\$env:printerdriver2_dirname\*" -Destination "$env:tempdriver_path\$env:printerdriver2_dirname\" -Force -Recurse -Confirm:$false

# INSTALL PRINTERS (INCLUDING DRIVERS)
Write-Host "Installing Universal Printer Driver 1..."
C:\Windows\System32\pnputil.exe /add-driver "$env:tempdriver_path\$env:printerdriver1_dirname\$env:printerdriver1_inf" /install
Add-PrinterDriver -Name "$env:printerdriver1_name"
Add-PrinterPort -Name "$env:printer1_ipaddr" -PrinterHostAddress "$env:printer1_ipaddr"
Add-Printer "$env:printer1_name" -DriverName "$env:printerdriver1_name" -PortName "$env:printer1_ipaddr"

Write-Host "Installing Universal Printer Driver 2..."
C:\Windows\System32\pnputil.exe /add-driver "$env:tempdriver_path\$env:printerdriver2_dirname\$env:printerdriver2_inf" /install
Add-PrinterDriver -Name "$env:printerdriver2_name"
Add-PrinterPort -Name "$env:printer2_ipaddr" -PrinterHostAddress "$env:printer2_ipaddr"
Add-Printer "$env:printer2_name" -DriverName "$env:printerdriver2_name" -PortName "$env:printer2_ipaddr"

# REMOVE PRINTER (WITHOUT DRIVERS)
Remove-Printer -Name "$env:printer1_name"
Remove-PrinterPort -Name $env:printer1_ipaddr
Remove-Printer -Name "$env:printer2_name"
Remove-PrinterPort -Name $env:printer2_ipaddr


Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempdriver_path\$env:printerdriver1_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue
Remove-Item -Path "$env:tempdriver_path\$env:printerdriver2_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the driver repository..."
net use /delete z: /Y