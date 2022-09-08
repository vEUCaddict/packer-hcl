Param(
  [string]$env:softwarerepo,
  [string]$env:username,
  [SecureString]$env:password
)

Write-Host "Installing Windows Fonts which are necessary in the Windows Image..."

$ErrorActionPreference = 'Stop'


Write-Host "Create a drivemapping to the fonts repository..."
net use z: "$env:softwarerepo" /user:$env:username "$env:password" /p:yes


$FONTS = 0x14;
$FromPath = "$env:softwarerepo\Fonts";
$ObjShell = New-Object -ComObject Shell.Application;
$ObjFolder = $ObjShell.Namespace($FONTS);
$CopyOptions = 4 + 16;

foreach($File in $(Get-ChildItem -Path $FromPath)){
    If (Test-Path "$env:systemroot\$($File.name)")
    { }
    Else
    {
        $ObjFolder.CopyHere($File.fullname, $CopyOptions);
        New-ItemProperty -Name $File.fullname -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $File
    }
}

Write-Host "Remove drivemapping from the fonts repository..."
net use /delete z: /Y