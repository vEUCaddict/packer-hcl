$ErrorActionPreference = 'Stop'

Write-Host "Add Language Packs to Settings..."
$currentlist = Get-WinUserLanguageList

$installedlanguagepacks = (dism /online /Get-Intl)  | 
    Where-Object { $_.Contains("Installed language(s): ") } | 
    ForEach-Object { $_.Split(":")[1] }

ForEach ($languagepack in $installedlanguagepacks) {
    $languagepack = $languagepack.Trim()
    $currentlist.Add("$languagepack")
}

Set-WinUserLanguageList $currentlist -Force
Set-WinSystemLocale nl-NL
Set-Culture nl-NL
Set-TimeZone -Id "W. Europe Standard Time"
Set-WinHomeLocation -GeoId 0xb0