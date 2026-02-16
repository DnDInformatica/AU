@echo off
REM ============================================================================
REM ACCREDIA SIGAD - ORCHESTRAZIONE COMPLETA PROMPT 0-14
REM ============================================================================
REM Esegue TUTTI i prompt (0-14) in sequenza per generare la soluzione completa
REM ============================================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"
color 0A

REM Configurazione
set PROMPTS_DIR=%cd%\prompts
set LOG_MAIN=%cd%\execution_main.log
set LOG_CODEX=%cd%\codex_run.log
set PYTHON_SCRIPT=%cd%\convert_to_utf8_v2.py
set CODEX_SCRIPT=%cd%\run_codex_cli.ps1

echo.
echo ============================================================================
echo  ACCREDIA SIGAD - ORCHESTRAZIONE PROMPT 0-14
echo ============================================================================
echo.
echo [%date% %time%] Inizio esecuzione
echo Workspace: C:\Accredia\Sviluppo\AU
echo Prompts Dir: %PROMPTS_DIR%
echo.

(
  echo ==============================================================================
  echo ACCREDIA SIGAD - ORCHESTRAZIONE PROMPT 0-14
  echo ==============================================================================
  echo [%date% %time%] Inizio esecuzione orchestrazione completa
  echo Workspace: C:\Accredia\Sviluppo\AU
  echo Prompts directory: %PROMPTS_DIR%
  echo ============================================================================
  echo.
) > "%LOG_MAIN%"

REM STEP 1: CONTROLLI PREREQUISITI
echo [STEP 1/4] Verifica prerequisiti...
echo [STEP 1/4] Verifica prerequisiti... >> "%LOG_MAIN%"

if not exist "%PROMPTS_DIR%" (
  echo [ERRORE] Directory prompts non trovata: %PROMPTS_DIR%
  goto ERROR
)

python --version >nul 2>&1
if errorlevel 1 (
  echo [ERRORE] Python non trovato nel PATH
  goto ERROR
)
for /f "tokens=*" %%i in ('python --version 2^>^&1') do set PYTHON_VER=%%i
echo [OK] Python trovato: %PYTHON_VER%

codex --version >nul 2>&1
if errorlevel 1 (
  echo [ERRORE] Codex CLI non trovato nel PATH
  goto ERROR
)
echo [OK] Codex CLI trovato
echo [OK] Codex CLI trovato >> "%LOG_MAIN%"

if not exist "%CODEX_SCRIPT%" (
  echo [ERRORE] Script Codex non trovato: %CODEX_SCRIPT%
  goto ERROR
)
echo [OK] Script Codex presente
echo.

REM STEP 2: CONVERSIONE UTF-8
echo [STEP 2/4] Conversione UTF-8 file prompt...
echo [STEP 2/4] Conversione UTF-8 file prompt... >> "%LOG_MAIN%"

cd /d "%PROMPTS_DIR%"
pip install chardet --quiet >nul 2>&1
echo [*] Esecuzione conversione UTF-8...
python "%PYTHON_SCRIPT%" >> "%LOG_MAIN%" 2>&1
echo [OK] Conversione UTF-8 completata
echo.

REM STEP 3: ELENCO PROMPT DA ESEGUIRE
echo [STEP 3/4] File PROMPT pronti per esecuzione:
echo [STEP 3/4] File PROMPT pronti per esecuzione: >> "%LOG_MAIN%"
echo.

setlocal enabledelayedexpansion
set /a IDX=0
for %%F in (PROMPT_*.md) do (
  echo   [!IDX!] %%F
  set /a IDX=!IDX!+1
)
echo.

REM STEP 4: ESECUZIONE CODEX
echo [STEP 4/4] Esecuzione Codex CLI per PROMPT 0-14...
echo.
echo ============================================================================
echo Attenzione: Questo processo eseguira' TUTTI i prompt (0-14) in sequenza.
echo Tempo stimato: 15-25 minuti
echo Non interrompere il processo!
echo ============================================================================
echo.
echo [%date% %time%] Inizio esecuzione Codex >> "%LOG_MAIN%"

cd /d "%~dp0"
echo [*] Esecuzione... Aguarda...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%CODEX_SCRIPT%" -From 0 >> "%LOG_MAIN%" 2>&1

set CODEX_EXIT=%errorlevel%

echo.
echo [%date% %time%] Esecuzione Codex completata (exit code: %CODEX_EXIT%) >> "%LOG_MAIN%"

REM VERIFICA FINALE
echo.
echo ============================================================================
echo [VERIFICA RISULTATI]
echo ============================================================================
echo.

if exist "%LOG_MAIN%" (
  echo [OK] Log esecuzione generato: %LOG_MAIN%
)

if exist "%LOG_CODEX%" (
  echo [OK] Log Codex generato: %LOG_CODEX%
)

echo.
echo ============================================================================
echo [COMPLETATO] Orchestrazione PROMPT 0-14 terminata
echo ============================================================================
echo.
echo Data/Ora fine: %date% %time%
echo.
echo Prossimi step:
echo   1. Controlla execution_main.log per errori dello script
echo   2. Controlla codex_run.log per output di Codex
echo   3. Verifica codice generato in: C:\Accredia\Sviluppo\AU\src\
echo.
echo Per visualizzare i log:
echo   - notepad %LOG_MAIN%
echo   - notepad %LOG_CODEX%
echo.

echo [%date% %time%] ORCHESTRAZIONE COMPLETA TERMINATA >> "%LOG_MAIN%"

pause
exit /b %CODEX_EXIT%

REM GESTIONE ERRORI
:ERROR
echo.
echo [ERRORE] Prerequisiti non soddisfatti!
echo.
echo Controlla che:
echo   - Python 3.7+ sia installato: python --version
echo   - Codex CLI sia installato: codex --version
echo   - PowerShell sia disponibile: powershell -Version
echo   - I file PROMPT_*.md siano in: %PROMPTS_DIR%
echo.

pause
exit /b 1
