# /sigad-status — Verifica Stato Completo e Memory

## OBIETTIVO
Verificare lo stato attuale del progetto e sincronizzare MEMORY.md

---

## FASE 1: STATO BUILD

```powershell
cd C:\Accredia\Sviluppo\AU
dotnet build Accredia.SIGAD.sln --nologo
```

Riporta:
- Build OK / ERRORE
- Numero warning
- Lista errori (se presenti)

---

## FASE 2: STATO PROGETTI

| Progetto | Esiste | Compila | Packages | Note |
|----------|--------|---------|----------|------|
| Identity.Api | ? | ? | Dapper? | |
| Tipologiche.Api | ? | ? | Dapper? | |
| Anagrafiche.Api | ? | ? | Dapper? | |
| Gateway | ? | ? | YARP? | |
| Web | ? | ? | MudBlazor? | |
| Shared | ? | ? | - | |

---

## FASE 3: VERIFICA PORTE

Leggi launchSettings.json di ogni progetto e verifica:

| Progetto | Porta Attesa | Porta Configurata | OK |
|----------|--------------|-------------------|-----|
| Web | 7000 | ? | ? |
| Gateway | 7100 | ? | ? |
| Identity.Api | 7001 | ? | ? |
| Tipologiche.Api | 7002 | ? | ? |
| Anagrafiche.Api | 7003 | ? | ? |

---

## FASE 4: VERIFICA PATTERN VIETATI

Cerca nei file .cs recenti:
- `AddDbContext` → VIETATO
- `: ControllerBase` → VIETATO
- `[ApiController]` → VIETATO

Riporta eventuali violazioni.

---

## FASE 5: STATO SERVIZI (se in esecuzione)

```powershell
# Verifica porte in ascolto
Get-NetTCPConnection -LocalPort 7000,7001,7002,7003,7100 -State Listen -ErrorAction SilentlyContinue
```

| Porta | Servizio | PID | Status |
|-------|----------|-----|--------|
| 7000 | Web | ? | ? |
| 7001 | Identity | ? | ? |
| 7002 | Tipologiche | ? | ? |
| 7003 | Anagrafiche | ? | ? |
| 7100 | Gateway | ? | ? |

---

## FASE 6: HEALTH CHECK (se servizi attivi)

```powershell
$endpoints = @(
    @{Name="Identity"; Url="http://localhost:7001/health"},
    @{Name="Tipologiche"; Url="http://localhost:7002/health"},
    @{Name="Anagrafiche"; Url="http://localhost:7003/health"},
    @{Name="Gateway"; Url="http://localhost:7100/health"}
)

foreach ($ep in $endpoints) {
    try {
        $r = Invoke-WebRequest $ep.Url -TimeoutSec 3
        Write-Host "$($ep.Name): OK ($($r.StatusCode))"
    } catch {
        Write-Host "$($ep.Name): FAIL"
    }
}
```

---

## FASE 7: SINCRONIZZA MEMORY.md

Aggiorna la sezione "Stato Attuale Progetti" in MEMORY.md con i risultati trovati.

---

## OUTPUT FINALE

### Riepilogo
- **Build:** OK / ERRORE
- **Progetti conformi:** X/6
- **Servizi attivi:** X/5
- **Health OK:** X/4
- **Violazioni pattern:** X

### Prossima Azione Consigliata
[Basata sullo stato trovato]
