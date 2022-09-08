# OPTIMIZING VDI PERFORMANCE VIA REGISTRY TWEAKS

Param(
    [string]$env:target_release_version,
    [string]$env:psfunction_path
)

$ErrorActionPreference = 'Stop'

# LOAD EXTERNAL FUNCTION(S)
Import-Module "$env:psfunction_path\Test-RegistryValue.ps1" -Force # Checks if Registry value exists

# SET POWER PLAN TO ULTIMATE PERFORMANCE
Write-Host "Set Windows Power Schema to Ultimate Performance..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" -Value "e9a42b02-d5df-448d-aa00-03f14749eb61" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" -Value "e9a42b02-d5df-448d-aa00-03f14749eb61" -PropertyType String -Name "ActivePowerScheme" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings" -Name "ActivePowerScheme" -Type String -Value "e9a42b02-d5df-448d-aa00-03f14749eb61" | Out-Null }

# ENABLE NUNLOCK AFTER STARTUP
Write-Host "Enabling NumLock after startup..."
if( -Not (Test-Path -Path "Registry::HKU\.DEFAULT\Control Panel\Keyboard" ) ) { New-Item -Path "Registry::HKU\.DEFAULT\Control Panel\Keyboard" -Force -Confirm:$false | Out-Null }
Set-ItemProperty -Path "Registry::HKU\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Type String -Value "2" | Out-Null

# DISABLE AUTOMATIC DOWNLOAD & INSTALL OF MICROSOFT UPDATES
Write-Host "Disabling the Automatic Download and Installation of Microsoft Updates..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Value "NoAutoUpdate" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Value "1" -PropertyType DWord -Name "NoAutoUpdate" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value "1" | Out-Null }

# SET WINDOWS TARGET RELEASE VERSION
Write-Host "Set the Target Release Version of Windows to $env:target_release_version ..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Value "TargetReleaseVersion" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Value "1" -PropertyType DWord -Name "TargetReleaseVersion" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetReleaseVersion" -Type DWord -Value "1" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Value "TargetReleaseVersionInfo" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Value "$env:target_release_version" -PropertyType String -Name "TargetReleaseVersionInfo" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "TargetReleaseVersionInfo" -Type String -Value "$env:target_release_version" | Out-Null }

# SET WINDOWS STARTUP DELAY IN MILLISECONDS TO 0
Write-Host "Set Startup Delay in Milliseconds to 0..."
if( -Not (Test-Path -Path "Registry::HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" ) ) { New-Item -Path "Registry::HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "Registry::HKU\.DEFAULT\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -Name "StartupDelayinMsec" -Type dword -Value "0" | Out-Null

# DISABLE SLEEP MODUS ON NETWORK ADAPTER
Write-Host "Disabling sleep mode on the network adapter..." 
if( -Not (Test-RegistryValue -Path "HKLM:\System\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" -Value "PnPCapabilities" ) ) { New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" -Value "280" -PropertyType DWord -Name "PnPCapabilities" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\0000" -Name "PnPCapabilities" -Type DWord -Value "280" | Out-Null }

# ENABLE HIGHLY DETAILED STATUS MESSAGES
Write-Host "Enabling Highly Detailed Status Messages..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "VerboseStatus" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "1" -PropertyType DWord -Name "VerboseStatus" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Type DWord -Value "1" | Out-Null }

# DISABLE GROUP POLICY CACHING
Write-Host "Disabling the Group Policy Caching Functionalities..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "EnableLogonOptimization" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "0" -PropertyType DWord -Name "EnableLogonOptimization" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableLogonOptimization" -Type DWord -Value "0" | Out-Null }

# ENABLE LOGON SCRIPT DELAY
Write-Host "Enabling the Logon Script Delay and set it to 0..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "EnableLogonScriptDelay" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "1" -PropertyType DWord -Name "EnableLogonScriptDelay" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableLogonScriptDelay" -Type DWord -Value "1" | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "AsyncScriptDelay" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "0" -PropertyType DWord -Name "AsyncScriptDelay" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "AsyncScriptDelay" -Type DWord -Value "0" | Out-Null }

# ALWAYS WAIT FOR THE NETWORK AT COMPUTER STARTUP AND LOGON = NECESSARY FOR VMWARE DYNAMIC ENVIRONMENT MANAGER (DEM)
Write-Host "Enable the Always Wait for the Network at Computer Startup and Logon..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "SyncForegroundPolicy" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Value "1" -PropertyType DWord -Name "SyncForegroundPolicy" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "SyncForegroundPolicy" -Type DWord -Value "1" | Out-Null }

