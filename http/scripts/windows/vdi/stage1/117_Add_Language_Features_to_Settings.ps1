Param(
  [string]$env:tempsoft_path,
  [string]$env:dutchlp_dirname
)

$ErrorActionPreference = 'Stop'

Write-Host "Add Language Features to Settings..."

Write-Host "Add Dutch Language Features: Basic writing, TextToSpeech, Handwriting and OCR..."
dism /Online /Add-Capability /CapabilityName:Language.Basic~~~nl-NL~0.0.1.0 /CapabilityName:Language.Handwriting~~~nl-NL~0.0.1.0 /CapabilityName:Language.OCR~~~nl-NL~0.0.1.0 /CapabilityName:Language.TextToSpeech~~~nl-NL~0.0.1.0 /Source:"$env:tempsoft_path\$env:dutchlp_dirname" /Quiet /LimitAccess

Write-Host "Delete files from temporary location..."
Remove-Item -Path "$env:tempsoft_path\$env:dutchlp_dirname" -Force -Confirm:$false -Recurse -ErrorAction SilentlyContinue