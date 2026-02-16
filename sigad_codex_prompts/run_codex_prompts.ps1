param(
  [string]$Root = "C:\Accredia\Sviluppo\AU\sigad_codex_prompts\prompts",
  [string]$MetaPrompt = "C:\Accredia\Sviluppo\AU\sigad_codex_prompts\META_PROMPT.md",
  [int]$From = 0
)

function Copy-ToClipboardAndPause($content, $title) {
  Set-Clipboard -Value $content
  Clear-Host
  Write-Host "COPIATO NEGLI APPUNTI:" -ForegroundColor Green
  Write-Host "  $title" -ForegroundColor Yellow
  Write-Host ""
  Write-Host "👉 Incolla ORA in Codex" -ForegroundColor White
  Write-Host "👉 Esegui ciò che Codex propone" -ForegroundColor White
  Write-Host "👉 Torna qui e premi INVIO per continuare" -ForegroundColor White
  Write-Host ""
  Read-Host "Premi INVIO (CTRL+C per uscire)"
}

# 1) META-PROMPT (una sola volta)
if (Test-Path $MetaPrompt) {
  $meta = Get-Content $MetaPrompt -Raw -Encoding UTF8
  Copy-ToClipboardAndPause $meta "META-PROMPT (DA INCOLLARE UNA SOLA VOLTA)"
}

# 2) PROMPT sequenziali
$prompts = Get-ChildItem $Root -Filter "*.md" | Sort-Object Name

if ($prompts.Count -eq 0) {
  Write-Host "Nessun prompt trovato in $Root" -ForegroundColor Red
  exit 1
}

for ($i = $From; $i -lt $prompts.Count; $i++) {
  $file = $prompts[$i]
  $content = Get-Content $file.FullName -Raw -Encoding UTF8
  Copy-ToClipboardAndPause $content "PROMPT [$i] - $($file.Name)"
}
