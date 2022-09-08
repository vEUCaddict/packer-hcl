$ErrorActionPreference = 'Stop'

# Repair missing or corrupted operating system files by running sfc /scannow
Write-Host "Repair missing or corrupted operating system files by running sfc /scannow..."
Start-Process -Wait -NoNewWindow -FilePath "${env:windir}\System32\sfc.exe" -ArgumentList '/scannow' | Out-Null
Write-Host "Repair missing or corrupted operating system files completed!"

# Clean Microsoft Update Files from disk
Write-Host "Cleaning Microsoft Update Files from disk..."
Start-Process -Wait -NoNewWindow -FilePath "${env:windir}\System32\dism.exe" -ArgumentList "/online /cleanup-image /startcomponentcleanup /resetbase" | Out-Null
Write-Host "Cleaning Microsoft Update Files from disk completed!"

<#
# Rearm Office 2016 64bit License
"Rearm Office 2016 64bit License..."
Start-Process -Wait -NoNewWindow -FilePath "${env:ProgramFiles}\Microsoft Office\Office16\OSPPREARM.EXE"
"Rearm Office 2016 64bit License completed!"
#>

# Clean App Volumes Log (Security)
if  ($null -ne (Get-Service -Name "svservice" -ErrorAction SilentlyContinue)) {
    Write-Host "Cleaning the App Volumes Agent Logs..."
    Stop-Service -Name "svservice" -Force | Out-Null
    Remove-Item -Path "${env:ProgramFiles(x86)}\CloudVolumes\Agent\Logs\svservice.log" -Force -Confirm:$false | Out-Null
    Write-Host "Cleaning App Volumes Agent Log file completed!"
}
else {
    Write-Host "The App Volumes Agent is not installed..."
}

# Clean "C:\WINDOWS\TEMP" Directory
Write-Host "Cleaning Temp Files..."
Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force `
| Sort-Object -Property FullName -Descending `
| ForEach-Object {
    try {
        Remove-Item -Path $_.FullName -Exclude VMware-cust-nativeapp.log,vmware-SYSTEM,vmware-imc,vmware-vmsvc.log,vmware-vmusr.log,vmware-vmvss.log,VMware,hsperfdata_$env:computername`$ -Recurse -Force -ErrorAction SilentlyContinue | Out-Null;
	}
    catch { }
}
Write-Host "Cleaning Temp Files completed!"

# Delete PackerTemp Folder
Write-Host "Deleting PackerTemp Folder..."
Remove-Item -Path "C:\PackerTemp" -Recurse -Confirm:$false | Out-Null

# Clear Event Logs
Write-Host "Clearing event logs..."
Clear-EventLog -LogName Application | Out-Null
Clear-EventLog -LogName Security | Out-Null
Clear-EventLog -LogName System | Out-Null
Write-Host "Clearing event logs completed!"