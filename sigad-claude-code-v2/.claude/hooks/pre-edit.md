---
name: pre-edit
description: Hook eseguito automaticamente prima di ogni modifica file
---

# Pre-Edit Hook

Questo hook viene eseguito automaticamente PRIMA di ogni modifica a file .cs, .csproj, .json nel progetto SIGAD.

## Validazioni Automatiche

### 1. File .cs - Verifica Pattern Vietati

Prima di modificare un file .cs, verifica che la modifica NON introduca:

```
❌ DbContext, AddDbContext, SaveChanges
❌ new SqlConnection() senza factory
❌ [ApiController], ControllerBase
❌ Query SQL senza schema (Identity./Tipologiche./Anagrafiche.)
❌ Chiamate dirette a localhost:7001/7002/7003 da Web
```

Se la modifica proposta contiene pattern vietati → **BLOCCA** e suggerisci alternativa conforme.

### 2. File .csproj - Verifica Package

Prima di aggiungere PackageReference:

```
❌ Microsoft.EntityFrameworkCore (tranne *.Design, *.Tools)
❌ Microsoft.AspNetCore.Mvc.Core (per API)
✅ Dapper
✅ FluentValidation
✅ Serilog.*
```

### 3. File appsettings.json - Verifica ConnectionStrings

```
✅ ConnectionStrings:<Service>Db presente
✅ Database:Schema configurato
❌ ConnectionStrings:DefaultConnection (vietato)
```

### 4. File launchSettings.json - Verifica Porte

```
Web: 7000
Gateway: 7100
Identity: 7001
Tipologiche: 7002
Anagrafiche: 7003

❌ HTTPS
❌ Profili multipli (solo http-dev)
```

## Output

Se validazione passa:
```
✅ Pre-check passed - Proceeding with edit
```

Se validazione fallisce:
```
🛑 Pre-check FAILED

Violazione: [descrizione]
File: [path]
Pattern vietato: [cosa è stato trovato]

Alternativa conforme:
[suggerimento]

Modifica bloccata. Correggi e riprova.
```

## Bypass (solo se esplicitamente richiesto)

Se l'utente dice esplicitamente "ignora pre-check" o "bypass validation", procedi con warning:

```
⚠️ Pre-check bypassed su richiesta utente
Violazione ignorata: [dettaglio]
ATTENZIONE: Potrebbe causare non-conformità
```
