# Verifica che ogni file *.razor in Components/Pages/** abbia l'attributo
# data-dev-component, indispensabile per il Dev Inspector.
#
# Uso (chiamato da MSBuild):
#   powershell.exe -ExecutionPolicy Bypass -NoProfile -File tools/check-page-annotations.ps1 -ProjectDir <path>
#
# Exit code:
#   0 = tutte le pagine annotate
#   1 = una o più pagine senza annotation -> build fallisce

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectDir
)

$ErrorActionPreference = 'Stop'

$pagesDir = Join-Path $ProjectDir 'Components\Pages'
if (-not (Test-Path $pagesDir)) {
    Write-Host "[dev-inspector] Pages directory non trovata: $pagesDir (skip check)"
    exit 0
}

$razorFiles = Get-ChildItem -Path $pagesDir -Filter '*.razor' -Recurse -File
$missing = @()

foreach ($file in $razorFiles) {
    $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }
    if ($content -notmatch 'data-dev-component') {
        $relPath = $file.FullName.Substring($ProjectDir.Length).TrimStart('\', '/')
        $missing += $relPath
    }
}

if ($missing.Count -gt 0) {
    Write-Host ''
    Write-Host '[dev-inspector] COVERAGE CHECK FAILED' -ForegroundColor Red
    Write-Host "  $($missing.Count) page component(s) missing 'data-dev-component':" -ForegroundColor Red
    foreach ($m in $missing) {
        Write-Host "    - $m" -ForegroundColor Red
    }
    Write-Host ''
    Write-Host '  Add the annotation to the root element of each page:' -ForegroundColor Yellow
    Write-Host '    <MudContainer data-dev-component="@DevInspector.Annota("Page.<Folder>.<Name>")"' -ForegroundColor Yellow
    Write-Host '             data-dev-source="@DevInspector.Annota("Components/Pages/<Folder>/<Name>.razor")">' -ForegroundColor Yellow
    Write-Host '      ...' -ForegroundColor Yellow
    Write-Host '    </MudContainer>' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '  Convenzione: docs/ui/20261105-allineamento-regole-portale.md (fase 4).' -ForegroundColor Yellow
    Write-Host ''
    exit 1
}

Write-Host "[dev-inspector] coverage OK: $($razorFiles.Count) pagine annotate." -ForegroundColor Green
exit 0
