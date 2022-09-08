$ErrorActionPreference = 'Stop'

# REMOVE UNWANTED BUILT-IN WINDOWS UWP APPS

Write-Host "Remove All Unwanted Windows Built-in Store Apps for All New Users in UI..."
Get-AppxPackage -AllUsers | Where-Object {$_.IsFramework -Match 'False' -and $_.NonRemovable -Match 'False' -and $_.Name -NotMatch 'Microsoft.StorePurchaseApp' -and $_.Name -NotMatch 'Microsoft.WindowsStore' -and $_.Name -NotMatch 'Microsoft.MSPaint' -and $_.Name -NotMatch 'Microsoft.Windows.Photos' -and $_.Name -NotMatch 'Microsoft.WindowsCalculator'} | Remove-AppxPackage -ErrorAction SilentlyContinue

Write-Host "Remove All Unwanted Windows Built-in Store Apps for the Current User in UI..."
Get-AppxPackage | Where-Object {$_.IsFramework -Match 'False' -and $_.NonRemovable -Match 'False' -and $_.Name -NotMatch 'Microsoft.StorePurchaseApp' -and $_.Name -NotMatch 'Microsoft.WindowsStore' -and $_.Name -NotMatch 'Microsoft.MSPaint' -and $_.Name -NotMatch 'Microsoft.Windows.Photos' -and $_.Name -NotMatch 'Microsoft.WindowsCalculator'} | Remove-AppxPackage -ErrorAction SilentlyContinue

Write-Host "Remove All Unwanted Windows Built-in Store Apps files from Disk..."
$UWPapps = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch 'Microsoft.StorePurchaseApp' -and $_.PackageName -NotMatch 'Microsoft.WindowsStore' -and $_.PackageName -NotMatch 'Microsoft.MSPaint' -and $_.PackageName -NotMatch 'Microsoft.Windows.Photos' -and $_.PackageName -NotMatch 'Microsoft.WindowsCalculator' -and $_.PackageName -NotMatch 'Microsoft.DesktopAppInstaller' -and $_.PackageName -NotMatch 'Microsoft.SecHealthUI'}
Foreach ($UWPapp in $UWPapps) {
    Remove-ProvisionedAppxPackage -PackageName $UWPapp.PackageName -Online -ErrorAction SilentlyContinue
}

# Remove contact support via an alternative 
$RootPath = "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages\" 
$SystemAppNames = @( "Windows-ContactSupport" )
 
foreach ($SystemAppName in $SystemAppNames) {
    $RegistryKeyApps = (Get-ChildItem "HKLM:\$RootPath" | Where-Object Name -Like "*$SystemAppName*")
         
    foreach($RegistryKeyApp in $RegistryKeyApps)
    {
        $RegistryKey = $RegistryKeyApp.Name.Substring(19) # Remove HKEY_LOCAL_MACHINE from string
        Write-Host $RegistryKey
         
        $key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey($RegistryKey,[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
        $acl = $key.GetAccessControl()
        $rule = New-Object System.Security.AccessControl.RegistryAccessRule ("${[system.environment]::MachineName}\Admin","FullControl","Allow")
        $acl.SetAccessRule($rule)
        $key.SetAccessControl($acl)
 
        $subkey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("$RegistryKey\Owners",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
        $subacl = $subkey.GetAccessControl()
        $subacl.SetAccessRule($rule)
        $subkey.SetAccessControl($subacl)
         
        Set-ItemProperty -Path "HKLM:\$RegistryKey" -Name Visibility -Value 1
        New-ItemProperty -Path "HKLM:\$RegistryKey" -Name DefVis -PropertyType DWord -Value 2
        Remove-Item -Path "HKLM:\$RegistryKey\Owners"
             
        $AppName = $RegistryKey.Split('\')[-1]
        DISM /Online /Remove-Package /PackageName:$AppName
    }
     
    # Remember to remove it from the currently logged in user (and rename "Windows-ContactSupport" to "Windows.ContactSupport")
    Get-AppxPackage -Name $SystemAppName.Replace("-",".") -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
}