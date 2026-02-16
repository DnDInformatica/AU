param(
  [string]$PromptRoot = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\prompts',
  [string]$MetaPrompt = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\META_PROMPT.md',
  [string]$WorkDir    = 'C:\Accredia\Sviluppo\AU',
  [int]$From = 0,
  [string]$LogFile = 'codex_run.log',
  [switch]$ContinueOnError = $false  # Default: STOP on error
)

# ===== FIX ENCODING UTF-8 =====
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$env:PYTHONIOENCODING = 'utf-8'
chcp 65001 | Out-Null

# ===== GLOBAL STATE =====
$script:TotalPrompts = 0
$script:CurrentIndex = 0
$script:StartTime = $null
$script:PromptStartTime = $null

function Get-ReasoningEffort {
  param([string]$FileName)
  if ($FileName -match '__RLOW\b')  { return 'low' }
  if ($FileName -match '__RMED\b')  { return 'medium' }
  if ($FileName -match '__RHIGH\b') { return 'high' }
  return 'medium'
}

function Format-Duration {
  param([TimeSpan]$Duration)
  if ($Duration.TotalHours -ge 1) {
    return "{0:D2}:{1:D2}:{2:D2}" -f [int]$Duration.TotalHours, $Duration.Minutes, $Duration.Seconds
  }
  return "{0:D2}:{1:D2}" -f $Duration.Minutes, $Duration.Seconds
}

function Write-StatusBar {
  param(
    [string]$PromptName,
    [string]$Status,
    [ConsoleColor]$StatusColor = [ConsoleColor]::White
  )
  
  $elapsed = (Get-Date) - $script:StartTime
  $promptElapsed = if ($script:PromptStartTime) { (Get-Date) - $script:PromptStartTime } else { [TimeSpan]::Zero }
  
  $progress = "[{0}/{1}]" -f $script:CurrentIndex, $script:TotalPrompts
  $timeInfo = "Tot: $(Format-Duration $elapsed) | Prompt: $(Format-Duration $promptElapsed)"
  
  Write-Host ""
  Write-Host ("=" * 80) -ForegroundColor DarkGray
  Write-Host "  $progress " -NoNewline -ForegroundColor Cyan
  Write-Host $Status -NoNewline -ForegroundColor $StatusColor
  Write-Host " | $timeInfo" -ForegroundColor Gray
  Write-Host "  $PromptName" -ForegroundColor White
  Write-Host ("=" * 80) -ForegroundColor DarkGray
}

