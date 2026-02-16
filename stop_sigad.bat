@echo off
REM ============================================================================
REM  ACCREDIA SIGAD - STOP SCRIPT v1.0
REM  Termina tutti i microservizi della soluzione SIGAD
REM ============================================================================
chcp 65001 >nul
setlocal enabledelayedexpansion
color 0C

echo.
echo ============================================================================
echo  ACCREDIA SIGAD - ARRESTO SERVIZI
echo  %date% %time%
echo ============================================================================
echo.

set FOUND=0

REM === Verifica e termina Identity API ===
tasklist /FI "IMAGENAME eq Accredia.SIGAD.Identity.Api.exe" 2>nul | find /I "Accredia.SIGAD.Identity.Api.exe" >nul
if %ERRORLEVEL%==0 (
    echo [STOP] Identity API...
    taskkill /F /IM "Accredia.SIGAD.Identity.Api.exe" >nul 2>&1
    set FOUND=1
)

REM === Verifica e termina Tipologiche API ===
tasklist /FI "IMAGENAME eq Accredia.SIGAD.Tipologiche.Api.exe" 2>nul | find /I "Accredia.SIGAD.Tipologiche.Api.exe" >nul
if %ERRORLEVEL%==0 (
    echo [STOP] Tipologiche API...
    taskkill /F /IM "Accredia.SIGAD.Tipologiche.Api.exe" >nul 2>&1
    set FOUND=1
)

REM === Verifica e termina Anagrafiche API ===
tasklist /FI "IMAGENAME eq Accredia.SIGAD.Anagrafiche.Api.exe" 2>nul | find /I "Accredia.SIGAD.Anagrafiche.Api.exe" >nul
if %ERRORLEVEL%==0 (
    echo [STOP] Anagrafiche API...
    taskkill /F /IM "Accredia.SIGAD.Anagrafiche.Api.exe" >nul 2>&1
    set FOUND=1
)

REM === Verifica e termina Gateway ===
tasklist /FI "IMAGENAME eq Accredia.SIGAD.Gateway.exe" 2>nul | find /I "Accredia.SIGAD.Gateway.exe" >nul
if %ERRORLEVEL%==0 (
    echo [STOP] Gateway...
    taskkill /F /IM "Accredia.SIGAD.Gateway.exe" >nul 2>&1
    set FOUND=1
)

REM === Verifica e termina Web ===
tasklist /FI "IMAGENAME eq Accredia.SIGAD.Web.exe" 2>nul | find /I "Accredia.SIGAD.Web.exe" >nul
if %ERRORLEVEL%==0 (
    echo [STOP] Web UI...
    taskkill /F /IM "Accredia.SIGAD.Web.exe" >nul 2>&1
    set FOUND=1
)

echo.

REM === Verifica finale ===
timeout /t 1 /nobreak >nul

set REMAINING=0
tasklist /FI "IMAGENAME eq Accredia.SIGAD*" 2>nul | find /I "Accredia.SIGAD" >nul
if %ERRORLEVEL%==0 (
    set REMAINING=1
)

echo ============================================================================
if %FOUND%==0 (
    color 0E
    echo  Nessun servizio SIGAD era in esecuzione
) else if %REMAINING%==1 (
    color 0C
    echo  ATTENZIONE: Alcuni processi potrebbero essere ancora attivi
    echo.
    echo  Processi SIGAD rimanenti:
    tasklist /FI "IMAGENAME eq Accredia.SIGAD*" 2>nul | find /I "Accredia.SIGAD"
) else (
    color 0A
    echo  TUTTI I SERVIZI SIGAD TERMINATI
)
echo ============================================================================
echo.

REM === Verifica porte liberate ===
echo Verifica porte:
for %%p in (7000 7001 7002 7003 7100) do (
    netstat -ano | find ":%%p " | find "LISTENING" >nul 2>&1
    if !ERRORLEVEL!==0 (
        echo   Porta %%p: ANCORA IN USO
    ) else (
        echo   Porta %%p: Libera
    )
)

echo.
pause
