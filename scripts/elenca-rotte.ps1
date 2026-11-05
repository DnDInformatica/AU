$ErrorActionPreference = 'SilentlyContinue'
$cartelle = @(
    'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.Tipologiche.Api\V1',
    'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Bff.Api\V1',
    'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\V1'
)
foreach ($c in $cartelle) {
    Write-Output "=== $c ==="
    Get-ChildItem -Path $c -Recurse -Filter *.cs |
        Select-String -Pattern 'MapGet|MapGroup|MapPost' |
        ForEach-Object { $_.Line.Trim() } |
        Where-Object { $_ -match '"' } |
        Select-Object -First 12
}
