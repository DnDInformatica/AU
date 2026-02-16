---
name: sigad:validate
description: Esegue validazione completa del progetto contro le regole SIGAD
args:
  - name: scope
    description: "Scope validazione (all, service-name, file-path)"
    required: false
    default: "all"
---

# Validazione SIGAD

Esegue validazione completa del progetto contro tutte le regole SIGAD.

## Scope

- `all` - Valida tutto il workspace
- `identity` / `tipologiche` / `anagrafiche` - Solo servizio specifico
- `path/to/file.cs` - Solo file specifico

## Processo

### 1. Delega a sigad-validator
Invoca il subagent `sigad-validator` per analisi completa.

### 2. Categorie Verificate

#### Data Access (Peso: 30%)
- [ ] Dapper usato per tutti gli accessi DB
- [ ] Nessun DbContext/EF Core a runtime
- [ ] IDbConnectionFactory iniettato
- [ ] using per tutte le connessioni

#### Architettura (Peso: 25%)
- [ ] Struttura VSA (Features/<Domain>/<Action>/)
- [ ] Nessun controller MVC
- [ ] Program.cs "thin"
- [ ] Shared solo cross-cutting

#### Database (Peso: 20%)
- [ ] Schema specificato in tutte le query
- [ ] Nessun oggetto in dbo
- [ ] ConnectionStrings separate per servizio

#### Configurazione (Peso: 15%)
- [ ] Porte corrette
- [ ] Un solo profilo DEV
- [ ] Solo HTTP (no HTTPS)
- [ ] launchSettings.json conforme

#### Web/Gateway (Peso: 10%)
- [ ] Web chiama solo Gateway
- [ ] YARP configurato
- [ ] MudBlazor in Web

## Output

```
╔════════════════════════════════════════════════════════╗
║           SIGAD VALIDATION REPORT                      ║
║           2025-02-05 10:30:00                          ║
╠════════════════════════════════════════════════════════╣
║  SCORE: 85/100                                         ║
╠════════════════════════════════════════════════════════╣

📊 CATEGORIE

Data Access      ████████░░  27/30  (3 warning)
Architettura     █████████░  23/25  (2 warning)
Database         ██████████  20/20  ✓
Configurazione   ██████████  15/15  ✓
Web/Gateway      ██████████  10/10  ✓

╠════════════════════════════════════════════════════════╣

🔴 VIOLAZIONI CRITICHE (0)
Nessuna

🟡 WARNING (5)

1. [DATA] Identity.Api/Features/Users/List/ListHandler.cs:34
   Query senza paginazione esplicita
   Fix: Aggiungere OFFSET/FETCH

2. [ARCH] Tipologiche.Api/Features/Voci/GetById/GetByIdHandler.cs:12
   Manca logging
   Fix: Aggiungere ILogger

3. [DATA] Anagrafiche.Api/Features/Org/Create/CreateHandler.cs:45
   Manca CancellationToken
   Fix: Aggiungere ct parameter

4. [DATA] Identity.Api/Features/Auth/Login/LoginHandler.cs:28
   Query timeout non specificato
   Fix: Aggiungere commandTimeout

5. [ARCH] Tipologiche.Api/Program.cs:15
   Handler non registrati come Scoped
   Fix: Cambiare AddSingleton → AddScoped

╠════════════════════════════════════════════════════════╣

✅ BEST PRACTICES RISPETTATE

- Schema ownership corretto
- Porte fisse configurate
- VSA structure presente
- MudBlazor configurato
- YARP routing OK

╠════════════════════════════════════════════════════════╣

📋 AZIONI SUGGERITE

1. Risolvere i 5 warning per score 100/100
2. Considerare aggiunta test unitari
3. Aggiungere XML documentation

╚════════════════════════════════════════════════════════╝
```

## Integrazione CI/CD

Può essere usato in pipeline:
```yaml
- name: SIGAD Validation
  run: claude /sigad:validate all --fail-on-warning
```
