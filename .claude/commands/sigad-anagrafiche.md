# Anagrafiche MVP

Implementa Anagrafiche.Api (schema `Anagrafiche`) con VSA + Dapper.

## DATA MODEL
```sql
CREATE TABLE Anagrafiche.Organizzazione (
    OrganizzazioneId UNIQUEIDENTIFIER PRIMARY KEY,
    Codice NVARCHAR(50) NOT NULL,
    Denominazione NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    CreatedUtc DATETIME2 DEFAULT GETUTCDATE()
);
```

## ENDPOINTS VSA
| Endpoint | Metodo | Descrizione |
|----------|--------|-------------|
| /v1/organizzazioni | GET | Lista con paging |
| /v1/organizzazioni/{id} | GET | Dettaglio singolo |
| /v1/organizzazioni | POST | Crea (DEV-only) |
| /v1/organizzazioni/{id} | PUT | Aggiorna (DEV-only) |

## FEATURES VSA
```
Features/
├── Database/
│   └── EnsureTables/
└── Organizzazioni/
    ├── List/
    ├── GetById/
    ├── Create/
    └── Update/
```

## REGOLE
- Dapper obbligatorio
- Swagger DEV-only
- Endpoint POST/PUT solo in Development

## POST-CHECK
- dotnet build
- Avvio su porta 7003
- Test CRUD endpoints
