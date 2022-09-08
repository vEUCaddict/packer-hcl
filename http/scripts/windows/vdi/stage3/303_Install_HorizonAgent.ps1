Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:horizon_agent_dirname,
  [string]$env:username,
  [SecureString]$env:password
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\InstallMSI.ps1" -Force # MSI Installer including error handling

Write-Host "Create a drivemapping to the software repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes

Write-Host "Copying files from software repository to image VM..."
if( -not (Test-Path -Path "$env:tempsoft_path\$env:horizon_agent_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:horizon_agent_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:horizon_agent_dirname\*" -Destination "$env:tempsoft_path\$env:horizon_agent_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing VMware Horizon Agent..."
$InstallExitCode = InstallMSI -MSIName "$env:horizon_agent_dirname" -MSIArgs "/s /v /qn REBOOT=ReallySuppress RDP_CHOICE=1 SUPPRESS_RUNONCE_CHECK=1 ADDLOCAL=Core,ClientDriveRedirection,SdoSensor,GEOREDIR,HelpDesk,NGVC,PerfTracker,PrintRedir,RDP,RTAV,TSMMR,USB,VmwVaudio,VmwVidd,BlastUDP,PSG"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL
	
	# Enable Rule(s) below only when using Horizon 7.6 and above
	Write-Host "Removing VMware Horizon Performance Tracker from the desktop"
	Remove-Item -Path "C:\Users\Public\Desktop\VMware Horizon Performance Tracker.lnk" -Force -Confirm:$false | Out-Null
	
	#Write-Host "Enabling Lossless Compression for VMware Blast..." | Write-Log
	#if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\VMware, Inc.\VMware Blast\Config" -Value "EncoderBuildToPNG" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -Type String -Value "1" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\VMware, Inc.\VMware Blast\Config" -Name "EncoderBuildToPNG" -Type String -Value "1" | Out-Null }
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:horizon_agent_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y