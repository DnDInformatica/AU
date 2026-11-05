$ErrorActionPreference = 'Stop'
$radice = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'
Get-ChildItem -Path $radice -Recurse -Filter 'Endpoints.cs' -File | ForEach-Object {
    $protette = (Select-String -Path $_.FullName -Pattern 'RichiedePermesso').Count
    $rotte = (Select-String -Path $_.FullName -Pattern 'MapVersioned(Get|Post|Put|Delete|Patch)\(app,').Count
    Write-Output ($_.Directory.Name.PadRight(26) + ' rotte: ' + $rotte + '  protette: ' + $protette)
}
