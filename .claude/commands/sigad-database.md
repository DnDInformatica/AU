# Database Configuration - Dapper + Schema Ownership

Configura l'accesso al database con Dapper e schema ownership.

## OBIETTIVO
DB centrale con schema per servizio e connection string separate.

## SCHEMA OWNERSHIP
- Identity.Api → schema `Identity`
- Tipologiche.Api → schema `Tipologiche`
- Anagrafiche.Api → schema `Anagrafiche`

**VIETATO** creare oggetti in `dbo`.

## CONNECTION STRINGS
```json
// Identity.Api appsettings.json
{
  "ConnectionStrings": {
    "IdentityDb": "Server=...;Database=AccrediaSIGAD;..."
  },
  "Database": { "Schema": "Identity" }
}
```

## REGOLE HARD
- **Dapper OBBLIGATORIO** per accesso dati runtime
- **EF Core VIETATO** a runtime
- EF Core solo per design-time/migrations (se richiesto)

## IMPLEMENTAZIONE
1. Aggiungere pacchetti:
   - Dapper
   - Microsoft.Data.SqlClient

2. Creare DbConnectionFactory per ogni servizio:
```csharp
public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();
}
```

3. Creare `POST /db/ensure-schema` (DEV-only):
   - Crea schema se non esiste
   - Crea `__SchemaVersion` nello schema

## PRE-CHECK
| Servizio | ConnString | Schema | Dapper pkg | EF runtime | Azione |

## POST-CHECK
- dotnet build
- Verifica /health
- Test /db/ensure-schema (DEV)
