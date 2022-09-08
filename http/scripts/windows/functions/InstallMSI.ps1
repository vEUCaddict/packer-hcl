Function InstallMSI {

    Param(
      [parameter(Mandatory=$true)]
      $MSIName,
      [parameter(Mandatory=$true)]
      $MSIArgs
    )

    $InstallFiles = "C:\PackerTemp\Software"

    # Locate Installer MSI or Executable
    $MSIInstaller = "$InstallFiles\$MSIName\" + (Get-ChildItem -Path "$InstallFiles\$MSIName\*" -Name -Include *.exe,*.msi -Exclude *.mst)

    if ($MSIInstaller -eq "$InstallFiles\$MSIName\") {
        Write-Host "No Installer found for $MSIName!"
    }

    if ($MSIInstaller -like '*.exe') {
        Write-Host "Execulable Installer found, assuming wrapped MSI; Passing arguments to MSI"
        $MSIArgs = "$MSIArgs"
    }

    # Check for Transform File
    $MSITransform = "$InstallFiles\$MSIName\" + (Get-ChildItem -Path "$InstallFiles\$MSIName\*" -Name -Include *.mst) 
    if ($MSITransform -like '*.mst') {
        Write-Host  "Transform file found, adding to Arguments"
        $MSIArgs = "/qb- TRANSFORMS=`"$MSITransform`" REBOOT=ReallySuppress"
    }
  
    Write-Host "Installer: $MSIInstaller"
    Write-Host "Arguments: $MSIArgs"

    # Installation
    if ($MSIInstaller -like '*.msi') {
        $InstallExitCode = (Start-Process msiexec.exe -PassThru -ArgumentList "/i `"$MSIInstaller`" $MSIArgs" -Wait -NoNewWindow).ExitCode
    }
    else {
        $InstallExitCode = (Start-Process -PassThru -FilePath $MSIInstaller -ArgumentList "$MSIArgs" -Wait -NoNewWindow).ExitCode
    }

    # Success and error handling
    if (($InstallExitCode -eq 0) -or ($InstallExitCode -eq 3010)) {
        Write-Host "$MSIName installation succeeded! (MSI ExitCode: $InstallExitCode)"
        if ($InstallExitCode -eq 3010) {
            Write-Host "Reboot Suppressed! ($InstallExitCode)"
        }
    }
    else {
        Write-Host "$MSIName installation failed! (MSI ExitCode: $InstallExitCode)"
    }
    return $InstallExitCode
}