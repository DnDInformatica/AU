# SIGAD - Istruzioni per Claude Code

Questa cartella contiene la configurazione per utilizzare **Claude Code** (CLI) per lo sviluppo del progetto **Accredia.SIGAD**.

## Prerequisiti

1. **Claude Code** installato:
   ```bash
   npm install -g @anthropic/claude-code
   ```

2. **API Key** configurata:
   ```bash
   export ANTHROPIC_API_KEY=your-api-key
   ```

3. **.NET 9 SDK** installato

4. **Workspace** pronto: `C:\Accredia\Sviluppo\AU`

## Struttura Files

```
sigad-claude-code/
├── CLAUDE.md                    # Istruzioni principali progetto
├── README.md                    # Questo file
├── .claude/
│   ├── settings.json           # Configurazione Claude Code
│   └── commands/               # Slash commands personalizzati
│       ├── sigad-bootstrap.md
│       ├── sigad-vsa.md
│       ├── sigad-database.md
│       ├── sigad-identity.md
│       ├── sigad-tipologiche.md
│       ├── sigad-anagrafiche.md
│       ├── sigad-gateway.md
│       ├── sigad-web.md
│       ├── sigad-observability.md
│       └── sigad-verify.md
└── scripts/
    ├── run_all.ps1             # Avvia tutti i servizi
    ├── stop_all.ps1            # Ferma tutti i servizi
    └── sanity_checks.ps1       # Verifiche automatiche
```

## Setup

1. **Copia i file nel workspace**:
   ```powershell
   Copy-Item -Recurse .\sigad-claude-code\* C:\Accredia\Sviluppo\AU\
   ```

2. **Verifica la struttura**:
   ```powershell
   cd C:\Accredia\Sviluppo\AU
   Get-ChildItem -Recurse .claude
   ```

## Utilizzo Claude Code

### Avvio

```bash
cd C:\Accredia\Sviluppo\AU
claude
```

### Comandi Disponibili (Slash Commands)

| Comando | Descrizione |
|---------|-------------|
| `/sigad-bootstrap` | Crea/verifica la solution base |
| `/sigad-vsa` | Applica Vertical Slice Architecture |
| `/sigad-database` | Configura DB + Dapper |
| `/sigad-identity` | Implementa Identity + JWT |
| `/sigad-tipologiche` | Implementa MVP Tipologiche |
| `/sigad-anagrafiche` | Implementa MVP Anagrafiche |
| `/sigad-gateway` | Configura Gateway YARP |
| `/sigad-web` | Implementa Web MudBlazor |
| `/sigad-observability` | Configura logging/tracing |
| `/sigad-verify` | Verifica stato completo |

### Esempio Sessione

```
> claude
Claude Code v1.x.x

> /sigad-bootstrap

[Claude esegue PRE-CHECK, crea progetti mancanti, POST-CHECK]

> /sigad-vsa

[Claude applica VSA alle API]

> Implementa endpoint POST /auth/login in Identity.Api

[Claude segue le regole del progetto automaticamente]
```

## Workflow Consigliato

### Nuovo Progetto
1. `/sigad-bootstrap` - Setup solution
2. `/sigad-vsa` - Struttura VSA
3. `/sigad-database` - Data access
4. `/sigad-identity` - Autenticazione
5. `/sigad-tipologiche` - Primo dominio
6. `/sigad-anagrafiche` - Secondo dominio
7. `/sigad-gateway` - Routing
8. `/sigad-web` - Frontend
9. `/sigad-observability` - Logging

### Verifica Stato
```
/sigad-verify
```

### Sviluppo Continuo
Usa prompt naturali, Claude Code seguirà automaticamente le regole in CLAUDE.md:

```
> Aggiungi endpoint GET /v1/tipologiche/{id}/dettaglio

> Correggi errore build in Identity.Api

> Aggiungi validazione FluentValidation al LoginCommand
```

## Scripts PowerShell

### Avvia tutti i servizi
```powershell
.\scripts\run_all.ps1 -Build
```

### Ferma tutti i servizi
```powershell
.\scripts\stop_all.ps1
```

### Verifiche automatiche
```powershell
.\scripts\sanity_checks.ps1
```

## Regole Automatiche

Claude Code segue automaticamente queste regole (definite in CLAUDE.md):

- **PRE-CHECK** prima di ogni modifica
- **POST-CHECK** dopo ogni modifica
- **Idempotenza**: non duplica, verifica e corregge
- **Dapper obbligatorio** per accesso dati
- **MudBlazor obbligatorio** per UI
- **Porte fisse** non modificabili
- **Solo HTTP** in ambiente DEV

## Troubleshooting

### Claude non trova il workspace
```bash
cd C:\Accredia\Sviluppo\AU
claude --cwd .
```

### Comandi personalizzati non caricati
Verifica che `.claude/commands/` contenga i file `.md`

### Build fallisce
```powershell
dotnet restore
dotnet build --verbosity detailed
```

### Servizi non raggiungibili
```powershell
.\scripts\stop_all.ps1
.\scripts\run_all.ps1 -Build -Verbose
```

## Note

- I file in `.claude/commands/` sono slash commands personalizzati
- `CLAUDE.md` contiene le istruzioni sempre attive
- Gli scripts in `scripts/` sono utility PowerShell standalone
- Claude Code legge automaticamente `CLAUDE.md` dalla root del workspace
