# PROMPT 7 — Data Access Foundation (Dapper hard) + DB unico a schema
Reasoning Level: MEDIUM

## Obiettivo
Impostare in **Identity.Api**, **Tipologiche.Api**, **Anagrafiche.Api** una base comune per accesso dati con **Dapper** (runtime) e **EF Core SOLO migrations (design-time)**.
DB unico, con schema per servizio:
- Identity → schema `Identity`
- Tipologiche → schema `Tipologiche`
- Anagrafiche → schema `Anagrafiche`

## Regole HARD
- Runtime data access: SOLO Dapper.
- Vietato `AddDbContext` / utilizzo `DbContext` a runtime.
- EF consentito SOLO per migrations con `IDesignTimeDbContextFactory`.
- ConnectionStrings separate per servizio (anche se puntano allo stesso DB).

## PRE-CHECK
Produrre tabella (per i 3 servizi):
| Servizio | ConnString presente | Schema setting | Dapper pkg | EF runtime presente | Azione |

## Implementazione (IDEMPOTENTE)

### 1) Configurazioni per servizio
In ciascun servizio, assicurare:
- `appsettings.json` contiene:
  - `ConnectionStrings:<ServiceDb>` (IdentityDb / TipologicheDb / AnagraficheDb)
  - `Database:Schema` (Identity / Tipologiche / Anagrafiche)

Esempio (Identity):
```json
{
  "ConnectionStrings": { "IdentityDb": "Server=...;Database=AccrediaSIGAD;Trusted_Connection=True;TrustServerCertificate=True" },
  "Database": { "Schema": "Identity" }
}
```

### 2) Pacchetti (runtime)
In ciascun servizio aggiungere (se mancanti):
- `Dapper`
- `Microsoft.Data.SqlClient`

### 3) Connection Factory (runtime)
Creare in ciascun servizio (oppure Shared, se già previsto cross-cutting tecnico) una factory:
- `Data/DbConnectionFactory.cs`
- `Data/DbOptions.cs`

Requisiti:
- Legge la conn string dal config
- Restituisce `IDbConnection` per Dapper
- Non usa EF

### 4) Migrations (design-time only)
In ciascun servizio:
- creare `Migrations/<Service>MigrationDbContext.cs` (solo per migrations)
- creare `Migrations/<Service>MigrationDbContextFactory.cs` implementando `IDesignTimeDbContextFactory<>`
- includere package:
  - `Microsoft.EntityFrameworkCore.SqlServer`
  - `Microsoft.EntityFrameworkCore.Design` (PrivateAssets=all)
  - `Microsoft.EntityFrameworkCore.Tools` (PrivateAssets=all)

Regola: NON registrare quel DbContext in DI a runtime.

### 5) Schema bootstrap (DEV-only)
Aggiungere in ogni servizio una feature VSA:
`Features/Database/EnsureSchema`
- Endpoint: `POST /db/ensure-schema` (solo Development)
- Usa Dapper per:
  - creare schema se non esiste
  - creare tabella `__SchemaVersion` nello schema (se non esiste)

## POST-CHECK
- `dotnet clean` e `dotnet build` solution
- Avvio dei 3 servizi e verifica:
  - `GET /health` OK
  - `POST /db/ensure-schema` (solo DEV) OK
