@echo off
setlocal enabledelayedexpansion

set WEB_URL=http://localhost:5000
set TEST_PROJECT=Accredia.SIGAD.Web.E2E
set WEB_PROJECT=Accredia.SIGAD.Web

echo Avvio %WEB_PROJECT% su %WEB_URL%...

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set TS=%%i
set LOG_WEB=web_e2e_%TS%.log
set ERR_WEB=web_e2e_%TS%.err

for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq dotnet.exe" /FO CSV /NH') do set PRE_PID=%%a
start "" /B dotnet run --project "%WEB_PROJECT%" --urls %WEB_URL% 1> "%LOG_WEB%" 2> "%ERR_WEB%"

echo Attendo avvio...
powershell -NoProfile -Command ^
    "$max=30; $ok=$false; for($i=0;$i -lt $max;$i++){ try { $r = Invoke-WebRequest -Uri '%WEB_URL%/' -UseBasicParsing -TimeoutSec 2; if($r.StatusCode -ge 200 -and $r.StatusCode -lt 500){$ok=$true; break} } catch {} Start-Sleep -Seconds 1 }; if(-not $ok){ Write-Host 'Web non pronta'; }"

echo Esecuzione test Playwright...
set SIGAD_WEB_BASE_URL=%WEB_URL%
dotnet test "%TEST_PROJECT%"

for /f "tokens=2 delims=," %%a in ('tasklist /FI "IMAGENAME eq dotnet.exe" /FO CSV /NH') do (
  if not "%%a"=="!PRE_PID!" taskkill /F /PID %%a >nul 2>&1
)

echo.
echo Output web: %LOG_WEB%
echo Errori web: %ERR_WEB%
endlocal
