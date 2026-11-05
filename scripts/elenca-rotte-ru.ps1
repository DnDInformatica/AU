$ErrorActionPreference = 'SilentlyContinue'
$radice = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'
Get-ChildItem -Path $radice -Recurse -Filter 'Endpoints.cs' -File | ForEach-Object {
    Write-Output ('=== ' + $_.FullName.Replace('C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1\','') + ' ===')
    Select-String -Path $_.FullName -Pattern 'MapVersioned(Get|Post|Put|Delete|Patch)\(app, "([^"]+)", "([^"]+)"' |
        ForEach-Object {
            $m = $_.Matches[0]
            Write-Output ('  ' + $m.Groups[1].Value.PadRight(6) + ' ' + $m.Groups[2].Value.PadRight(58) + ' ' + $m.Groups[3].Value)
        }
}
