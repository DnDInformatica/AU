param(
  [string]$PipelineFile = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\sigad_codex_prompts\sigad.pipeline.yaml',
  [string]$PromptRoot   = 'C:\Accredia\Sviluppo\AU\sigad_codex_prompts\sigad_codex_prompts\prompts',
  [string]$LogFile      = 'codex_run.log'
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command ConvertFrom-Yaml -ErrorAction SilentlyContinue)) {
  throw "ConvertFrom-Yaml non disponibile. Usa PowerShell 7+ oppure installa un modulo YAML."
}

if (-not (Test-Path $PipelineFile)) { throw "Pipeline YAML non trovato: $PipelineFile" }
if (-not (Test-Path $PromptRoot))   { throw "PromptRoot non trovato: $PromptRoot" }

$pipeline = Get-Content $PipelineFile -Raw | ConvertFrom-Yaml

$WorkDir = $pipeline.workspace
$Sandbox = $pipeline.sandbox
$DefaultReasoning = $pipeline.defaults.reasoning
$StopOnError = [bool]$pipeline.defaults.stopOnError

if ($WorkDir -ne "C:\Accredia\Sviluppo\AU") {
  throw "Workspace non autorizzato: $WorkDir"
}

function Run-Prompt {
  param(
    [Parameter(Mandatory=$true)][string]$PromptPath,
    [Parameter(Mandatory=$true)][string]$Reasoning
  )

  $name = Split-Path $PromptPath -Leaf
  Write-Host "==================================================" -ForegroundColor Cyan
  Write-Host "PROMPT: $name" -ForegroundColor Green
  Write-Host "WorkDir: $WorkDir | Sandbox: $Sandbox | Reasoning: $Reasoning" -ForegroundColor Yellow
  Write-Host "==================================================" -ForegroundColor Cyan

  Add-Content -Path $LogFile -Value "`n[$(Get-Date -Format u)] PROMPT: $PromptPath | reasoning=$Reasoning | sandbox=$Sandbox"

  $promptText = Get-Content $PromptPath -Raw -Encoding UTF8

  $out = & codex exec `
    -C $WorkDir `
    --sandbox $Sandbox `
    -c ('model_reasoning_effort="' + $Reasoning + '"') `
    $promptText 2>&1

  $out | Tee-Object -FilePath $LogFile -Append | Out-Null

  if ($out -match 'sandbox:\s*read-only') { throw "Codex è tornato in read-only." }
  if ($LASTEXITCODE -ne 0 -and $StopOnError) { throw "Codex exit code: $LASTEXITCODE" }
}

foreach ($p in $pipeline.prompts) {
  $file = $p.file
  $reasoning = $p.reasoning
  if (-not $reasoning) { $reasoning = $DefaultReasoning }

  $promptPath = Join-Path $PromptRoot $file
  if (-not (Test-Path $promptPath)) { throw "Prompt mancante: $file" }

  Run-Prompt -PromptPath $promptPath -Reasoning $reasoning
}

Write-Host "✅ Completato. Log: $((Resolve-Path $LogFile).Path)" -ForegroundColor Green