function Run-CodexPromptFile {
  param([Parameter(Mandatory=$true)][string]$PromptFile)

  $name = Split-Path $PromptFile -Leaf
  $effort = Get-ReasoningEffort $name
  $script:PromptStartTime = Get-Date

  # Status: IN CORSO
  Write-StatusBar -PromptName $name -Status "IN CORSO..." -StatusColor Yellow
  Write-Host "  WorkDir: $WorkDir | Sandbox: workspace-write | Reasoning: $effort" -ForegroundColor DarkYellow

  # Log header
  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $header = "`n[$timestamp] PROMPT: $PromptFile | effort=$effort`n"
  Add-Content -Path $LogFile -Value $header -Encoding UTF8

  # Heartbeat: mostra che stiamo lavorando
  Write-Host ""
  Write-Host "  [$(Get-Date -Format 'HH:mm:ss')] Invio prompt a Codex CLI..." -ForegroundColor DarkGray

  # FIX: Passa prompt via stdin pipe
  $errorOccurred = $false
  $errorMessage = ""
  
  try {
    $promptContent = Get-Content -Path $PromptFile -Raw -Encoding UTF8
    
    # Esegui Codex con output real-time
    $out = $promptContent | & codex exec -C $WorkDir --sandbox workspace-write -c "model_reasoning_effort=`"$effort`"" 2>&1
    
  } catch {
    $errorOccurred = $true
    $errorMessage = $_.Exception.Message
    Write-Host "  [EXCEPTION] $_" -ForegroundColor Red
    Add-Content -Path $LogFile -Value "EXCEPTION: $_" -Encoding UTF8
  }

  # Converte output in stringa
  if ($out -is [array]) {
    $outText = $out -join "`n"
  } else {
    $outText = [string]$out
  }
  
  # Scrivi su log (sempre)
  Add-Content -Path $LogFile -Value $outText -Encoding UTF8

  # Analisi errori nell'output
  $criticalErrors = @(
    'sandbox:\s*read-only',
    'error:\s*',
    'FATAL:',
    'Exception:',
    'failed to',
    'Could not find',
    'Unable to',
    'Access denied',
    'Permission denied'
  )
  
  $foundError = $false
  foreach ($pattern in $criticalErrors) {
    if ($outText -match $pattern) {
      $foundError = $true
      $errorMessage = "Output contains error pattern: $pattern"
      break
    }
  }

  # Check exit code
  if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    $foundError = $true
    $errorMessage = "Codex exit code: $LASTEXITCODE"
  }

  # Calcola durata
  $duration = (Get-Date) - $script:PromptStartTime
  $durationStr = Format-Duration $duration

  # Mostra output (troncato se troppo lungo)
  $maxOutputLines = 50
  $outputLines = $outText -split "`n"
  if ($outputLines.Count -gt $maxOutputLines) {
    Write-Host ""
    Write-Host "  --- Output (prime $maxOutputLines righe di $($outputLines.Count)) ---" -ForegroundColor DarkGray
    $outputLines | Select-Object -First $maxOutputLines | ForEach-Object { Write-Host "  $_" }
    Write-Host "  ... [$($outputLines.Count - $maxOutputLines) righe omesse, vedi log] ..." -ForegroundColor DarkGray
  } else {
    Write-Host ""
    Write-Host "  --- Output ---" -ForegroundColor DarkGray
    $outputLines | ForEach-Object { Write-Host "  $_" }
  }

  # Status finale
  Write-Host ""
  if ($errorOccurred -or $foundError) {
    Write-Host "  [$(Get-Date -Format 'HH:mm:ss')] " -NoNewline -ForegroundColor DarkGray
    Write-Host "ERRORE" -NoNewline -ForegroundColor Red
    Write-Host " dopo $durationStr - $errorMessage" -ForegroundColor Red
    Add-Content -Path $LogFile -Value "ERROR: $errorMessage (duration: $durationStr)" -Encoding UTF8
    return $false
  } else {
    Write-Host "  [$(Get-Date -Format 'HH:mm:ss')] " -NoNewline -ForegroundColor DarkGray
    Write-Host "COMPLETATO" -NoNewline -ForegroundColor Green
    Write-Host " in $durationStr" -ForegroundColor Green
    Add-Content -Path $LogFile -Value "OK: completed in $durationStr" -Encoding UTF8
    return $true
  }
}

# ===== MAIN =====

$script:StartTime = Get-Date

# Banner
Write-Host ""
Write-Host ("=" * 80) -ForegroundColor Cyan
Write-Host "  ACCREDIA SIGAD - ORCHESTRAZIONE CODEX CLI v2.2" -ForegroundColor Cyan
Write-Host "  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host "  Stop on error: $(-not $ContinueOnError)" -ForegroundColor Gray
Write-Host ("=" * 80) -ForegroundColor Cyan

# Verifica prerequisiti
if (-not (Test-Path $PromptRoot)) { 
  Write-Host "[ERRORE] PromptRoot non trovato: $PromptRoot" -ForegroundColor Red
  exit 1 
}
if (-not (Test-Path $WorkDir)) { 
  Write-Host "[ERRORE] WorkDir non trovato: $WorkDir" -ForegroundColor Red
  exit 1 
}

# ===== PRE-RESTORE (fix sandbox NuGet) =====
Write-Host ""
Write-Host "[PRE-RESTORE] Scarico pacchetti NuGet..." -ForegroundColor Magenta
$slnFile = Join-Path $WorkDir "Accredia.SIGAD.sln"
if (Test-Path $slnFile) {
  Push-Location $WorkDir
  try {
    $restoreResult = & dotnet restore $slnFile --verbosity minimal 2>&1
    if ($LASTEXITCODE -eq 0) {
      Write-Host "[OK] Pre-restore completato" -ForegroundColor Green
    } else {
      Write-Host "[WARN] Pre-restore fallito" -ForegroundColor Yellow
    }
  } finally {
    Pop-Location
  }
} else {
  Write-Host "[SKIP] Solution non trovata" -ForegroundColor Yellow
}

