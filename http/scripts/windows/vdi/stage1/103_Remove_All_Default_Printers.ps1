Write-Host "Remove all Printers except `"Microsoft Print to PDF`"..."
Get-Printer | Where-Object {$_.Name -NotMatch 'Microsoft Print to PDF'} | Remove-Printer -Verbose -ErrorAction SilentlyContinue | Out-Null

Write-Host "Remove all Printers Drivers except `"Microsoft Print to PDF`"..."
Get-PrinterDriver | Where-Object {$_.Name -NotMatch 'Microsoft Print to PDF'} | Remove-PrinterDriver -Verbose -ErrorAction SilentlyContinue | Out-Null