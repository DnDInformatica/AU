# PROMPT 0 - Bootstrap, Verifica e Ripristino Solution (con MudBlazor)
Reasoning Level: MEDIUM

## REGOLE OPERATIVE (MANDATORY)
- OS Windows. Workspace unico: C:\Accredia\Sviluppo\AU (NON scrivere fuori).
- Sei autorizzato a scrivere file ed eseguire comandi SOLO nel workspace.
- PRE-CHECK obbligatorio con tabella stato (prima di qualsiasi modifica).
- Idempotenza: se esiste, verifica e correggi; non duplicare.
- Non inventare output: se non verificabile, scrivi ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œnon verificatoÃƒÂ¢Ã¢â€šÂ¬Ã‚Â.
- Se un comando fallisce: applica automaticamente un fallback e riprova. Vietato chiedere ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œcome vuoi procedere?ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â.
- Vietato /weatherforecast o demo.
- Un solo profilo DEV HTTP per progetto, porte fisse.
- POST-CHECK obbligatorio: dotnet clean/build + health check.
- Frontend: MudBlazor OBBLIGATORIO.

## OBIETTIVO
Creare o completare una solution .NET 9 chiamata `Accredia.SIGAD` in:
C:\Accredia\Sviluppo\AU
Processo idempotente, ripetibile e resiliente a interruzioni.

## VINCOLI FILESYSTEM (NON NEGOZIABILI)
- Directory base: C:\Accredia\Sviluppo\AU
- Una directory per progetto direttamente sotto la base (vietati src/, apps/, services/):
  - Accredia.SIGAD.Web
  - Accredia.SIGAD.Gateway
  - Accredia.SIGAD.Identity.Api
  - Accredia.SIGAD.Tipologiche.Api
  - Accredia.SIGAD.Anagrafiche.Api
  - Accredia.SIGAD.Shared
- Solution file: C:\Accredia\Sviluppo\AU\Accredia.SIGAD.sln

## PRE-CHECK (OBBLIGATORIO)
Verifica e PRODUCI tabella:
- Esistenza solution, progetti, csproj
- Progetti presenti nella solution
- TargetFramework net9.0
- Assenza demo (/weatherforecast, WeatherForecast*.cs)
- Ogni API ha GET /health (200 { "status":"ok" })
- Un solo profilo HTTP DEV
- Porte corrette
- Gateway YARP configurato
- Web usa MudBlazor (package + AddMudServices + component providers)

Tabella richiesta:
| Progetto | Esiste | In SLN | Conforme | Azione |

## CREAZIONE/COMPLETAMENTO SOLUTION (IDEMPOTENTE)
1) Se la solution non esiste, creala:
- dotnet new sln -n Accredia.SIGAD

2) Crea i progetti mancanti (SOLO se mancanti). Regole HARD:
- Per Blazor Server NON usare template non disponibili.
  - Prima scelta: `dotnet new blazor -n Accredia.SIGAD.Web --interactivity Server`
  - Se fallisce: elenca i template disponibili (`dotnet new list blazor`) e scegli automaticamente il template equivalente Server.
- Per le API preferisci minimal:
  - Prima scelta: `dotnet new webapi -n <nome> --use-minimal-apis`
  - Se lÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢opzione non esiste, crea webapi e poi rimuovi WeatherForecast + endpoint demo.
- Gateway: `dotnet new web -n Accredia.SIGAD.Gateway`
- Shared: `dotnet new classlib -n Accredia.SIGAD.Shared`

3) Aggiungi/assicura tutti i progetti nella solution (dotnet sln add) senza duplicare.

## CONFIGURAZIONE PROJECT REFERENCES (IMPORTANTE)
Dopo aver aggiunto tutti i progetti alla solution:

1) **Shared project** (`Accredia.SIGAD.Shared.csproj`):
   - Aggiungi FrameworkReference per ASP.NET Core:
   ```xml
   <ItemGroup>
     <FrameworkReference Include="Microsoft.AspNetCore.App" />
   </ItemGroup>
   ```
   Questo consente a Shared di esporre extension methods per IServiceCollection e WebApplication.

