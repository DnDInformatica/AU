$ErrorActionPreference = 'SilentlyContinue'

Write-Host "Processes:"
Get-Process -Name 'Accredia.SIGAD.Gateway','Accredia.SIGAD.Anagrafiche.Api','Accredia.SIGAD.Identity.Api','Accredia.SIGAD.Tipologiche.Api','Accredia.SIGAD.RisorseUmane.Api','Accredia.SIGAD.RisorseUmane.Bff.Api' |
    Select-Object Id,ProcessName,StartTime |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Listeners:"
netstat -ano | findstr ":7001" | Out-String
netstat -ano | findstr ":7002" | Out-String
netstat -ano | findstr ":7003" | Out-String
netstat -ano | findstr ":7004" | Out-String
netstat -ano | findstr ":7005" | Out-String
netstat -ano | findstr ":7100" | Out-String
