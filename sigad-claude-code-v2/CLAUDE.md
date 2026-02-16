# SIGAD — Istruzioni Claude Code (v2.0)

> ⚠️ **REGOLE HARD** - Violazioni = blocco immediato e correzione

## 🔒 VINCOLI NON NEGOZIABILI

### Data Access
```
✅ OBBLIGATORIO: Dapper per OGNI accesso dati
❌ VIETATO: DbContext, AddDbContext, EF Core a runtime
❌ VIETATO: new SqlConnection() senza factory
```

**Pattern corretto:**
```csharp
// ✅ CORRETTO
public class GetUserHandler(IDbConnectionFactory db)
{
    public async Task<User?> Handle(Guid id)
    {
        using var conn = db.CreateConnection();
        return await conn.QuerySingleOrDefaultAsync<User>(
            "SELECT * FROM Identity.Users WHERE UserId = @Id",
            new { Id = id });
    }
}

// ❌ VIETATO - NON GENERARE MAI
services.AddDbContext<AppDbContext>(...);
await _context.Users.FindAsync(id);
```

### Architettura
```
✅ Web chiama SOLO Gateway (localhost:7100)
❌ VIETATO: Web chiama direttamente API (7001/7002/7003)
✅ API usano Minimal API + VSA
❌ VIETATO: Controller MVC, [ApiController]
✅ Schema ownership per servizio
❌ VIETATO: Oggetti in schema dbo
```

### Configurazione
```
✅ UN SOLO profilo: "http-dev"
❌ VIETATO: HTTPS, profili multipli, IIS Express
✅ Porte FISSE (vedi tabella)
❌ VIETATO: Porte random o diverse
```

## 📍 Porte Fisse

| Servizio | Porta | Schema DB |
|----------|-------|-----------|
| Web | 7000 | - |
| Gateway | 7100 | - |
| Identity.Api | 7001 | Identity |
| Tipologiche.Api | 7002 | Tipologiche |
| Anagrafiche.Api | 7003 | Anagrafiche |

## 📁 Struttura Solution

```
C:\Accredia\Sviluppo\AU\
├── Accredia.SIGAD.sln
├── Accredia.SIGAD.Web/              # Blazor Server + MudBlazor
├── Accredia.SIGAD.Gateway/          # YARP
├── Accredia.SIGAD.Identity.Api/     # Auth + JWT
│   └── Features/
│       ├── Health/
│       ├── Auth/
│       │   ├── Login/
│       │   │   ├── LoginCommand.cs
│       │   │   ├── LoginHandler.cs
│       │   │   ├── LoginValidator.cs
│       │   │   └── LoginEndpoint.cs
│       │   └── Register/
│       └── Database/
├── Accredia.SIGAD.Tipologiche.Api/
├── Accredia.SIGAD.Anagrafiche.Api/
└── Accredia.SIGAD.Shared/           # Cross-cutting ONLY
```

## 🏗️ Vertical Slice Architecture (VSA)

### Struttura Feature OBBLIGATORIA
```
Features/<Domain>/<Action>/
├── <Action>Command.cs      # Input DTO
├── <Action>Handler.cs      # Business logic + Dapper
├── <Action>Validator.cs    # FluentValidation (se necessario)
├── <Action>Response.cs     # Output DTO (se diverso da entity)
└── <Action>Endpoint.cs     # Minimal API endpoint
```

### Template Handler (Dapper)
```csharp
namespace Accredia.SIGAD.<Service>.Api.Features.<Domain>.<Action>;

public sealed class <Action>Handler(IDbConnectionFactory db, ILogger<<Action>Handler> logger)
{
    public async Task<<Action>Response> HandleAsync(<Action>Command command, CancellationToken ct = default)
    {
        logger.LogInformation("Executing <Action> for {Id}", command.Id);
        
        using var conn = db.CreateConnection();
        
        // Query Dapper
        var result = await conn.QueryAsync<Entity>(
            @"SELECT * FROM <Schema>.<Table> WHERE ...",
            new { command.Id },
            commandTimeout: 30);
            
        return new <Action>Response(result);
    }
}
```

