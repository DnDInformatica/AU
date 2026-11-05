$ErrorActionPreference = 'Continue'
Get-Process -Name 'Accredia.SIGAD*' -ErrorAction SilentlyContinue | Stop-Process -Force
Set-Location 'C:\Accredia\Sviluppo\AU'
$progetti = @(
    'Accredia.SIGAD.Shared\Accredia.SIGAD.Shared.csproj',
    'Accredia.SIGAD.Tipologiche.Api\Accredia.SIGAD.Tipologiche.Api.csproj',
    'Accredia.SIGAD.RisorseUmane.Api\Accredia.SIGAD.RisorseUmane.Api.csproj',
    'Accredia.SIGAD.RisorseUmane.Bff.Api\Accredia.SIGAD.RisorseUmane.Bff.Api.csproj',
    'Accredia.SIGAD.Anagrafiche.Api\Accredia.SIGAD.Anagrafiche.Api.csproj'
)
foreach ($p in $progetti) {
    Write-Output "=== $p ==="
    dotnet build $p -c Debug --nologo -v minimal 2>&1 | Select-String -Pattern 'error|warning CS|Compilazione|Build succeeded|avvisi|errori' | ForEach-Object { $_.Line.Trim() } | Select-Object -First 15
}