# Inizializza log
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] === NUOVA SESSIONE ===" | Out-File -FilePath $LogFile -Encoding UTF8 -Force
"Stop on error: $(-not $ContinueOnError)" | Add-Content -Path $LogFile -Encoding UTF8

# Carica lista prompt
$prompts = Get-ChildItem -Path $PromptRoot -Filter '*.md' | Sort-Object Name

if ($prompts.Count -eq 0) { 
  Write-Host "[ERRORE] Nessun prompt trovato" -ForegroundColor Red
  exit 1 
}

if ($From -lt 0 -or $From -ge $prompts.Count) { 
  Write-Host "[ERRORE] -From fuori range (0-$($prompts.Count-1))" -ForegroundColor Red
  exit 1 
}

# Conta totale (META + prompts)
$hasMetaPrompt = Test-Path $MetaPrompt
$script:TotalPrompts = ($prompts.Count - $From) + $(if ($hasMetaPrompt) { 1 } else { 0 })
$script:CurrentIndex = 0

Write-Host ""
Write-Host "[INFO] Prompts da elaborare: $($script:TotalPrompts)" -ForegroundColor Cyan
Write-Host "[INFO] Range: $From -> $($prompts.Count - 1)" -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failureCount = 0
$stoppedEarly = $false

# Esegui META_PROMPT
if ($hasMetaPrompt) {
  $script:CurrentIndex++
  Write-Host ""
  Write-Host "[META] Caricamento regole globali..." -ForegroundColor Magenta
  $result = Run-CodexPromptFile -PromptFile $MetaPrompt
  if ($result) {
    $successCount++
  } else {
    $failureCount++
    if (-not $ContinueOnError) {
      Write-Host ""
      Write-Host "[STOP] Interrotto per errore su META_PROMPT" -ForegroundColor Red
      $stoppedEarly = $true
    }
  }
}

# Esegui prompts
if (-not $stoppedEarly) {
  for ($i = $From; $i -lt $prompts.Count; $i++) {
    $script:CurrentIndex++
    
    $result = Run-CodexPromptFile -PromptFile $prompts[$i].FullName
    
    if ($result) {
      $successCount++
    } else {
      $failureCount++
      if (-not $ContinueOnError) {
        Write-Host ""
        Write-Host "[STOP] Interrotto per errore su prompt indice $i" -ForegroundColor Red
        Write-Host "       Per riprendere: run_all.bat $($i)" -ForegroundColor Yellow
        $stoppedEarly = $true
        break
      }
    }
  }
}

# ===== RIEPILOGO FINALE =====
$totalDuration = (Get-Date) - $script:StartTime
$logPath = (Resolve-Path $LogFile).Path

Write-Host ""
Write-Host ("=" * 80) -ForegroundColor $(if ($stoppedEarly) { "Red" } else { "Green" })
Write-Host "  RIEPILOGO ESECUZIONE" -ForegroundColor $(if ($stoppedEarly) { "Red" } else { "Green" })
Write-Host ("=" * 80) -ForegroundColor $(if ($stoppedEarly) { "Red" } else { "Green" })
Write-Host ""
Write-Host "  Stato: " -NoNewline
if ($stoppedEarly) {
  Write-Host "INTERROTTO PER ERRORE" -ForegroundColor Red
} elseif ($failureCount -gt 0) {
  Write-Host "COMPLETATO CON ERRORI" -ForegroundColor Yellow
} else {
  Write-Host "COMPLETATO CON SUCCESSO" -ForegroundColor Green
}
Write-Host "  Durata totale: $(Format-Duration $totalDuration)" -ForegroundColor Gray
Write-Host "  Prompts OK: $successCount" -ForegroundColor Green
Write-Host "  Prompts ERRORE: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Gray" })
Write-Host "  Log: $logPath" -ForegroundColor Gray
Write-Host ""

if ($stoppedEarly) {
  exit 1
} else {
  exit 0
}
