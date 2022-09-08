Param(
  [string]$env:softwarerepo,
  [string]$env:tempsoft_path,
  [string]$env:psfunction_path,
  [string]$env:java_re_x64_dirname,
  [string]$env:java_re_version,
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
if( -not (Test-Path -Path "$env:tempsoft_path\$env:java_re_x64_dirname" ) ) { New-Item -ItemType directory -Path "$env:tempsoft_path\$env:java_re_x64_dirname" | Out-Null }
Copy-Item -Path "$env:softwarerepo\$env:java_re_x64_dirname\*" -Destination "$env:tempsoft_path\$env:java_re_x64_dirname\" -Force -Recurse -Confirm:$false

Write-Host "Installing Oracle Java RE (Runtime Environment)..."
$InstallExitCode = InstallMSI -MSIName "$env:java_re_x64_dirname" -MSIArgs "/qn REBOOT=ReallySuppress NOSTARTMENU=1 AUTO_UPDATE=0 EULA=0 SPONSORS=0"
if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
	# PLACE HERE POST INSTALL ACTIONS AFTER A SUCCESSFUL INSTALL

	Write-Host "Disable Oracle JavaRE AutoUpdates..."
  if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Value "AUTOUPDATEDELAY" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "AUTOUPDATEDELAY" -Type dword -Value "0" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "AUTOUPDATEDELAY" -Type dword -Value "0" | Out-Null }
  if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Value "AUTOUPDATECHECK" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "AUTOUPDATECHECK" -Type dword -Value "0" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "AUTOUPDATECHECK" -Type dword -Value "0" | Out-Null }
  if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Value "JAVAUPDATE" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "JAVAUPDATE" -Type dword -Value "0" | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\JavaSoft\Java Runtime Environment\$env:java_re_version\MSI" -Name "JAVAUPDATE" -Type dword -Value "0" | Out-Null }
}
else {
	# PLACE HERE POST INSTALL ACTIONS AFTER A FAILED INSTALL
}

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:java_re_x64_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue

Write-Host "Remove drivemapping from the software repository..."
net use /delete z: /Y