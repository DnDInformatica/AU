$ErrorActionPreference = 'Continue'
Get-Process -Name 'Accredia.SIGAD*' -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 3
Set-Location 'C:\Accredia\Sviluppo\AU'
$suite = @(
    'Accredia.SIGAD.Tipologiche.Api.Tests\Accredia.SIGAD.Tipologiche.Api.Tests.csproj',
    'Accredia.SIGAD.RisorseUmane.Api.Tests\Accredia.SIGAD.RisorseUmane.Api.Tests.csproj'
)
foreach ($s in $suite) {
    Write-Output "=== $s ==="
    dotnet test $s -c Debug --nologo -v minimal 2>&1 |
        Select-String -Pattern 'Superato|Non superato|Passed|Failed|error|Riepilogo|totale' |
        ForEach-Object { $_.Line.Trim() } | Select-Object -First 12
}
