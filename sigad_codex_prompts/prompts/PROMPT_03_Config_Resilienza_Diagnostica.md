# PROMPT 3 — Config DEV, Resilienza e Diagnostica
Reasoning Level: MEDIUM

REGOLE OPERATIVE (MANDATORY)
- Esegui in Windows, directory di lavoro: C:\Accredia\Sviluppo\AU
- È consentito scrivere file ed eseguire comandi solo nel workspace.
- Prima di modificare qualsiasi cosa fai PRE-CHECK e mostra tabella stato.
- Non inventare file o output: se non puoi verificare, dichiara “non verificato”.
- Tutto deve essere idempotente: se esiste, verifica e correggi; non duplicare.
- Rispetta porte fisse e profili DEV solo HTTP.
- Dapper è obbligatorio per accesso dati (niente EF runtime).
- Alla fine di ogni prompt esegui POST-CHECK (dotnet clean/build + test /health).
- Se manca un’informazione che impedisce una decisione certa: fermati e chiedi.

---

## Config
- appsettings.json
- appsettings.Development.json
- Porte solo in launchSettings.json

## Health & Diagnostica
- /health lightweight
- (Opzionale) /health/db con SELECT 1
- Log obbligatori:
  - CorrelationId
  - TraceId

## Resilienza
- Prompt rieseguibili
- Stati intermedi da riparare
- Repo sempre compilabile o diagnosticabile
