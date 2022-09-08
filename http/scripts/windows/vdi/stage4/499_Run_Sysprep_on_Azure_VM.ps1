$ErrorActionPreference = 'Stop'

if  ($null -ne (Get-Service -Name "RdAgent" -ErrorAction SilentlyContinue)) {
    Write-Host "Waiting for GA Service RdAgent to start..."
    while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }
}
else {
    Write-Host "The RdAgent is not installed..."
}

if  ($null -ne (Get-Service -Name "WindowsAzureGuestAgent" -ErrorAction SilentlyContinue)) {
    Write-Host "Waiting for GA Service WindowsAzureGuestAgent to start..."
    while ((Get-Service WindowsAzureGuestAgent).Status -ne "Running") { Start-Sleep -s 5 }
}
else {
    Write-Host "The WindowsAzureGuestAgent is not installed..."
}

Write-Host "Sysprepping VM..."
if (Test-Path $env:SystemRoot\system32\Sysprep\unattend.xml) {
    Remove-Item $env:SystemRoot\system32\Sysprep\unattend.xml -Force
}

& $env:SystemRoot\System32\Sysprep\sysprep.exe /oobe /generalize /quiet /quit /mode:vm

while($true) {
    $imageState = (Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State).ImageState
    Write-Host $imageState
    if ($imageState -eq "IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE") { 
        break 
    }
    Start-Sleep -s 5
}

Write-Host "Sysprep complete..."