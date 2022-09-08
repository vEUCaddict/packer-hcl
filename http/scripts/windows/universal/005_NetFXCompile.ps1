$ErrorActionPreference = 'Stop'

Write-Host "Start .NET Framework queued compilation jobs..."
Start-Process -Wait -NoNewWindow -FilePath "$env:windir\Microsoft.NET\Framework\v4.0.30319\ngen.exe" -ArgumentList "executequeueditems /silent /nologo" -RedirectStandardOutput $env:temp\ngen.log
Write-Host ".NET Framework queued compilation jobs completed!"