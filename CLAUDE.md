# SIGAD — Istruzioni Operative per Claude Code

> ⚠️ **QUESTO FILE CONTIENE REGOLE OBBLIGATORIE. VIOLAZIONI = ERRORE.**

---

## 🚨 REGOLE CRITICHE — LEGGI PRIMA DI OGNI AZIONE

### STOP IMMEDIATO SE:
- [ ] Non hai fatto PRE-CHECK con tabella di stato
- [ ] Stai per usare Entity Framework a runtime
- [ ] Stai per creare un Controller MVC
- [ ] Stai per scrivere fuori da `C:\Accredia\Sviluppo\AU`
- [ ] Stai per usare una porta diversa da quelle assegnate
- [ ] Stai per far chiamare un'API direttamente dal Web (deve passare da Gateway)

---

## 📋 CHECKLIST OBBLIGATORIA (OGNI TASK)

```
□ 1. PRE-CHECK eseguito con tabella stato
□ 2. MEMORY.md consultato per decisioni precedenti
□ 3. Regole HARD verificate
□ 4. Modifiche idempotenti (no duplicazioni)
□ 5. POST-CHECK: build + health check
□ 6. MEMORY.md aggiornato se decisioni prese
```

---

## ⚙️ CONFIGURAZIONE AMBIENTE

### Variabili d'Ambiente
```
DOTNET_CLI_TELEMETRY_OPTOUT=1
ASPNETCORE_ENVIRONMENT=Development
```

### Working Directory
```
C:\Accredia\Sviluppo\AU
```

### MCP Server
Il server MCP `accredia` è configurato in `settings.json` e fornisce accesso al database SQL Server ACCREDIA.

---

## 🔴 REGOLE HARD — VIOLAZIONE = ERRORE IMMEDIATO

### DATA ACCESS
```
✅ OBBLIGATORIO: Dapper per OGNI accesso dati runtime
❌ VIETATO: DbContext, AddDbContext, EF Core a runtime
❌ VIETATO: Repository pattern con EF
⚠️ ECCEZIONE: EF SOLO per migrations (IDesignTimeDbContextFactory)
```

### ARCHITETTURA
```
✅ OBBLIGATORIO: Minimal API (MapGet, MapPost, etc.)
❌ VIETATO: Controller MVC ([ApiController], ControllerBase)
❌ VIETATO: Web chiama API direttamente (DEVE usare Gateway)
✅ OBBLIGATORIO: VSA - Features/<Nome>/Endpoints.cs
```

### PORTE — NON MODIFICABILI
| Servizio | Porta | Violazione |
|----------|-------|------------|
| Web | 7000 | ❌ ERRORE se diversa |
| Gateway | 7100 | ❌ ERRORE se diversa |
| Identity.Api | 7001 | ❌ ERRORE se diversa |
| Tipologiche.Api | 7002 | ❌ ERRORE se diversa |
| Anagrafiche.Api | 7003 | ❌ ERRORE se diversa |

### DATABASE
```
✅ OBBLIGATORIO: Schema ownership (Identity→Identity, etc.)
❌ VIETATO: Creare oggetti in schema dbo
✅ OBBLIGATORIO: ConnectionStrings separate per servizio
```

### UI
```
✅ OBBLIGATORIO: MudBlazor per ogni componente UI
❌ VIETATO: Bootstrap, Tailwind, CSS puro per componenti
❌ VIETATO: /weatherforecast, demo, sample
```

---

## 🔧 MCP SERVER ACCREDIA — USA QUESTI TOOL

Il server MCP `accredia` è disponibile con questi tool:

| Tool | Uso | Quando |
|------|-----|--------|
| `execute_sql` | Query SQL | Verificare dati, test query |
| `describe_table` | Schema tabella | Prima di scrivere Dapper |
| `list_tables` | Elenco tabelle | Esplorazione DB |
| `db_schema_json` | Schema completo | Generazione codice |
| `validate_table_conformity` | Validazione governance | Prima di CREATE TABLE |
| `check_governance_rules` | Regole ACCREDIA | Verifica compliance |

### PRIMA DI SCRIVERE CODICE DAPPER:
```
1. Usa describe_table per verificare schema
2. Usa execute_sql per testare la query
3. Solo dopo scrivi il codice C#
```

---

## 📁 STRUTTURA PROGETTO

