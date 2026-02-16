# Verifica Completa SIGAD

Esegue una verifica completa dello stato della solution.

## OPERAZIONE READ-ONLY
- NON modificare file
- Solo analisi e report

## CHECKLIST

### 1. Solution Structure
```powershell
cd C:\Accredia\Sviluppo\AU
Test-Path Accredia.SIGAD.sln
```

| Progetto | Esiste | In SLN | TargetFramework |
|----------|--------|--------|-----------------|
| Web | | | |
| Gateway | | | |
| Identity.Api | | | |
| Tipologiche.Api | | | |
| Anagrafiche.Api | | | |
| Shared | | | |

### 2. Build Status
```powershell
dotnet build --no-restore
```

### 3. Port Configuration
Verifica launchSettings.json per ogni progetto:
| Servizio | Porta Attesa | Porta Configurata | Status |
|----------|--------------|-------------------|--------|
| Web | 7000 | | |
| Gateway | 7100 | | |
| Identity | 7001 | | |
| Tipologiche | 7002 | | |
| Anagrafiche | 7003 | | |

### 4. Health Endpoints
```powershell
# Se i servizi sono in esecuzione
Invoke-WebRequest http://localhost:7001/health -UseBasicParsing
Invoke-WebRequest http://localhost:7002/health -UseBasicParsing
Invoke-WebRequest http://localhost:7003/health -UseBasicParsing
Invoke-WebRequest http://localhost:7100/health -UseBasicParsing
```

### 5. Configuration Files
Per ogni servizio verificare:
- [ ] appsettings.json presente
- [ ] appsettings.Development.json presente
- [ ] ConnectionStrings configurata
- [ ] Database:Schema configurato

### 6. VSA Structure
Per ogni API:
- [ ] Features/ directory esiste
- [ ] Features/Health/ presente
- [ ] Program.cs "thin"

### 7. Packages
- [ ] Dapper installato
- [ ] EF Core NON registrato a runtime
- [ ] MudBlazor in Web

### 8. YARP Gateway
- [ ] Yarp.ReverseProxy installato
- [ ] Routes configurate
- [ ] Clusters configurati

## OUTPUT
Produci report con:
- Status: OK / WARNING / ERROR
- Lista problemi trovati
- Azioni correttive suggerite
