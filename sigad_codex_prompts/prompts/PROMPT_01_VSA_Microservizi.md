# PROMPT 1 — Baseline Microservizi + Vertical Slice Architecture (con MudBlazor Web)
Reasoning Level: MEDIUM

## REGOLE OPERATIVE (MANDATORY)
- Workspace unico: C:\Accredia\Sviluppo\AU (non scrivere fuori).
- PRE-CHECK prima di modifiche, POST-CHECK alla fine.
- Idempotenza: verifica/correggi, non duplicare.
- Se manca un’informazione che impedisce una decisione certa: STOP e chiedi.

## OBIETTIVO
Imporre baseline coerente con:
- Microservizi (API indipendenti, comunicazione solo HTTP)
- Vertical Slice Architecture (VSA) per le API
- Frontend Blazor Server che usa MudBlazor (UI framework obbligatorio)

## REGOLE HARD
- Ogni microservizio:
  - non referenzia altri servizi
  - comunica solo via HTTP
- Vietati controller MVC nelle API: usare Minimal API
- Accredia.SIGAD.Shared:
  - solo cross-cutting (Result, Error, Pagination, ecc.)
  - utilities tecniche
  - vietata condivisione di domain model
- Dapper obbligatorio per accesso dati (niente EF runtime) — sarà applicato nei prompt DB.

## VERTICAL SLICE ARCHITECTURE (API)
Struttura feature:
```
Features/<FeatureName>/
  Command.cs
  Handler.cs
  Validator.cs
  Endpoints.cs
  EndpointConfiguration.cs
```

### Health Feature (VSA Example)
Per ciascuna API, crea:
```
Features/Health/
  HealthEndpointConfiguration.cs
```

**HealthEndpointConfiguration.cs** (pattern unificato per tutte le API):
```csharp
namespace Accredia.SIGAD.Identity.Api.Features.Health;

public static class HealthEndpointConfiguration
{
    public static WebApplication MapHealthEndpoints(this WebApplication app)
    {
        app.MapGet("/health", () => new { status = "ok" })
            .WithName("Health")
            .WithDescription("Health check endpoint");
        
        return app;
    }
}
```

Nota: Identico per Identity, Tipologiche, Anagrafiche — il namespace cambia solo il nome servizio.

- Anche Health deve seguire VSA (feature Health).
- Program.cs deve limitarsi a:
  - setup DI (builder.Services)
  - registrazione delle endpoint configuration (app.MapHealthEndpoints())
  - pipeline middleware (CORS, logging, etc.)

## IMPLEMENTAZIONE (IDEMPOTENTE)

### Step 1: Crea Feature Health per ogni API
Per ciascuna API (Identity.Api, Tipologiche.Api, Anagrafiche.Api):
1) Crea directory: `Features/Health/`
2) Crea file: `HealthEndpointConfiguration.cs` con contenuto:

```csharp
namespace Accredia.SIGAD.<ServiceName>.Api.Features.Health;

public static class HealthEndpointConfiguration
{
    public static WebApplication MapHealthEndpoints(this WebApplication app)
    {
        app.MapGet("/health", () => new { status = "ok" })
            .WithName("Health")
            .WithDescription("Health check endpoint");
        
        return app;
    }
}
```

Sostituisci `<ServiceName>` con: Identity, Tipologiche, Anagrafiche

### Step 2: Update Program.cs (minimal)
Per ciascuna API, il Program.cs deve:
1) Importare il namespace:
   ```csharp
   using Accredia.SIGAD.<ServiceName>.Api.Features.Health;
   using Accredia.SIGAD.Shared;
   ```

2) Registrare gli endpoint:
   ```csharp
   var app = builder.Build();
   
   // Pipeline middleware (se necessario)
   
   // Registra feature configuration
   app.MapHealthEndpoints();
   
   app.Run();
   ```

3) **Rimuovi**: Qualsiasi MapGet("/health") che esiste direttamente in Program.cs

### Step 3: Web Blazor
Il progetto Web non ha feature Health — rimane intatto per ora.

## PRE-CHECK
Verifica per ciascuna API:
- presenza cartella Features
- presenza feature Health in struttura VSA
- Program.cs “thin”
- nessun controller MVC
- /health esiste e risponde

## AZIONI
- Se le API sono ancora “tutto in Program.cs”, refactor minimo per:
  - estrarre Health in VSA
  - predisporre la struttura Features per i prossimi prompt
- Non introdurre nuove funzionalità oltre la baseline.

## POST-CHECK
- dotnet clean
- dotnet build
- verifica /health (7001/7002/7003)
