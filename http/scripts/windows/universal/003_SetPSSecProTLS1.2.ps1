$ErrorActionPreference = 'Stop'

Write-Host "Sets the default PowerShell security to TLS1.2..."
$RegPath = "HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319"
$RegKey = "SchUseStrongCrypto"
$RegValueType = "dword"
$RegValue = "1"

Try {
    $RegValueExists = Get-ItemPropertyValue -Path "$RegPath" -Name "$RegKey"
    If ($RegValueExists -eq $RegValue) {
        Write-Host "The registry key `"$RegKey`" has already the correct value..."
    }
    else {
        Write-Host "Set registry key `"$RegKey`" with value `"$RegValue`"..."
        Set-ItemProperty -Path "$RegPath" -Name "$RegKey" -Type "$RegValueType" -Value "$RegValue" | Out-Null
    }
}
Catch {
    Write-Host "The key does not exist yet, create it..."
    New-ItemProperty -Path "$RegPath" -Name "$RegKey" -Type "$RegValueType" -Value "$RegValue" | Out-Null
}


$RegPath = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NetFramework\v4.0.30319"
$RegKey = "SchUseStrongCrypto"
$RegValueType = "dword"
$RegValue = "1"

Try {
    $RegValueExists = Get-ItemPropertyValue -Path "$RegPath" -Name "$RegKey"
    If ($RegValueExists -eq $RegValue) {
        Write-Host "The registry key `"$RegKey`" has already the correct value..."
    }
    else {
        Write-Host "Set registry key `"$RegKey`" with value `"$RegValue`"..."
        Set-ItemProperty -Path "$RegPath" -Name "$RegKey" -Type "$RegValueType" -Value "$RegValue" | Out-Null
    }
}
Catch {
    Write-Host "The key does not exist yet, create it..."
    New-ItemProperty -Path "$RegPath" -Name "$RegKey" -Type "$RegValueType" -Value "$RegValue" | Out-Null
}