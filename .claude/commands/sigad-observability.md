# Observability - Serilog + Correlation Id

Uniforma logging e tracing su tutti i servizi.

## OBIETTIVO
- Serilog (console + file)
- CorrelationId enrichment
- Request logging middleware
- Predisposizione OpenTelemetry

## PACKAGES
```
Serilog.AspNetCore
Serilog.Sinks.Console
Serilog.Sinks.File
Serilog.Enrichers.Environment
Serilog.Enrichers.Thread
```

## CONFIGURAZIONE
```csharp
// Program.cs
builder.Host.UseSerilog((context, config) =>
{
    config
        .ReadFrom.Configuration(context.Configuration)
        .Enrich.FromLogContext()
        .Enrich.WithMachineName()
        .Enrich.WithThreadId()
        .WriteTo.Console(outputTemplate: 
            "[{Timestamp:HH:mm:ss} {Level:u3}] {CorrelationId} {Message:lj}{NewLine}{Exception}")
        .WriteTo.File("logs/sigad-.log", 
            rollingInterval: RollingInterval.Day);
});
```

## CORRELATION ID MIDDLEWARE
```csharp
app.Use(async (context, next) =>
{
    var correlationId = context.Request.Headers["X-Correlation-Id"].FirstOrDefault()
        ?? Guid.NewGuid().ToString();
    
    context.Response.Headers.Append("X-Correlation-Id", correlationId);
    
    using (LogContext.PushProperty("CorrelationId", correlationId))
    {
        await next();
    }
});
```

## APPSETTINGS
```json
{
  "Serilog": {
    "MinimumLevel": {
      "Default": "Information",
      "Override": {
        "Microsoft": "Warning",
        "System": "Warning"
      }
    }
  }
}
```

## SERVIZI DA CONFIGURARE
- Identity.Api
- Tipologiche.Api
- Anagrafiche.Api
- Gateway
- Web

## POST-CHECK
- dotnet build
- Avvia servizi
- Verifica log con CorrelationId presente
