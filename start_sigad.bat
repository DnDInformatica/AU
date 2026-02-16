@echo off
REM ============================================================================
REM  ACCREDIA SIGAD - STARTUP SCRIPT v1.0
REM  Avvia tutti i microservizi della soluzione SIGAD
REM ============================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
color 0A

echo.
echo ============================================================================
echo  ACCREDIA SIGAD - AVVIO SERVIZI
echo  %date% %time%
echo ============================================================================
echo.

REM === CONFIGURAZIONE ===
set BASE_PATH=%~dp0
set SLN_FILE=%BASE_PATH%Accredia.SIGAD.sln

REM === STEP 1: Termina eventuali istanze esistenti ===
echo [1/5] Verifica processi SIGAD esistenti...
tasklist /FI "IMAGENAME eq Accredia.SIGAD*" 2>nul | find /I "Accredia.SIGAD" >nul
if %ERRORLEVEL%==0 (
    echo       Processi SIGAD trovati, terminazione in corso...
    taskkill /F /IM "Accredia.SIGAD.Identity.Api.exe" 2>nul
    taskkill /F /IM "Accredia.SIGAD.Tipologiche.Api.exe" 2>nul
    taskkill /F /IM "Accredia.SIGAD.Anagrafiche.Api.exe" 2>nul
    taskkill /F /IM "Accredia.SIGAD.Gateway.exe" 2>nul
    taskkill /F /IM "Accredia.SIGAD.Web.exe" 2>nul
    timeout /t 2 /nobreak >nul
    echo       [OK] Processi terminati
) else (
    echo       [OK] Nessun processo SIGAD attivo
)
echo.

REM === STEP 2: Verifica SQL Server ===
echo [2/5] Verifica connessione SQL Server (porta 1434)...
powershell -Command "$t = Test-NetConnection -ComputerName localhost -Port 1434 -WarningAction SilentlyContinue; if($t.TcpTestSucceeded) { exit 0 } else { exit 1 }"
if %ERRORLEVEL%==0 (
    echo       [OK] SQL Server raggiungibile
) else (
    echo       [ERRORE] SQL Server non raggiungibile sulla porta 1434
    echo       Verificare che Docker/SQL Server sia avviato
    pause
    exit /b 1
)
echo.

REM === STEP 3: Build soluzione ===
echo [3/5] Compilazione soluzione...
dotnet build "%SLN_FILE%" --configuration Debug --verbosity quiet
if %ERRORLEVEL%==0 (
    echo       [OK] Build completato
) else (
    echo       [ERRORE] Build fallito
    pause
    exit /b 1
)
echo.

REM === STEP 4: Avvio servizi ===
echo [4/5] Avvio microservizi...
echo.

echo       Avvio Identity API (porta 7001)...
start /MIN "SIGAD-Identity" dotnet run --project "%BASE_PATH%Accredia.SIGAD.Identity.Api\Accredia.SIGAD.Identity.Api.csproj" --launch-profile http-dev --no-build
timeout /t 1 /nobreak >nul

echo       Avvio Tipologiche API (porta 7002)...
start /MIN "SIGAD-Tipologiche" dotnet run --project "%BASE_PATH%Accredia.SIGAD.Tipologiche.Api\Accredia.SIGAD.Tipologiche.Api.csproj" --launch-profile http-dev --no-build
timeout /t 1 /nobreak >nul

echo       Avvio Anagrafiche API (porta 7003)...
start /MIN "SIGAD-Anagrafiche" dotnet run --project "%BASE_PATH%Accredia.SIGAD.Anagrafiche.Api\Accredia.SIGAD.Anagrafiche.Api.csproj" --launch-profile http-dev --no-build
timeout /t 1 /nobreak >nul

echo       Avvio Gateway YARP (porta 7100)...
start /MIN "SIGAD-Gateway" dotnet run --project "%BASE_PATH%Accredia.SIGAD.Gateway\Accredia.SIGAD.Gateway.csproj" --launch-profile http-dev --no-build
timeout /t 1 /nobreak >nul

echo       Avvio Web Blazor (porta 7000)...
start /MIN "SIGAD-Web" dotnet run --project "%BASE_PATH%Accredia.SIGAD.Web\Accredia.SIGAD.Web.csproj" --launch-profile http-dev --no-build

echo.
echo       Attendo avvio servizi (5 secondi)...
timeout /t 5 /nobreak >nul
echo.

REM === STEP 5: Verifica health check ===
echo [5/5] Verifica stato servizi...
echo.

set ALL_OK=1

REM Verifica Identity API
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:7001/health' -TimeoutSec 3 -UseBasicParsing; exit 0 } catch { exit 1 }" 2>nul
if %ERRORLEVEL%==0 (
    echo       [OK] Identity API      - http://localhost:7001
) else (
    echo       [!!] Identity API      - NON RISPONDE
    set ALL_OK=0
)

REM Verifica Tipologiche API
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:7002/health' -TimeoutSec 3 -UseBasicParsing; exit 0 } catch { exit 1 }" 2>nul
if %ERRORLEVEL%==0 (
    echo       [OK] Tipologiche API   - http://localhost:7002
) else (
    echo       [!!] Tipologiche API   - NON RISPONDE
    set ALL_OK=0
)

REM Verifica Anagrafiche API
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:7003/health' -TimeoutSec 3 -UseBasicParsing; exit 0 } catch { exit 1 }" 2>nul
if %ERRORLEVEL%==0 (
    echo       [OK] Anagrafiche API   - http://localhost:7003
) else (
    echo       [!!] Anagrafiche API   - NON RISPONDE
    set ALL_OK=0
)

REM Verifica Gateway
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:7100/health' -TimeoutSec 3 -UseBasicParsing; exit 0 } catch { exit 1 }" 2>nul
if %ERRORLEVEL%==0 (
    echo       [OK] Gateway           - http://localhost:7100
) else (
    echo       [!!] Gateway           - NON RISPONDE
    set ALL_OK=0
)

REM Verifica Web
powershell -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:7000' -TimeoutSec 3 -UseBasicParsing; exit 0 } catch { exit 1 }" 2>nul
if %ERRORLEVEL%==0 (
    echo       [OK] Web UI            - http://localhost:7000
) else (
    echo       [!!] Web UI            - NON RISPONDE
    set ALL_OK=0
)

echo.
echo ============================================================================
if %ALL_OK%==1 (
    color 0A
    echo  SIGAD AVVIATO CON SUCCESSO
    echo.
    echo  Apertura browser...
    start http://localhost:7000
) else (
    color 0E
    echo  SIGAD AVVIATO CON ERRORI - Alcuni servizi non rispondono
    echo  Verificare le finestre minimizzate per eventuali errori
)
echo.
echo  Per terminare tutti i servizi: stop_sigad.bat
echo ============================================================================
echo.
pause