2) **API projects** (Identity, Tipologiche, Anagrafiche `*.csproj`):
   - Aggiungi ProjectReference verso Shared:
   ```xml
   <ItemGroup>
     <ProjectReference Include="..\Accredia.SIGAD.Shared\Accredia.SIGAD.Shared.csproj" />
   </ItemGroup>
   ```

Esempio Identity.Api.csproj:
```xml
<PropertyGroup>
  <TargetFramework>net9.0</TargetFramework>
  ...
</PropertyGroup>

<ItemGroup>
  <ProjectReference Include="..\Accredia.SIGAD.Shared\Accredia.SIGAD.Shared.csproj" />
</ItemGroup>

<ItemGroup>
  <PackageReference Include="..." />
  ...
</ItemGroup>
```

## VINCOLI COMUNI
- Vietato /weatherforecast o demo
- Ogni API espone SOLO:
  GET /health ÃƒÂ¢Â â„¢ 200 OK { "status": "ok" }
- Un solo profilo HTTP DEV (niente https)
- Porte fisse:
  - Web 7000
  - Gateway 7100
  - Identity 7001
  - Tipologiche 7002
  - Anagrafiche 7003

## CONFIGURAZIONE PORTE (IDEMPOTENTE)
Per ciascun progetto imposta Properties/launchSettings.json con UN SOLO profilo:
- nome profilo: "http-dev"
- applicationUrl: http://localhost:<porta>
- niente https, niente profili aggiuntivi

## API: PROGRAM MINIMO (SOLO HEALTH)
Per Identity/Tipologiche/Anagrafiche:
- Program.cs deve mappare solo:
  MapGet("/health", () => Results.Ok(new { status = "ok" }))
- Rimuovi:
  - WeatherForecast*.cs
  - MapGet("/weatherforecast") o simili
  - OpenAPI/Swagger se introdotti dal template (se presenti, rimuovili per mantenere baseline minimale)

## GATEWAY YARP
- Aggiungi pacchetto YARP (versione compatibile con net9):
  - dotnet add package Yarp.ReverseProxy
- Configura appsettings.json con:
  - /identity/{**catch-all} ÃƒÂ¢Â â„¢ http://localhost:7001/
  - /tipologiche/{**catch-all} ÃƒÂ¢Â â„¢ http://localhost:7002/
  - /anagrafiche/{**catch-all} ÃƒÂ¢Â â„¢ http://localhost:7003/
- Program.cs:
  - AddReverseProxy().LoadFromConfig(...)
  - Middleware che garantisce X-Correlation-Id (se assente lo genera) e lo riflette in response header
  - MapReverseProxy()

## WEB: MUD BLAZOR (OBBLIGATORIO)
Nel progetto `Accredia.SIGAD.Web`:
1) Installa MudBlazor:
   - dotnet add package MudBlazor
2) In Program.cs:
   - builder.Services.AddMudServices();
3) Aggiungi nel layout o App component:
   - MudThemeProvider
   - MudDialogProvider
   - MudSnackbarProvider
4) Usa una pagina iniziale minimale con un componente Mud (es. MudText/MudButton) per verificare che la libreria sia attiva.
Non introdurre demo superflue: solo skeleton UI.

## POST-CHECK (OBBLIGATORIO)
Esegui in C:\Accredia\Sviluppo\AU:
1) dotnet clean
2) dotnet build

Avvio (in terminali separati o sequenziale):
- dotnet run --project .\Accredia.SIGAD.Identity.Api
- dotnet run --project .\Accredia.SIGAD.Tipologiche.Api
- dotnet run --project .\Accredia.SIGAD.Anagrafiche.Api

Verifica health (PowerShell):
- Invoke-WebRequest http://localhost:7001/health
- Invoke-WebRequest http://localhost:7002/health
- Invoke-WebRequest http://localhost:7003/health

Se un check fallisce:
- correggi
- ripeti POST-CHECK
- non lasciare stato parziale

## OUTPUT ATTESO
- Tabella PRE-CHECK compilata
- Azioni effettuate (creazioni/correzioni)
- Esito POST-CHECK (OK/KO con causa)
