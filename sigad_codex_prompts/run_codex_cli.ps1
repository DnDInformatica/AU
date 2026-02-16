param(
  [string]$PromptRoot = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\prompts',
  [string]$MetaPrompt = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\META_PROMPT.md',
  [string]$WorkDir    = 'C:\Accredia\Sviluppo\AU',
  [int]$From = 0,
  [string]$LogFile = 'codex_run.log'
)

function Get-ReasoningEffort {
  param([string]$FileName)
  if ($FileName -match '__RLOW\b')  { return 'low' }
  if ($FileName -match '__RMED\b')  { return 'medium' }
  if ($FileName -match '__RHIGH\b') { return 'high' }
  return 'medium'
}

function Run-CodexPromptFile {
  param([Parameter(Mandatory=$true)][string]$PromptFile)

  $name = Split-Path $PromptFile -Leaf
  $effort = Get-ReasoningEffort $name

  Write-Host "==================================================" -ForegroundColor Cyan
  Write-Host "PROMPT: $name" -ForegroundColor Green
  Write-Host "WorkDir: $WorkDir | Sandbox: workspace-write | Reasoning: $effort" -ForegroundColor Yellow
  Write-Host "==================================================" -ForegroundColor Cyan

  # FIX: Log header in UTF-8
  $header = "`n[$(Get-Date -Format u)] PROMPT: $PromptFile | effort=$effort`n"
  Add-Content -Path $LogFile -Value $header -Encoding UTF8

  $prompt = Get-Content -Path $PromptFile -Raw -Encoding UTF8

  # Execute codex and capture ALL output
  try {
    $out = & codex exec `
      -C $WorkDir `
      --sandbox workspace-write `
      -c ('model_reasoning_effort="' + $effort + '"') `
      $prompt 2>&1
  } catch {
    Write-Host "❌ Errore esecuzione Codex: $_" -ForegroundColor Red
    Add-Content -Path $LogFile -Value "ERROR: $_" -Encoding UTF8
    return $false
  }

  # FIX: Write output as UTF-8 strings (not direct pipe)
  if ($out -is [array]) {
    $outText = $out -join "`n"
  } else {
    $outText = [string]$out
  }
  
  # Write to console AND log file (both UTF-8)
  Write-Host $outText
  Add-Content -Path $LogFile -Value $outText -Encoding UTF8

  # Check for errors
  if ($outText -match 'sandbox:\s*read-only') {
    Write-Host "❌ Codex è tornato in read-only. STOP." -ForegroundColor Red
    return $false
  }

  if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Codex exit code: $LASTEXITCODE" -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value "WARN: exit code=$LASTEXITCODE" -Encoding UTF8
    # Non usciamo, continua con il prossimo prompt
  }
  
  return $true
}

# ===== MAIN =====

# checks
if (-not (Test-Path $PromptRoot)) { 
  Write-Host "❌ PromptRoot non trovato: $PromptRoot" -ForegroundColor Red
  exit 1 
}
if (-not (Test-Path $WorkDir)) { 
  Write-Host "❌ WorkDir non trovato: $WorkDir" -ForegroundColor Red
  exit 1 
}

# Initialize log file as UTF-8
"[$(Get-Date -Format u)] Script start - run_codex_cli.ps1 FIXED VERSION" | Out-File -FilePath $LogFile -Encoding UTF8 -Force

# META first
if (Test-Path $MetaPrompt) {
  if (-not (Run-CodexPromptFile -PromptFile $MetaPrompt)) {
    Write-Host "⚠️  META_PROMPT fallì, ma continuando..." -ForegroundColor Yellow
  }
} else {
  Write-Host "⚠️ META_PROMPT.md non trovato: $MetaPrompt (proseguo)" -ForegroundColor Yellow
}

# Process prompts
$prompts = Get-ChildItem -Path $PromptRoot -Filter '*.md' | Sort-Object Name

if ($prompts.Count -eq 0) { 
  Write-Host "❌ Nessun prompt trovato in $PromptRoot" -ForegroundColor Red
  exit 1 
}

if ($From -lt 0 -or $From -ge $prompts.Count) { 
  Write-Host "❌ -From fuori range (0-$($prompts.Count-1))" -ForegroundColor Red
  exit 1 
}

Write-Host ""
Write-Host "Processing $($prompts.Count - $From) prompts (from index $From)..." -ForegroundColor Cyan
Write-Host ""

$successCount = 0
$failureCount = 0

for ($i = $From; $i -lt $prompts.Count; $i++) {
  $result = Run-CodexPromptFile -PromptFile $prompts[$i].FullName
  if ($result) {
    $successCount++
  } else {
    $failureCount++
  }
  Write-Host ""
}

# Summary
$logPath = (Resolve-Path $LogFile).Path
Write-Host "✅ Completato!" -ForegroundColor Green
Write-Host "   Prompts elaborati: $successCount success, $failureCount warnings"
Write-Host "   Log salvato: $logPath"
Write-Host "   Size: $((Get-Item $LogFile).Length) bytes"

exit 0