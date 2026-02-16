# SIGAD - Claude Code Configuration v2.0

Configurazione avanzata per **Claude Code** con il progetto **Accredia.SIGAD**.

## 🚀 Novità v2.0

| Feature | Descrizione |
|---------|-------------|
| **Subagent** | 4 agenti specializzati (validator, dapper, vsa, debugger) |
| **Hooks** | Pre/post validation automatica |
| **Memory** | Persistenza contesto tra sessioni |
| **MCP** | Integrazione SQL Server diretta |
| **Auto-recovery** | Correzione automatica errori build |
| **Pattern Enforcement** | Blocco automatico violazioni regole |

## 📦 Struttura

```
sigad-claude-code-v2/
├── CLAUDE.md                      # Regole progetto (OBBLIGATORIO)
├── README.md                      # Questo file
├── .claude/
│   ├── settings.json             # Configurazione avanzata
│   ├── agents/                   # Subagent specializzati
│   │   ├── sigad-validator.md    # Valida conformità
│   │   ├── sigad-dapper.md       # Genera query Dapper
│   │   ├── sigad-vsa.md          # Genera feature VSA
│   │   └── sigad-debugger.md     # Debug errori
│   ├── commands/                 # Slash commands
│   │   ├── sigad-bootstrap.md
│   │   ├── sigad-feature.md
│   │   ├── sigad-db.md
│   │   └── sigad-validate.md
│   ├── hooks/                    # Pre/post hooks
│   │   ├── pre-edit.md
│   │   └── post-edit.md
│   └── memory/                   # Persistenza
│       └── sigad-context.md
├── mcp-config/
│   └── mcp.json                  # Config MCP SQL Server
└── scripts/
    ├── run_all.ps1
    ├── stop_all.ps1
    └── sanity_checks.ps1
```

## 🔧 Installazione

### 1. Prerequisiti
```powershell
# Claude Code CLI
npm install -g @anthropic/claude-code

# .NET 9 SDK
winget install Microsoft.DotNet.SDK.9

# Node.js (per MCP)
winget install OpenJS.NodeJS
```

### 2. Setup
```powershell
# Estrai nel workspace
Expand-Archive sigad-claude-code-v2.zip -DestinationPath C:\Accredia\Sviluppo\AU

# Oppure copia manualmente
Copy-Item -Recurse sigad-claude-code-v2\* C:\Accredia\Sviluppo\AU\
```

### 3. Configura MCP (opzionale ma consigliato)
```powershell
# Modifica connection string in mcp-config/mcp.json
notepad C:\Accredia\Sviluppo\AU\mcp-config\mcp.json
```

### 4. Avvia Claude Code
```powershell
cd C:\Accredia\Sviluppo\AU
claude
```

## 📋 Comandi Disponibili

### Core Commands
| Comando | Descrizione |
|---------|-------------|
| `/sigad:bootstrap` | Setup/verifica solution |
| `/sigad:feature <svc> <domain> <action>` | Genera feature VSA |
| `/sigad:validate [scope]` | Valida conformità |
| `/sigad:db <action> [target]` | Operazioni database |

### Esempi
```
# Bootstrap solution
/sigad:bootstrap

# Genera CRUD per Users in Identity
/sigad:feature identity users crud

# Genera solo List per Organizzazioni
/sigad:feature anagrafiche organizzazioni list

# Valida tutto
/sigad:validate

# Valida solo Identity
/sigad:validate identity

# Query database
/sigad:db query "SELECT * FROM Identity.Users"

# Schema tabella
/sigad:db schema Identity.Users
```

## 🤖 Subagent

Claude Code invoca automaticamente i subagent quando appropriato.

### sigad-validator
**Quando:** Verifica conformità codice
```
> Verifica che il codice sia conforme alle regole SIGAD
[Invoca sigad-validator]
```

### sigad-dapper
**Quando:** Genera query o handler con accesso DB
```
> Genera query per ottenere utenti con ruoli
[Invoca sigad-dapper]
```

### sigad-vsa
**Quando:** Crea nuove feature
```
> Crea endpoint per creare organizzazioni
[Invoca sigad-vsa]
```

### sigad-debugger
**Quando:** Errori di build o runtime
```
> L'endpoint /auth/login restituisce 500
[Invoca sigad-debugger]
```

## 🔄 Hooks Automatici

### Pre-Edit Hook
Prima di ogni modifica, verifica:
- Pattern vietati (EF Core, Controller, etc.)
- Schema DB specificato
- Porte corrette

### Post-Edit Hook
Dopo ogni modifica:
- Build automatico
- Recovery se errore (max 3 tentativi)
- Aggiornamento metriche

## 🧠 Memory Persistente

Il file `.claude/memory/sigad-context.md` mantiene:
- Stato avanzamento prompt
- Decisioni architetturali
- Errori risolti
- Pattern validati

**Auto-aggiornato** da Claude Code tra sessioni.

## 📊 MCP Database Integration

### Configura Connection String
```json
// mcp-config/mcp.json
{
  "mcpServers": {
    "sigad-db": {
      "env": {
        "MSSQL_CONNECTION_STRING": "Server=TUO_SERVER;Database=SIGAD;..."
      }
    }
  }
}
```

### Usa via Claude Code
```
> Mostrami la struttura della tabella Identity.Users
> Quanti utenti attivi ci sono?
> Crea query per lista organizzazioni con paging
```

## ⚠️ Regole Enforce

Claude Code **blocca automaticamente**:
- ❌ `DbContext`, `AddDbContext`, `SaveChanges`
- ❌ `[ApiController]`, `ControllerBase`
- ❌ Query senza schema
- ❌ Chiamate dirette da Web a API (bypass Gateway)
- ❌ Porte non standard
- ❌ HTTPS in DEV

## 🔍 Troubleshooting

### Claude non segue le regole
1. Verifica che `CLAUDE.md` sia nella root del workspace
2. Esegui `/sigad:validate` per report dettagliato
3. Usa esplicitamente: "Segui le regole in CLAUDE.md"

### Subagent non invocato
Invoca esplicitamente:
```
> Usa il subagent sigad-dapper per generare questa query
```

### Build fallisce ripetutamente
```powershell
# Reset completo
dotnet clean
dotnet restore
dotnet build --verbosity detailed
```

### MCP non connette
1. Verifica connection string
2. Verifica SQL Server accessibile
3. Verifica Node.js installato

## 📈 Best Practices

1. **Usa sempre i comandi** invece di prompt generici
2. **Lascia lavorare gli hook** - non bypassare le validazioni
3. **Controlla la memory** periodicamente per contesto
4. **Valida spesso** con `/sigad:validate`
5. **Affidati ai subagent** per task specializzati

## 🆘 Supporto

Se Claude Code non si comporta come atteso:
1. Cita esplicitamente CLAUDE.md
2. Mostra l'output di `/sigad:validate`
3. Chiedi di usare un subagent specifico
4. Verifica la memory per contesto mancante

---

**Versione:** 2.0  
**Compatibile con:** Claude Code 1.x, .NET 9, SQL Server 2019+
