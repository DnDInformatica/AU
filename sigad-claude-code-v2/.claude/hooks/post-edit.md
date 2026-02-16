---
name: post-edit
description: Hook eseguito automaticamente dopo ogni modifica file
---

# Post-Edit Hook

Questo hook viene eseguito automaticamente DOPO ogni modifica a file nel progetto SIGAD.

## Azioni Automatiche

### 1. Dopo modifica .cs → Build Check

```bash
cd C:\Accredia\Sviluppo\AU
dotnet build --no-restore --verbosity quiet
```

**Se build fallisce:**
1. Analizza errore
2. Tenta fix automatico (max 3 tentativi)
3. Se non risolvibile → mostra errore e suggerimenti

**Se build passa:**
```
✅ Build OK
```

### 2. Dopo modifica .csproj → Restore + Build

```bash
dotnet restore
dotnet build
```

### 3. Dopo modifica appsettings*.json → Validate JSON

```bash
# Verifica JSON valido
python -m json.tool <file> > /dev/null 2>&1
```

**Se JSON invalido → ROLLBACK automatico**

### 4. Dopo modifica a Endpoint → Test Health

Se il servizio è in esecuzione, verifica:

```bash
curl -s http://localhost:<port>/health | jq -e '.status == "ok"'
```

## Recovery Automatico

### Build Error Recovery

```
Tentativo 1: Fix automatico basato su errore
Tentativo 2: Verifica dipendenze mancanti
Tentativo 3: Rollback modifica + report

Dopo 3 tentativi falliti:
🛑 Build failed - Recovery exhausted

Errore: [messaggio]
File: [path:linea]
Modifica: [rollback applicato]

Azione richiesta: Intervento manuale
```

### Pattern Fix Automatici

| Errore | Fix Automatico |
|--------|----------------|
| CS0246: Type not found | Aggiungi using |
| CS1061: No definition | Verifica package, aggiungi reference |
| Missing namespace | Genera using statement |
| Duplicate definition | Rimuovi duplicato |

## Output Standard

### Successo
```
✅ Post-check completed

Build: OK
Changes: 1 file modified
Warnings: 0
```

### Warning
```
⚠️ Post-check completed with warnings

Build: OK
Warnings:
- [CS8600] Possible null reference
- [CS0168] Variable declared but never used

Suggerimento: Considera di risolvere i warning
```

### Errore (con recovery)
```
🔄 Post-check: Build failed, attempting recovery...

Errore: CS0246 - Type 'IDbConnectionFactory' not found
Fix applicato: Added 'using Accredia.SIGAD.Shared.Data;'
Rebuild: OK

✅ Recovery successful
```

### Errore (senza recovery)
```
🛑 Post-check FAILED

Build: FAILED
Error: [dettaglio]

Recovery attempted: 3/3 failed
Last modification rolled back

Richiede intervento manuale.
Suggerimenti:
1. [suggerimento 1]
2. [suggerimento 2]
```

## Metriche Tracked

Ogni post-check aggiorna le metriche in `.claude/memory/metrics.json`:

```json
{
  "totalEdits": 150,
  "successfulBuilds": 145,
  "failedBuilds": 5,
  "autoRecoveries": 3,
  "lastEdit": "2025-02-05T10:30:00Z",
  "commonErrors": {
    "CS0246": 2,
    "CS1061": 1
  }
}
```
