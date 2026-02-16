@echo off
REM ACCREDIA SIGAD - ORCHESTRAZIONE v2.2 (stop on error + progress)
REM Uso: run_all.bat [indice_partenza] [-continue]
REM Esempio: run_all.bat 5         (parte da PROMPT_05, stop on error)
REM Esempio: run_all.bat 0 -continue  (tutti i prompt, continua anche se errori)

chcp 65001 >nul
setlocal enabledelayedexpansion
cd /d "%~dp0"
color 0A

set CODEX_SCRIPT=%cd%\run_codex_cli_v2.ps1

REM Parametri
set FROM_INDEX=0
set CONTINUE_FLAG=

:parse_args
if "%~1"=="" goto done_args
if /i "%~1"=="-continue" (
  set CONTINUE_FLAG=-ContinueOnError
  shift
  goto parse_args
)
if /i "%~1"=="/continue" (
  set CONTINUE_FLAG=-ContinueOnError
  shift
  goto parse_args
)
set FROM_INDEX=%~1
shift
goto parse_args
:done_args

echo.
echo ============================================================================
echo  ACCREDIA SIGAD - ORCHESTRAZIONE PROMPT v2.2
echo ============================================================================
echo.
echo  Indice partenza: %FROM_INDEX%
echo  Stop on error: %CONTINUE_FLAG:~0,1%==  (usa -continue per ignorare errori)
echo.
echo  Mapping indici:
echo     0 = PROMPT_00_Bootstrap_Verifica_Solution
echo     1 = PROMPT_01_VSA_Microservizi
echo     2 = PROMPT_02_Database_ConnectionString
echo     3 = PROMPT_03_Config_Resilienza_Diagnostica
echo     4 = PROMPT_04_Identity_JWT
echo     5 = PROMPT_05_Versioning_API
echo     6 = PROMPT_06_Osservabilita
echo     7 = PROMPT_07_Dapper_DB_Schema
echo     8 = PROMPT_08_Identity_JWT_Dapper_Migrations
echo     9 = PROMPT_09_Tipologiche_MVP_Dapper
echo    10 = PROMPT_10_Anagrafiche_MVP_Dapper
echo    11 = PROMPT_11_Gateway_Policies
echo    12 = PROMPT_12_Web_MudBlazor_Login
echo    13 = PROMPT_13_Observability_EndToEnd
echo    14 = PROMPT_14_DX_Scripts
echo.
echo ============================================================================
echo.

if not exist "%CODEX_SCRIPT%" (
  echo [ERRORE] Script run_codex_cli_v2.ps1 non trovato!
  pause
  exit /b 1
)

echo [OK] Avvio esecuzione da indice %FROM_INDEX%...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%CODEX_SCRIPT%" -From %FROM_INDEX% %CONTINUE_FLAG%

set EXIT_CODE=%ERRORLEVEL%
echo.
if %EXIT_CODE% NEQ 0 (
  echo [ATTENZIONE] Esecuzione terminata con errori - exit code: %EXIT_CODE%
  echo Per riprendere, usa: run_all.bat [indice_fallito]
) else (
  echo [OK] Esecuzione completata con successo
)
echo.
echo Verifica codex_run.log per dettagli
pause
exit /b %EXIT_CODE%