# DO NOT DISPLAY NETWORK SELECTION UI
Write-Host "Hiding the Network Selection UI..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "DontDisplayNetworkSelectionUI" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value "1" -PropertyType DWord -Name "DontDisplayNetworkSelectionUI" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DontDisplayNetworkSelectionUI" -Type DWord -Value "1" | Out-Null }

# HIDE FAST USER SWITCHING
Write-Host "Hiding the Fast User Switching Possiblities..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "HideFastUserSwitching" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "1" -PropertyType DWord -Name "HideFastUserSwitching" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "HideFastUserSwitching" -Type DWord -Value "1" | Out-Null }

# ALLOW DEPLOYMENT OPERATIONS IN SPECIAL PROFILES
Write-Host "Allow Deployment Operations in Special Profiles..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx" -Value "AllowDeploymentInSpecialProfiles" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx" -Value "1" -PropertyType DWord -Name "AllowDeploymentInSpecialProfiles" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx" -Name "AllowDeploymentInSpecialProfiles" -Type DWord -Value "1" | Out-Null }

# ALLOW MICROSOFT ACCOUNTS TO BE OPTIONAL
Write-Host "Allow Microsoft Accounts to be optional in Store Apps..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "MSAOptional" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value "1" -PropertyType DWord -Name "MSAOptional" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "MSAOptional" -Type DWord -Value "1" | Out-Null }

# TURN OFF APPLICATION TELEMETRY
Write-Host "Turning off the Application Telemetry Possiblities..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Value "AITEnable" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Value "1" -PropertyType DWord -Name "AITEnable" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value "1" | Out-Null }

# TURN OFF AUTOPLAY FOR ALL DRIVES
Write-Host "Turning off the AutoPlay Possiblities..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Value "NoDriveTypeAutoRun" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Value "255" -PropertyType DWord -Name "NoDriveTypeAutoRun" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value "255" | Out-Null }

# DISABLE MDM ENROLLMENT
Write-Host "Disabling the MDM Enrollment Possiblities..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Value "DisableRegistration" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Value "1" -PropertyType DWord -Name "DisableRegistration" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\MDM" -Name "DisableRegistration" -Type DWord -Value "1" | Out-Null }

# TURN OFF ACTIVE HELP
Write-Host "Turning off Active Help Functionalities..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" -Value "NoActiveHelp" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" -Value "1" -PropertyType DWord -Name "NoActiveHelp" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" -Name "NoActiveHelp" -Type DWord -Value "1" | Out-Null }

# HIDE RECENTLY ADDED APPS
Write-Host "Hiding the Recently Added Apps section from Start Menu..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Value "HideRecentlyAddedApps" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Value "1" -PropertyType DWord -Name "HideRecentlyAddedApps" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Type DWord -Value "1" | Out-Null }

# DISABLE AZURE ACTIVE DIRECTORY WORKPLACE JOIN
Write-Host "Disable Azure Active Directory Workplace Join..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Force -Confirm:$false | Out-Null }
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Value "BlockAADWorkplaceJoin" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Value "1" -PropertyType DWord -Name "BlockAADWorkplaceJoin" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -Type DWord -Value "1" | Out-Null }

# ENABLE REMOTE DESKTOP CONNECTIONS
Write-Host "Enabling Remote Desktop Connections to this Virtal Machine..."
if( -Not (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Value "fDenyTSConnections" ) ) { New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Value "0" -PropertyType DWord -Name "fDenyTSConnections" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Type DWord -Value "0" | Out-Null }
Write-Host "Enabling Network Level Authentication..."
if( -Not (Test-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Value "UserAuthentication" ) ) { New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Value "1" -PropertyType DWord -Name "UserAuthentication" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -Name "UserAuthentication" -Type DWord -Value "1" | Out-Null }
Write-Host "Enabling RDP Traffic Through Firewall..."
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"


# THE FOLLOWING ADJUSTMENTS BELOW ARE PROCESSED VIA THE VMWARE OS OPTIMIZATION TOOL

<#
# DISABLE FIRST LOGON ANIMATION
Write-Host "Disabling the First Logon Animation..." 
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Value 0 -PropertyType dword -Name "EnableFirstLogonAnimation" -Force
#>

