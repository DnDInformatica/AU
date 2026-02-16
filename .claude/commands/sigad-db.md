# /sigad-db — Interazione Database via MCP

## OBIETTIVO
Usare il MCP Server `accredia` per operazioni database.

---

## TOOL DISPONIBILI

### 1. execute_sql
Esegue query SQL.
```
Input: { "query": "SELECT ...", "asCsv": false, "page": 0, "pageSize": 100 }
```

### 2. describe_table
Mostra struttura tabella.
```
Input: { "table": "Schema.Tabella" }
```

### 3. list_tables
Elenca tutte le tabelle.
```
Input: (nessuno)
```

### 4. db_schema_json
Schema completo in JSON.
```
Input: (nessuno)
```

### 5. validate_table_conformity
Valida CREATE TABLE contro regole governance.
```
Input: { "script": "CREATE TABLE ..." }
```

### 6. check_governance_rules
Mostra regole governance ACCREDIA.
```
Input: { "rule_id": 1 } oppure {} per tutte
```

---

## WORKFLOW: Prima di scrivere codice Dapper

### Step 1: Verifica schema tabella
```
Tool: describe_table
Input: { "table": "Identity.Users" }
```

### Step 2: Testa la query
```
Tool: execute_sql
Input: { "query": "SELECT TOP 5 * FROM Identity.Users" }
```

### Step 3: Solo dopo, scrivi codice C#
```csharp
public async Task<IEnumerable<User>> GetAllAsync()
{
    using var conn = _factory.CreateConnection();
    return await conn.QueryAsync<User>(
        "SELECT * FROM Identity.Users WHERE IsActive = 1");
}
```

---

## CASI D'USO COMUNI

### Esplorare il database
```
1. list_tables → vedi tutte le tabelle
2. describe_table per quelle rilevanti
3. execute_sql per vedere dati esempio
```

### Creare nuova tabella
```
1. check_governance_rules → verifica regole
2. Scrivi CREATE TABLE
3. validate_table_conformity → valida
4. execute_sql per creare (se conforme)
```

### Generare codice Dapper
```
1. describe_table → ottieni colonne e tipi
2. Mappa tipi SQL → C#
3. Genera classe Entity
4. Genera Repository con query
```

---

## MAPPING TIPI SQL → C#

| SQL Server | C# |
|------------|-----|
| uniqueidentifier | Guid |
| nvarchar(N) | string |
| varchar(N) | string |
| int | int |
| bigint | long |
| bit | bool |
| datetime2 | DateTime |
| decimal(p,s) | decimal |
| float | double |

---

## SCHEMA OWNERSHIP SIGAD

| Servizio | Schema | Tabelle |
|----------|--------|---------|
| Identity.Api | Identity | Users, Roles, UserRoles |
| Tipologiche.Api | Tipologiche | TipoVoceTipologica |
| Anagrafiche.Api | Anagrafiche | Organizzazione |

**REGOLA:** Mai creare oggetti in `dbo`

---

## CONNECTION STRINGS

```json
{
  "ConnectionStrings": {
    "IdentityDb": "Server=.;Database=SIGAD;Trusted_Connection=True;TrustServerCertificate=True",
    "TipologicheDb": "Server=.;Database=SIGAD;Trusted_Connection=True;TrustServerCertificate=True",
    "AnagraficheDb": "Server=.;Database=SIGAD;Trusted_Connection=True;TrustServerCertificate=True"
  }
}
```

Nota: Stesso DB, connection string separate per schema ownership.
