$ErrorActionPreference = 'SilentlyContinue'
$radice = 'C:\Accredia\Sviluppo\AU'
Get-ChildItem -Path $radice -Recurse -Filter 'ApiVersioning*.cs' -File |
    Where-Object { $_.FullName -notmatch '\\(obj|bin)\\' } |
    ForEach-Object { Write-Output $_.FullName }
Write-Output '--- firme MapVersioned ---'
Get-ChildItem -Path $radice -Recurse -Filter '*.cs' -File |
    Where-Object { $_.FullName -notmatch '\\(obj|bin)\\' } |
    Select-String -Pattern 'public static .*MapVersioned' |
    ForEach-Object { $_.Line.Trim() } |
    Select-Object -Unique
