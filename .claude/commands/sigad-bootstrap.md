# /sigad-bootstrap — Bootstrap Solution SIGAD

## REGOLE CRITICHE
- **LEGGI PRIMA:** `CLAUDE.md` e `MEMORY.md`
- **USA MCP:** Tool `accredia` per verifiche DB
- **CHECKPOINT:** Salva stato in MEMORY.md dopo ogni fase

---

## FASE 0: CONSULTA MEMORY

```
1. Apri MEMORY.md
2. Verifica stato Prompt 0 (Bootstrap)
3. Se "Completato" → SKIP, vai al prossimo prompt
4. Se "In corso" → riprendi da dove interrotto
5. Se "Pending" → procedi
```

---

## FASE 1: PRE-CHECK

Produci OBBLIGATORIAMENTE questa tabella:

| Elemento | Esiste | Conforme | Azione |
|----------|--------|----------|--------|
| Accredia.SIGAD.sln | ? | ? | ? |
| Accredia.SIGAD.Web | ? | net9.0? | ? |
| Accredia.SIGAD.Gateway | ? | net9.0? | ? |
| Accredia.SIGAD.Identity.Api | ? | net9.0? | ? |
| Accredia.SIGAD.Tipologiche.Api | ? | net9.0? | ? |
| Accredia.SIGAD.Anagrafiche.Api | ? | net9.0? | ? |
| Accredia.SIGAD.Shared | ? | net9.0? | ? |
| launchSettings porte | ? | 7000-7003,7100? | ? |
| MudBlazor in Web | ? | ? | ? |
| YARP in Gateway | ? | ? | ? |
| Dapper nelle API | ? | ? | ? |

---

## FASE 2: AZIONI (Idempotenti)

### Se solution non esiste:
```powershell
cd C:\Accredia\Sviluppo\AU
dotnet new sln -n Accredia.SIGAD
```

### Se progetto non esiste:
```powershell
# Web (Blazor Server)
dotnet new blazor -n Accredia.SIGAD.Web --interactivity Server

# Gateway
dotnet new web -n Accredia.SIGAD.Gateway

# API (Minimal)
dotnet new webapi -n Accredia.SIGAD.Identity.Api --use-minimal-apis
dotnet new webapi -n Accredia.SIGAD.Tipologiche.Api --use-minimal-apis
dotnet new webapi -n Accredia.SIGAD.Anagrafiche.Api --use-minimal-apis

# Shared
dotnet new classlib -n Accredia.SIGAD.Shared

# Aggiungi alla solution
dotnet sln add Accredia.SIGAD.Web
dotnet sln add Accredia.SIGAD.Gateway
dotnet sln add Accredia.SIGAD.Identity.Api
dotnet sln add Accredia.SIGAD.Tipologiche.Api
dotnet sln add Accredia.SIGAD.Anagrafiche.Api
dotnet sln add Accredia.SIGAD.Shared
```

### Packages OBBLIGATORI:
```powershell
# Web
dotnet add Accredia.SIGAD.Web package MudBlazor

# Gateway
dotnet add Accredia.SIGAD.Gateway package Yarp.ReverseProxy

# API (tutti)
dotnet add Accredia.SIGAD.Identity.Api package Dapper
dotnet add Accredia.SIGAD.Identity.Api package Microsoft.Data.SqlClient
# Ripeti per Tipologiche e Anagrafiche
```

### launchSettings.json (PORTE FISSE):
```json
{
  "profiles": {
    "http-dev": {
      "commandName": "Project",
      "applicationUrl": "http://localhost:PORTA",
      "environmentVariables": {
        "ASPNETCORE_ENVIRONMENT": "Development"
      }
    }
  }
}
```
Porte: Web=7000, Gateway=7100, Identity=7001, Tipologiche=7002, Anagrafiche=7003

### Rimuovi demo:
- Elimina WeatherForecast.cs
- Elimina endpoint /weatherforecast da Program.cs

### Health endpoint (ogni API):
```csharp
app.MapGet("/health", () => Results.Ok(new { status = "ok" }));
```

---

## FASE 3: POST-CHECK

```powershell
dotnet build C:\Accredia\Sviluppo\AU\Accredia.SIGAD.sln
```

Se ERRORE:
1. Leggi errore
2. Correggi
3. Ripeti build
4. NON procedere finché non compila

---

## FASE 4: AGGIORNA MEMORY

Aggiorna `MEMORY.md`:
```markdown
### Prompt 0: Bootstrap
- **Stato:** Completato
- **Data:** [oggi]
- **Note:** [eventuali problemi risolti]
```

---

## RECOVERY DA ERRORI COMUNI

| Errore | Soluzione |
|--------|-----------|
| Template blazor non trovato | Usa `dotnet new list` e scegli alternativa |
| Package non trovato | `dotnet restore --force` |
| Porta già in uso | Verifica processi con `netstat -ano` |
| Build fallisce CS0246 | Installa package mancante |
