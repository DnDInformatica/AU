$ErrorActionPreference = 'Stop'
$src = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.Tipologiche.Api\Services\Auth\IamUserScopeResolver.cs'
$dst = 'C:\Accredia\Sviluppo\AU\Accredia.SIGAD.RisorseUmane.Api\Services\Auth\IamUserScopeResolver.cs'
$testo = (Get-Content -Path $src -Raw) -replace 'Tipologiche', 'RisorseUmane'
Set-Content -Path $dst -Value $testo -Encoding UTF8
Select-String -Path $dst -Pattern 'namespace |using Accredia|ISqlConnectionFactory' | ForEach-Object { $_.Line.Trim() }
