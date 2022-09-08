param (
    [string]$env:certs_path,
    [string]$env:rootca
)

$ErrorActionPreference = 'Stop'

Write-Host "Importing internal PKI Root CA to Trusted Root Certification Store (certlm.msc)..."
certutil -addstore -enterprise -v root "$env:certs_path\$env:rootca"