$ErrorActionPreference = 'Stop'

Write-Host "Uninstall the built-in OneDrive application..."

$OneDriveProcess = Get-Process OneDrive -ErrorAction SilentlyContinue
Write-Host "Terminate OneDrive Process..."
if ($null -eq $OneDriveProcess) {
    Write-Host "None Active OneDrive Process Found!"
}
else {
    taskkill.exe /F /IM "OneDrive.exe"
    Write-Host "All Active OneDrive Process are Closed!"
}
 
Write-Host "Uninstall the built-in OneDrive..."
if (Test-Path "$env:systemroot\System32\OneDriveSetup.exe") {
   Start-Process -Wait -NoNewWindow "$env:systemroot\System32\OneDriveSetup.exe" -ArgumentList "/uninstall"
}
if (Test-Path "$env:systemroot\SysWOW64\OneDriveSetup.exe") {
    Start-Process -Wait -NoNewWindow "$env:systemroot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall"
}

Write-Host "Disable OneDrive via Group Policies..."
New-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" -Force | Out-Null
New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Policies\Microsoft\Windows\OneDrive" -Value 1 -PropertyType dword -Name "DisableFileSyncNGSC" -Force | Out-Null

Write-Host "Removing OneDrive Leftovers..."
Remove-Item -Path "$env:UserProfile\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path "$env:LocalAppData\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path "$env:ProgramData\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
Remove-Item -Path "C:\OneDriveTemp" -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host "Removing run option for new users..."
reg load "hku\Default" "C:\Users\Default\NTUSER.DAT"
reg delete "HKEY_USERS\Default\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f
reg unload "hku\Default"

Write-Host "Removing Start Menu Entry..."
Remove-Item -Path "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"  -Recurse -Force -ErrorAction SilentlyContinue | Out-Null

Write-Host "Remove Onedrive from Explorer Sidebar..."
New-PSDrive -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" -Name "HKCR" | Out-Null
New-Item -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force | Out-Null
New-ItemProperty -Path "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Value 0 -PropertyType dword -Name "System.IsPinnedToNameSpaceTree" -Force | Out-Null
New-Item -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Force | Out-Null
New-ItemProperty -Path "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" -Value 0 -PropertyType dword -Name "System.IsPinnedToNameSpaceTree" -Force | Out-Null
Remove-PSDrive "HKCR" | Out-Null