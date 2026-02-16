# VSA - Vertical Slice Architecture

Applica la Vertical Slice Architecture a tutte le API del progetto SIGAD.

## OBIETTIVO
Refactoring delle API per seguire VSA con:
- Microservizi indipendenti (comunicazione solo HTTP)
- Feature-based folder structure
- Minimal API (vietati controller MVC)

## STRUTTURA VSA
```
Features/<FeatureName>/
├── Command.cs
├── Handler.cs
├── Validator.cs
├── Endpoints.cs
└── EndpointConfiguration.cs
```

## HEALTH FEATURE (per ogni API)
Crea `Features/Health/HealthEndpointConfiguration.cs`:
```csharp
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

## REGOLE
- Program.cs deve essere "thin": solo DI setup e endpoint registration
- Shared: solo cross-cutting (Result, Error, Pagination)
- VIETATA condivisione domain model tra servizi
- Dapper obbligatorio per accesso dati

## PRE-CHECK
| API | Features/ esiste | Health VSA | Program thin | Azione |

## POST-CHECK
- dotnet clean && dotnet build
- Verifica /health su tutte le API
