# Tipologiche MVP

Implementa Tipologiche.Api (schema `Tipologiche`) con VSA + Dapper.

## DATA MODEL
```sql
CREATE TABLE Tipologiche.TipoVoceTipologica (
    Id UNIQUEIDENTIFIER PRIMARY KEY,
    Code NVARCHAR(50) NOT NULL,
    Description NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    Ordine INT DEFAULT 0
);
```

## ENDPOINTS VSA
| Endpoint | Metodo | Descrizione |
|----------|--------|-------------|
| /v1/tipologiche | GET | Lista con paging + filtro q |
| /v1/tipologiche/{id} | GET | Dettaglio singolo |
| /v1/tipologiche | POST | Crea (DEV-only) |
| /v1/tipologiche/{id} | PUT | Aggiorna (DEV-only) |

## FEATURES VSA
```
Features/
├── Database/
│   └── EnsureTables/
└── Tipologiche/
    ├── List/
    ├── GetById/
    ├── Create/
    └── Update/
```

## PAGING PATTERN
```csharp
// Query params
int page = 1;
int pageSize = 20;
string? q = null; // filtro opzionale

// Response
{
    "items": [...],
    "totalCount": 100,
    "page": 1,
    "pageSize": 20
}
```

## REGOLE
- Dapper obbligatorio
- Swagger DEV-only
- Endpoint POST/PUT solo in Development

## POST-CHECK
- dotnet build
- Avvio su porta 7002
- Test CRUD endpoints
