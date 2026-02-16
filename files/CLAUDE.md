# SIGAD — Istruzioni per Claude Code

## Informazioni Progetto
- **Nome**: Accredia.SIGAD
- **Tipo**: Solution .NET 9 con architettura Microservizi
- **Pattern**: Vertical Slice Architecture (VSA)
- **Framework UI**: MudBlazor (Blazor Server)
- **Data Access**: Dapper (OBBLIGATORIO)

## Ambiente di Esecuzione
- **OS**: Windows
- **Workspace**: `C:\Accredia\Sviluppo\AU`
- **Runtime**: .NET 9.0

## Struttura Solution

```
C:\Accredia\Sviluppo\AU\
├── Accredia.SIGAD.sln
├── Accredia.SIGAD.Web/           # Blazor Server + MudBlazor (porta 7000)
├── Accredia.SIGAD.Gateway/       # YARP Reverse Proxy (porta 7100)
├── Accredia.SIGAD.Identity.Api/  # Auth + JWT (porta 7001)
├── Accredia.SIGAD.Tipologiche.Api/  # Tipologiche CRUD (porta 7002)
├── Accredia.SIGAD.Anagrafiche.Api/  # Anagrafiche CRUD (porta 7003)
└── Accredia.SIGAD.Shared/        # Cross-cutting concerns
```

## Porte Fisse (NON MODIFICABILI)
| Servizio | Porta |
|----------|-------|
| Web | 7000 |
| Gateway | 7100 |
| Identity.Api | 7001 |
| Tipologiche.Api | 7002 |
| Anagrafiche.Api | 7003 |

## Regole HARD (NON NEGOZIABILI)

### Accesso Dati
- **Dapper OBBLIGATORIO** per l'accesso ai dati runtime
- **EF Core VIETATO** a runtime
- EF Core consentito SOLO per design-time/migrations

### Database
- DB centrale con schema ownership per servizio:
  - Identity → schema `Identity`
  - Tipologiche → schema `Tipologiche`
  - Anagrafiche → schema `Anagrafiche`
- VIETATO creare oggetti in `dbo`
- ConnectionStrings separate per servizio

### Architettura
- Microservizi: comunicazione SOLO via HTTP
- Web chiama SOLO Gateway (mai direttamente le API)
- Vertical Slice Architecture per tutte le API
- VIETATI controller MVC nelle API (solo Minimal API)

### Configurazione
- UN SOLO profilo DEV per progetto
- SOLO HTTP in DEV (niente HTTPS)
- Porte definite SOLO in launchSettings.json

### UI
- **MudBlazor OBBLIGATORIO** per il frontend
- VIETATO /weatherforecast o demo

## Struttura VSA (Vertical Slice Architecture)

```
Features/<FeatureName>/
├── Command.cs
├── Handler.cs
├── Validator.cs
├── Endpoints.cs
└── EndpointConfiguration.cs
```

## Comandi Utili

### Build & Test
```bash
cd C:\Accredia\Sviluppo\AU
dotnet clean
dotnet build
```

### Health Check
```powershell
Invoke-WebRequest http://localhost:7001/health  # Identity
Invoke-WebRequest http://localhost:7002/health  # Tipologiche
Invoke-WebRequest http://localhost:7003/health  # Anagrafiche
Invoke-WebRequest http://localhost:7100/health  # Gateway
```

### Run Services
```powershell
dotnet run --project .\Accredia.SIGAD.Identity.Api
dotnet run --project .\Accredia.SIGAD.Tipologiche.Api
dotnet run --project .\Accredia.SIGAD.Anagrafiche.Api
dotnet run --project .\Accredia.SIGAD.Gateway
dotnet run --project .\Accredia.SIGAD.Web
```

## Workflow Operativo

### PRE-CHECK (Obbligatorio prima di ogni modifica)
1. Verificare esistenza file/risorse
2. Produrre tabella di stato
3. Dichiarare azioni previste

### POST-CHECK (Obbligatorio dopo ogni modifica)
1. `dotnet clean`
2. `dotnet build`
3. Verifica `/health` endpoints
4. Se fallisce: correggere e ripetere

### Idempotenza
- Se non esiste → crea
- Se esiste → verifica e correggi
- MAI duplicare
- MAI lasciare stato parziale

## Note Importanti
- Non inventare file o output non verificabili
- Se manca un'informazione critica: STOP e chiedi
- Output conciso, tecnico, verificabile
- Nessuna spiegazione superflua
