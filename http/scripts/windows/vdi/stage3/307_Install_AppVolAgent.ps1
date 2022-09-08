Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:appvol_agent_dirname,
  [string]$env:appvol_mgr_fqdn,
  [string]$env:appvol_mgr_port,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling
Import-Module "$env:psfunction_path\Test-RegistryValue.ps1" -Force # Checks if Registry value exists

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:appvol_agent_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:appvol_agent_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:appvol_agent_dirname\*" -Destination "$env:tempsoft_path\$env:appvol_agent_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing VMware App Volumes Agent..."
$InstallExitCode = InstallMSI -MSIName "$env:appvol_agent_dirname" -MSIArgs "/qn MANAGER_ADDR=$env:appvol_mgr_fqdn MANAGER_PORT=$env:appvol_mgr_port EnforceSSLCertificateValidation=0 REBOOT=ReallySuppress"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	#Write-Host "Disable SSL and SSL Certificate Validation..."
	#if( -Not (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Value "EnforceSSLCertificateValidation" ) ) { New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "EnforceSSLCertificateValidation" -Type dword -Value "0" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "EnforceSSLCertificateValidation" -Type dword -Value "0" | Out-Null }

	Write-Host "Edit Maximum TimeOut to the App Volumes Manager..."
	if( -Not (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Value "MaxDelayTimeOutS" ) ) { New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "MaxDelayTimeOutS" -Type dword -Value "30" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "MaxDelayTimeOutS" -Type dword -Value "30" | Out-Null }
	
	Write-Host "Set Delay Volume Attachments in Minutes..." #Set to 0 to avoid printer mapping issues: https://kb.vmware.com/s/article/2137401
	if( -Not (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Value "VolDelayLoadTime" ) ) { New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "VolDelayLoadTime" -Type dword -Value "0" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\svservice\Parameters" -Name "VolDelayLoadTime" -Type dword -Value "0" | Out-Null }
	
	Write-Host "Copy custom snapvol.cfg..."
	Copy-Item -Path "$env:tempsoft_path\$env:appvol_agent_dirname\Snapvol.cfg" -Destination "${env:ProgramFiles(x86)}\CloudVolumes\Agent\Config\Default\Snapvol.cfg" -Force -Confirm:$false
	Restart-Service -Name svservice
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:appvol_agent_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y