### Template Endpoint
```csharp
namespace Accredia.SIGAD.<Service>.Api.Features.<Domain>.<Action>;

public static class <Action>Endpoint
{
    public static IEndpointRouteBuilder Map<Action>Endpoint(this IEndpointRouteBuilder app)
    {
        app.MapGet("/v1/<domain>/{id:guid}", async (
            Guid id,
            <Action>Handler handler,
            CancellationToken ct) =>
        {
            var result = await handler.HandleAsync(new(id), ct);
            return result is null ? Results.NotFound() : Results.Ok(result);
        })
        .WithName("<Action>")
        .WithTags("<Domain>")
        .Produces<Entity>(200)
        .Produces(404);
        
        return app;
    }
}
```

## 🔄 Workflow Operativo

### PRE-CHECK (Automatico via hook)
Prima di OGNI modifica, verifica:
1. ✅ File/cartella target esiste?
2. ✅ Pattern corrente conforme?
3. ✅ Nessun conflitto con regole HARD?

Output: Tabella stato → Azione

### POST-CHECK (Automatico via hook)
Dopo OGNI modifica:
1. `dotnet build --no-restore`
2. Se errore → correggi automaticamente
3. Se OK → verifica /health (se servizio avviato)

### Recovery Automatico
Se errore di build:
1. Analizza errore
2. Applica fix
3. Rebuild
4. Max 3 tentativi, poi STOP con diagnostica

## 🛠️ Comandi Disponibili

| Comando | Descrizione |
|---------|-------------|
| `/sigad:bootstrap` | Setup/verifica solution |
| `/sigad:feature <service> <domain> <action>` | Genera feature VSA completa |
| `/sigad:endpoint <service> <path> <method>` | Aggiunge endpoint |
| `/sigad:validate` | Verifica conformità totale |
| `/sigad:db:query <sql>` | Esegue query via MCP |
| `/sigad:db:schema <table>` | Mostra struttura tabella |

## 🤖 Subagent Disponibili

| Agent | Uso |
|-------|-----|
| `sigad-validator` | Valida codice contro regole |
| `sigad-dapper` | Genera query Dapper ottimizzate |
| `sigad-vsa` | Genera feature VSA complete |
| `sigad-debugger` | Debug errori specifici SIGAD |

## 📊 Integrazione Database

### MCP Server SQL
```json
{
  "mcpServers": {
    "sigad-db": {
      "command": "node",
      "args": ["path/to/mcp-sqlserver"],
      "env": {
        "DB_CONNECTION": "Server=...;Database=SIGAD;..."
      }
    }
  }
}
```

### Query Patterns
```sql
-- Lista con paging (pattern standard)
SELECT * FROM <Schema>.<Table>
WHERE (@Search IS NULL OR Name LIKE '%' + @Search + '%')
ORDER BY CreatedUtc DESC
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;

-- Count totale
SELECT COUNT(*) FROM <Schema>.<Table>
WHERE (@Search IS NULL OR Name LIKE '%' + @Search + '%');
```

## 🚨 Anti-Pattern (NON FARE MAI)

```csharp
// ❌ EF Core
services.AddDbContext<...>();
_context.SaveChangesAsync();

// ❌ Controller MVC
[ApiController]
public class UsersController : ControllerBase

// ❌ Connection diretta
new SqlConnection(connString);

// ❌ Schema dbo
"SELECT * FROM Users" // manca schema!

// ❌ Chiamata diretta da Web
HttpClient.GetAsync("http://localhost:7001/...") // deve usare 7100!

// ❌ Demo/WeatherForecast
app.MapGet("/weatherforecast", ...);
```

## ✅ Checklist Prima di Commit

- [ ] Nessun `DbContext` o EF Core a runtime
- [ ] Tutti gli accessi DB via `IDbConnectionFactory` + Dapper
- [ ] Tutti gli endpoint in struttura VSA
- [ ] Schema specificato in ogni query SQL
- [ ] Web chiama solo Gateway
- [ ] Porte corrette in launchSettings.json
- [ ] Build passa senza warning critici
- [ ] /health risponde 200 OK

## 📝 Memory Persistente

Claude Code ricorda tra sessioni:
- Decisioni architetturali approvate
- Errori risolti e come
- Pattern di codice validati
- Stato avanzamento task

File: `.claude/memory/sigad-context.md`