```
C:\Accredia\Sviluppo\AU\
├── CLAUDE.md              ← QUESTO FILE (regole)
├── MEMORY.md              ← Decisioni e stato (LEGGERE SEMPRE)
├── Accredia.SIGAD.sln
├── Accredia.SIGAD.Web/            # Porta 7000
├── Accredia.SIGAD.Gateway/        # Porta 7100
├── Accredia.SIGAD.Identity.Api/   # Porta 7001
├── Accredia.SIGAD.Tipologiche.Api/# Porta 7002
├── Accredia.SIGAD.Anagrafiche.Api/# Porta 7003
└── Accredia.SIGAD.Shared/         # Cross-cutting
```

---

## 🔄 WORKFLOW OBBLIGATORIO

### PRE-CHECK (PRIMA di ogni modifica)
```markdown
| Elemento | Esiste | Conforme | Azione |
|----------|--------|----------|--------|
| [file/risorsa] | ✅/❌ | ✅/❌ | Crea/Correggi/Nessuna |
```

### POST-CHECK (DOPO ogni modifica)
```powershell
# 1. Build
dotnet build C:\Accredia\Sviluppo\AU\Accredia.SIGAD.sln

# 2. Se ERRORE → correggi e ripeti
# 3. Se OK → verifica health (se servizi attivi)
```

### RECOVERY DA ERRORE
```
1. STOP - non procedere
2. Leggi l'errore completo
3. Consulta MEMORY.md per errori simili già risolti
4. Correggi il problema specifico
5. Ripeti POST-CHECK
6. Aggiorna MEMORY.md con la soluzione
```

---

## 📝 PATTERN DI CODICE APPROVATI

### Dapper Query (USARE QUESTO)
```csharp
public async Task<IEnumerable<T>> GetAllAsync()
{
    using var connection = _connectionFactory.CreateConnection();
    return await connection.QueryAsync<T>(
        "SELECT * FROM [Schema].[Table] WHERE IsActive = 1");
}
```

### Minimal API Endpoint (USARE QUESTO)
```csharp
public static class MyEndpoints
{
    public static void MapMyEndpoints(this WebApplication app)
    {
        app.MapGet("/api/v1/resource", HandleGet)
           .WithName("GetResource")
           .WithTags("Resource");
    }
    
    private static async Task<IResult> HandleGet(IMyService service)
    {
        var result = await service.GetAllAsync();
        return Results.Ok(result);
    }
}
```

### ❌ PATTERN VIETATI
```csharp
// ❌ NO - Controller MVC
[ApiController]
public class MyController : ControllerBase { }

// ❌ NO - EF DbContext a runtime
services.AddDbContext<MyContext>();

// ❌ NO - Repository con EF
public class MyRepository { 
    private readonly DbContext _context; // VIETATO
}
```

---

## 🎯 OBIETTIVO SESSIONE

Consulta sempre `MEMORY.md` per:
- Stato avanzamento corrente
- Decisioni già prese
- Errori già risolti
- Prossimi task da completare

---

## ⚡ QUICK REFERENCE

| Devo... | Fai... |
|---------|--------|
| Accedere al DB | Usa Dapper + IDbConnectionFactory |
| Creare endpoint | MapGet/MapPost in Features/*/Endpoints.cs |
| Verificare schema | MCP: describe_table |
| Testare query | MCP: execute_sql |
| Creare UI | MudBlazor components |
| Chiamare API da Web | HttpClient verso Gateway (7100) |
| Persistere decisione | Aggiorna MEMORY.md |

---

---

## 🚫 PATTERN VIETATI (RILEVAMENTO AUTOMATICO)

Se trovi questi pattern nel codice, **ERRORE IMMEDIATO**:

| Pattern | Motivo | Alternativa |
|---------|--------|-------------|
| `AddDbContext` | EF a runtime vietato | `IDbConnectionFactory` + Dapper |
| `DbContext` (non migration) | EF a runtime vietato | Dapper |
| `ControllerBase` | MVC vietato | Minimal API |
| `[ApiController]` | MVC vietato | Minimal API |
| `EntityFrameworkCore` (runtime) | EF a runtime vietato | Dapper |
| `using Microsoft.EntityFrameworkCore;` (non migration) | EF a runtime | Rimuovi |

---

**Ultima modifica:** 2025-02-05
**Versione regole:** 2.1
**Nota:** Le configurazioni custom (porte, pattern vietati, regole) sono in questo file. Il file `.claude/settings.json` contiene solo configurazioni supportate dallo schema ufficiale Claude Code.