<#
# PREVENT THE WIZARD OF ADDING FEATURES TO WINDOWS 10 FROM RUNNING
Write-Host "Preventing the Wizard from Running of Additional Windows 10 Features..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU" ) ) { New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\WAU" -Value 1 -PropertyType dword -Name "Disabled" -Force
#>

<#
# HIDE WINDOWS TIPS
Write-Host "Hiding the Windows Tips..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Value 1 -PropertyType dword -Name "DisableSoftLanding" -Force
#>

<#
# TURN OFF MICROSOFT CONSUMER EXPERIENCES
Write-Host "Turning off the Microsoft Consumer Experience Possiblities..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Value 1 -PropertyType dword -Name "DisableWindowsConsumerFeatures" -Force
#>

<#
# TURN OFF FEEDBACK NOTIFICATIONS
Write-Host "Turning off the Feedback Notifications..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Value 1 -PropertyType dword -Name "DoNotShowFeedbackNotifications" -Force
#>

<#
# DISABLE EDGE SWIPE
Write-Host "Disabling the Edge Swiping Possiblities..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Value 0 -PropertyType dword -Name "AllowEdgeSwipe" -Force
#>

<#
# DISABLE EDGE FIRST RUN
Write-Host "Disabling the Edge First Run Wizard..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge" -Value 1 -PropertyType dword -Name "PreventFirstRunPage" -Force
#>

<#
# DISABLE EDGE HELP TIPS
Write-Host "Disabling the Edge Help Tips..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI" -Value 1 -PropertyType dword -Name "DisableHelpSticker" -Force
#>

<#
# ENABLE WINDOWS SMARTSCREEN FILTER
Write-Host "Enabling Windows SmartScreen..." 
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Value 1 -PropertyType dword -Name "EnableSmartScreen" -Force
#>

<#
# DISABLE INTERNET EXPLORER FIRST TIME RUN
Write-Host "Disabling the Internet Explorer First Time Run Wizard..."
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Internet Explorer\Main" -Value 1 -PropertyType dword -Name "DisableFirstRunCustomize" -Force
#>

<#
# SET DEVICE DIAGNOSTIC DATA TO SECURITY (MINIMAL)
Write-Host "Setting Device Diagnostic Data to Security Level..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" ) ) { New-Item -Path "SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Value 0 -PropertyType dword -Name "AllowTelemetry" -Force
#>

<#
# TURN OFF THE STORE APPLICATION (STORE)
Write-Host "Turning off the Store application..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Value 1 -PropertyType dword -Name "RemoveWindowsStore" -Force
#>

<#
# TURN OFF AUTOMATIC DOWNLOAD AND INSTALL OF UPDATES (STORE)
Write-Host "Turning off the Store application..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Value 2 -PropertyType dword -Name "AutoDownload" -Force
#>

<#
# TURN OFF THE OFFER TO UPDATE TO THE LATEST VERSION OF WINDOWS (STORE)
Write-Host "Turning off the Store application..."
if( -Not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" ) ) { New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsStore" -Value 1 -PropertyType dword -Name "DisableOSUpgrade" -Force
#>

<#
# ADJUST SESSION MANAGER - MEMORY MANAGEMENT FEATURE SETTINGS OVERRIDE TO INCREASE PERFORMANCE FOR SPECTRE VARIANT 2
Write-Host "Adjusting Session Manager Memory Management to Increase Performance..."
if( -Not (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" ) ) { New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Force -Confirm:$false | Out-Null }
if( -Not (Test-Path -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" ) ) { New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Force -Confirm:$false | Out-Null }
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Value 1024 -PropertyType dword -Name "FeatureSettingsOverride" -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Value 1024 -PropertyType dword -Name "FeatureSettingsOverrideMask" -Force | Out-Null
#>

<#
# DISABLE CREATION OF EDGE SHORTCUT ON DESKTOP
Write-Host "Disable Creation of Edge Shortcut on Desktop..." 
if( -Not (Test-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Value "DisableEdgeDesktopShortcutCreation" ) ) { New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Value "1" -PropertyType DWord -Name "DisableEdgeDesktopShortcutCreation" -Force | Out-Null } else { Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "DisableEdgeDesktopShortcutCreation" -Type DWord -Value "1" | Out-Null }
#>