# SIGAD Codex Prompts — Orchestrazione (Step 7 → 14)

## Prerequisiti
- Windows + .NET SDK 9 installato
- Codex CLI configurato con sandbox `workspace-write`
- Workspace: `C:\Accredia\Sviluppo\AU`

## Porte (DEV HTTP)
- Web 7000
- Gateway 7100
- Identity 7001
- Tipologiche 7002
- Anagrafiche 7003

## Regole chiave
- Dapper obbligatorio per runtime data access
- EF Core solo migrations (design-time)
- Swagger dev-only
- Web parla solo con Gateway

## Ordine di esecuzione
1. META_PROMPT.md
2. PROMPT_7 … PROMPT_14

## Avvio
Metti questa cartella dentro `C:\Accredia\Sviluppo\AU\sigad_codex_prompts` (oppure copia solo i file in `prompts\`).

Poi esegui:
```powershell
.\run_codex_cli.ps1 -From 7 -FullAuto
```

## Log live
```powershell
Get-Content .\codex_run.log -Wait -Tail 80
```
