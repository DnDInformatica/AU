# SIGAD — Orchestrazione Prompt (Codex)

Questa cartella contiene prompt e script per avviare e standardizzare la solution **Accredia.SIGAD** secondo:
- Microservizi con confini espliciti
- Vertical Slice Architecture (VSA)
- DB centrale con *schema ownership* e *connection string separate per servizio*
- Idempotenza e resilienza a interruzioni
- Dapper obbligatorio per accesso dati (no EF runtime)

## Prerequisiti
- Windows
- .NET SDK (net9.0)
- Git
- Codex CLI configurato con sandbox `workspace-write` sul workspace:
  `C:\Accredia\Sviluppo\AU`

## Struttura cartelle

```
sigad_codex_prompts/
  README.md
  META_PROMPT.md
  sigad.pipeline.yaml
  run_codex_cli.ps1
  run_codex_yaml.ps1
  sanity_checks.ps1
  prompts/
    PROMPT_0_Bootstrap_Verifica_Solution.md
    PROMPT_1_VSA_Microservizi.md
    PROMPT_2_Database_ConnectionString.md
    PROMPT_3_Config_Resilienza_Diagnostica.md
    PROMPT_4_Identity_JWT.md
    PROMPT_5_Versioning_API.md
    PROMPT_6_Osservabilita.md
```

## Ordine di esecuzione (consigliato)
1. PROMPT 0 — Bootstrap, Verifica e Ripristino Solution
2. PROMPT 1 — Baseline Microservizi + VSA
3. PROMPT 2 — Database, Schema Ownership e Connection String (Dapper hard rule)
4. PROMPT 3 — Config DEV, Resilienza e Diagnostica
5. PROMPT 4 — Identity, JWT e Sicurezza Base (VSA)
6. PROMPT 5 — Versioning API e Gateway
7. PROMPT 6 — Osservabilità

## Esecuzione (consigliata)
1) Controlli preliminari:
```powershell
.\sanity_checks.ps1
```

2) Esecuzione sequenziale (semplice):
```powershell
.un_codex_cli.ps1
```

Ripresa da un indice (0-based sulla lista ordinata dei file .md in /prompts):
```powershell
.un_codex_cli.ps1 -From 2
```

## Esecuzione guidata da YAML (PowerShell 7+)
Modifica `sigad.pipeline.yaml` per ordine e reasoning per prompt, poi:
```powershell
.un_codex_yaml.ps1
```

## Regole operative
Le regole globali sono in `META_PROMPT.md` e vengono inviate prima dei prompt.
Ogni prompt deve eseguire PRE-CHECK e POST-CHECK, e fermarsi in caso di errore o informazione mancante.
