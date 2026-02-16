---
name: sigad:db
description: Interagisce con il database SIGAD via MCP Server
args:
  - name: action
    description: "Azione (query, schema, tables, ensure)"
    required: true
  - name: target
    description: "Target dell'azione (SQL query o nome tabella)"
    required: false
---

# Database Operations

Esegue operazioni sul database SIGAD tramite MCP Server.

## Azioni Disponibili

### query - Esegue SQL
```
/sigad:db query "SELECT TOP 10 * FROM Identity.Users"
```

### schema - Mostra struttura tabella
```
/sigad:db schema Identity.Users
```

### tables - Lista tabelle per schema
```
/sigad:db tables Identity
/sigad:db tables Tipologiche
/sigad:db tables Anagrafiche
```

### ensure - Crea schema se non esiste
```
/sigad:db ensure Identity
```

## Regole

1. **Query devono specificare schema**
   ```sql
   ✅ SELECT * FROM Identity.Users
   ❌ SELECT * FROM Users
   ```

2. **Solo schema permessi**
   - Identity
   - Tipologiche
   - Anagrafiche
   - ❌ dbo vietato

3. **Operazioni distruttive richiedono conferma**
   - DELETE
   - DROP
   - TRUNCATE

## Output

### Query Result
```
📊 Query: SELECT TOP 5 * FROM Identity.Users

| UserId | UserName | Email | IsActive |
|--------|----------|-------|----------|
| ... | ... | ... | ... |

Rows: 5
Time: 23ms
```

### Schema Result
```
📋 Schema: Identity.Users

| Column | Type | Nullable | Default |
|--------|------|----------|---------|
| UserId | uniqueidentifier | NO | newid() |
| UserName | nvarchar(100) | NO | - |
| Email | nvarchar(256) | YES | - |
| PasswordHash | nvarchar(400) | NO | - |
| IsActive | bit | NO | 1 |
| CreatedUtc | datetime2 | NO | getutcdate() |

Indexes:
- PK_Users (UserId) CLUSTERED
- IX_Users_Email (Email) UNIQUE

Foreign Keys: None
```

## Integrazione con Sviluppo

Usa i risultati per:
1. **Generare entity** → `/sigad:feature` con proprietà corrette
2. **Validare query Dapper** → Confronta con schema reale
3. **Debug dati** → Verifica stato runtime
