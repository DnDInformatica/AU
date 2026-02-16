@echo off
REM ============================================================================
REM ACCREDIA - Esecuzione semplice: Conversione UTF-8 + Codex CLI
REM ============================================================================

setlocal enabledelayedexpansion
color 0A

REM Naviga nella directory dello script
cd /d "%~dp0"

echo.
echo ============================================================================
echo  ACCREDIA - ESECUZIONE CONVERSIONE + CODEX
echo ============================================================================
echo.

REM Step 1: UTF-8 Conversion
echo [1/2] Conversione UTF-8...
cd prompts
python convert_to_utf8_v2.py
cd ..
echo.

REM Step 2: Codex Execution
echo [2/2] Esecuzione Codex CLI...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "run_codex_cli_FIXED.ps1" -From 0

echo.
echo ============================================================================
echo COMPLETATO!
echo ============================================================================
echo.
echo Log file: codex_run.log
echo Dimensione: 
for /f %%A in ('dir /b codex_run.log') do echo %%A bytes
echo.
pause
