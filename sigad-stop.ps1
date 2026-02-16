$ErrorActionPreference = 'SilentlyContinue'

# Stop SIGAD services started via dotnet/apphost.
Stop-Process -Name 'Accredia.SIGAD.Anagrafiche.Api' -Force
Stop-Process -Name 'Accredia.SIGAD.Identity.Api' -Force
Stop-Process -Name 'Accredia.SIGAD.Tipologiche.Api' -Force
Stop-Process -Name 'Accredia.SIGAD.RisorseUmane.Api' -Force
Stop-Process -Name 'Accredia.SIGAD.RisorseUmane.Bff.Api' -Force
Stop-Process -Name 'Accredia.SIGAD.Gateway' -Force

Write-Host "Stopped SIGAD services (if running)."
