---
name: sigad:bootstrap
description: Setup/verifica completa della solution SIGAD con recovery automatico
args:
  - name: mode
    description: "Modalità (create, verify, repair)"
    required: false
    default: "verify"
---

# Bootstrap SIGAD

Setup, verifica e riparazione della solution Accredia.SIGAD.

## Modalità

### verify (default)
Verifica stato corrente senza modifiche distruttive.

### create
Crea solution e progetti mancanti.

### repair
Corregge automaticamente problemi trovati.

## Processo

### Step 1: PRE-CHECK
```
╔════════════════════════════════════════════════════════╗
║  PRE-CHECK - Solution Status                           ║
╠════════════════════════════════════════════════════════╣

| Componente | Esiste | In SLN | net9.0 | Conforme |
|------------|--------|--------|--------|----------|
| Solution   |   ?    |   -    |   -    |    ?     |
| Web        |   ?    |   ?    |   ?    |    ?     |
| Gateway    |   ?    |   ?    |   ?    |    ?     |
| Identity   |   ?    |   ?    |   ?    |    ?     |
| Tipologiche|   ?    |   ?    |   ?    |    ?     |
| Anagrafiche|   ?    |   ?    |   ?    |    ?     |
| Shared     |   ?    |   ?    |   ?    |    ?     |

Porte:
| Servizio | Attesa | Configurata | Status |
|----------|--------|-------------|--------|
| Web      | 7000   |      ?      |   ?    |
| Gateway  | 7100   |      ?      |   ?    |
| Identity | 7001   |      ?      |   ?    |
| Tipologiche| 7002 |      ?      |   ?    |
| Anagrafiche| 7003 |      ?      |   ?    |

╚════════════════════════════════════════════════════════╝
```

### Step 2: Azioni (se mode != verify)

#### Solution
```powershell
# Se manca
dotnet new sln -n Accredia.SIGAD
```

#### Progetti
```powershell
# Web - Blazor Server
dotnet new blazor -n Accredia.SIGAD.Web --interactivity Server
dotnet add Accredia.SIGAD.Web package MudBlazor

# Gateway
dotnet new web -n Accredia.SIGAD.Gateway
dotnet add Accredia.SIGAD.Gateway package Yarp.ReverseProxy

# API
dotnet new webapi -n Accredia.SIGAD.Identity.Api --use-minimal-apis
dotnet new webapi -n Accredia.SIGAD.Tipologiche.Api --use-minimal-apis
dotnet new webapi -n Accredia.SIGAD.Anagrafiche.Api --use-minimal-apis

# Shared
dotnet new classlib -n Accredia.SIGAD.Shared

# Aggiungi a solution
dotnet sln add **/*.csproj
```

#### Configurazione Porte
Per ogni progetto, crea/aggiorna `Properties/launchSettings.json`:
```json
{
  "profiles": {
    "http-dev": {
      "commandName": "Project",
      "dotnetRunMessages": true,
      "launchBrowser": false,
      "applicationUrl": "http://localhost:<PORT>",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```

#### Rimozione Demo
```powershell
# Rimuovi WeatherForecast da tutte le API
Remove-Item -Path "**/WeatherForecast*.cs" -Recurse -Force
```

#### Health Endpoint
Per ogni API, crea `Features/Health/HealthEndpointConfiguration.cs`

### Step 3: POST-CHECK
```powershell
dotnet clean
dotnet build

# Verifica health (se servizi avviati)
foreach ($port in 7001,7002,7003,7100) {
    Invoke-WebRequest "http://localhost:$port/health" -UseBasicParsing
}
```

## Output Finale

```
╔════════════════════════════════════════════════════════╗
║  BOOTSTRAP COMPLETATO                                  ║
╠════════════════════════════════════════════════════════╣

Solution: C:\Accredia\Sviluppo\AU\Accredia.SIGAD.sln

Progetti:
✅ Accredia.SIGAD.Web (7000)
✅ Accredia.SIGAD.Gateway (7100)
✅ Accredia.SIGAD.Identity.Api (7001)
✅ Accredia.SIGAD.Tipologiche.Api (7002)
✅ Accredia.SIGAD.Anagrafiche.Api (7003)
✅ Accredia.SIGAD.Shared

Build: ✅ OK
Health: ⏳ Servizi non avviati

╠════════════════════════════════════════════════════════╣

Prossimi passi:
1. /sigad:feature identity health list
2. dotnet run --project Accredia.SIGAD.Identity.Api
3. /sigad:validate

╚════════════════════════════════════════════════════════╝
```

## Recovery Automatico

Se errore durante bootstrap:
1. Salva stato corrente
2. Tenta rollback parziale
3. Riprova operazione fallita
4. Se 3 fallimenti → STOP con diagnostica
