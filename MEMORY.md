# SIGAD — Memory Persistente

> Questo file traccia decisioni, errori risolti e stato avanzamento.
> **Claude Code DEVE consultarlo all'inizio di ogni sessione.**
> **Claude Code DEVE aggiornarlo quando prende decisioni o risolve errori.**

---

## STATO AVANZAMENTO

### Prompt Completati
| # | Prompt | Stato | Data | Note |
|---|--------|-------|------|------|
| 0 | Bootstrap Solution | Completato | 2025-02-05 | Build OK, tutti i progetti conformi |
| 1 | VSA Microservizi | Completato | 2025-02-05 | Program.cs thin, auto-discovery endpoint |
| 2 | Database ConnectionString | Completato | 2025-02-05 | Dapper, Schema ownership, EnsureSchema endpoint |
| 3 | Config Resilienza | Completato | 2025-02-05 | Serilog + CorrelationId + /health/db |
| 4 | Identity JWT | Completato | 2025-02-05 | VSA Dapper, JWT Bearer, Swagger DEV |
| 5 | Versioning API | Completato | 2025-02-05 | Asp.Versioning.Http, Swagger versionato |
| 6 | Osservabilita | Pending | - | - |
| 7 | Dapper DB Schema | Pending | - | - |
| 8 | Identity JWT Dapper | Pending | - | - |
| 9 | Tipologiche MVP | Pending | - | - |
| 10 | Anagrafiche MVP | Pending | - | - |
| 11 | Gateway Policies | Pending | - | - |
| 12 | Web MudBlazor Login | Pending | - | - |
| 13 | Observability E2E | In Progress | 2026-02-05 | Avviati test E2E Playwright per Web |
| 14 | DX Scripts | Pending | - | - |
| 15 | Global Search UX | In Progress | 2026-02-05 | Endpoint search in Anagrafiche + aggregazione Gateway |

### Stato Attuale Progetti
| Progetto | Esiste | Compila | Health OK | Note |
|----------|--------|---------|-----------|------|
| Accredia.SIGAD.sln | SI | ✅ | - | 13 `.csproj` in solution/repo (API, test, BFF, E2E) |
| Identity.Api | SI | ✅ | - | net9.0, Dapper, porta 7001 |
| Tipologiche.Api | SI | ✅ | - | net9.0, Dapper, porta 7002 |
| Anagrafiche.Api | SI | ✅ | - | net9.0, Dapper, porta 7003 |
| RisorseUmane.Api | SI | ✅ | - | net9.0, Dapper, copertura schema 6/6 confermata |
| RisorseUmane.Bff.Api | SI | - | - | progetto presente |
| Gateway | SI | ✅ | - | net9.0, YARP, porta 7100 |
| Web | SI | ✅ | - | net9.0, MudBlazor, porta 7000 |
| Web.E2E | SI | - | - | progetto Playwright presente |
| Shared | SI | ✅ | - | net9.0, classlib |

### Allineamento Workplan (snapshot 2026-02-16)
- `WORKPLAN_ORGANIZZAZIONI_COVERAGE.md`: chiuso, copertura finale `34/34`, `ORG-903` `DONE`.
- `WORKPLAN_PERSONE_COVERAGE.md`: chiuso, copertura finale `26/26`, `PER-903` `DONE`.
- `WORKPLAN_RISORSEUMANE_COVERAGE.md`: copertura schema `6/6` (`RU-901` `DONE`), `RU-902` chiuso lato sviluppo (suite HTTP integrazione pronta); rischio residuo classificato `INFRA` per disponibilita stack esterno in sessione test.
- `WORKPLAN_TIPOLOGICHE_COVERAGE.md`: lookup/mapping operativi, decisione `*Storico` formalizzata (non esposte), test integrazione presenti.
- `WORKPLAN_UX_REDESIGN.md`: milestone `M0-M6` completate (inclusi UO/Incarichi CRUD, contatti persona e storico minimo).

---

## DECISIONI ARCHITETTURALI

### Decisione 1: Data Access Pattern
- **Data:** 2025-02-05
- **Decisione:** Dapper obbligatorio, EF vietato a runtime
- **Motivo:** Performance, controllo query, allineamento governance ACCREDIA
- **Impatto:** Tutti i servizi API

### Decisione 2: Schema Ownership
- **Data:** 2025-02-05
- **Decisione:** Ogni servizio possiede uno schema SQL Server dedicato
- **Schema:** Identity→[Identity], Tipologiche→[Tipologiche], Anagrafiche→[Anagrafiche]
- **Motivo:** Isolamento dati, governance, evitare conflitti
- **Impatto:** VIETATO creare oggetti in [dbo]

### Decisione 3: Logging Strutturato
- **Data:** 2025-02-05
- **Decisione:** Serilog con CorrelationId e TraceId obbligatori
- **Implementazione:** Shared/Middleware/SerilogExtensions.cs + CorrelationIdMiddleware.cs
- **Motivo:** Tracciabilità richieste E2E, debugging distribuito
- **Impatto:** Tutte le API usano UseSigadSerilog() e UseSigadRequestLogging()

### Decisione 4: JWT Authentication
- **Data:** 2025-02-05
- **Decisione:** JWT Bearer token con PasswordHasher<> per hash password
- **Config:** appsettings.json sezione "Jwt" (Issuer, Audience, Key, AccessTokenMinutes)
- **Motivo:** Stateless auth, standard industry
- **Impatto:** Identity.Api emette token, altri servizi li validano

### Decisione 5: API Versioning
- **Data:** 2025-02-05
- **Decisione:** Asp.Versioning.Http con URL segment versioning (/v1/...)
- **Package:** Asp.Versioning.Http 8.1.0, Asp.Versioning.Mvc.ApiExplorer 8.1.0
- **Config:** AddSigadApiVersioning() in Shared, Swagger versionato
- **Motivo:** Standard .NET, supporto deprecation, header versioning opzionale
- **Impatto:** Tutti gli endpoint API versioned (/v1/...), Swagger multi-versione

### Decisione 6: Global Search Aggregata
- **Data:** 2026-02-05
- **Decisione:** Endpoint `/search/global` nel Gateway con chiamate ai search di Anagrafiche
- **Motivo:** Ricerca unificata e UX coerente su Organizzazioni, Persone, Incarichi
- **Impatto:** Nuovi endpoint search in Anagrafiche, nuova UI Global Search

### Decisione 7: Test E2E Web
- **Data:** 2026-02-05
- **Decisione:** Playwright (NUnit) per test end-to-end del Web
- **Motivo:** Copertura UX e navigazione reale
- **Impatto:** Nuovo progetto `Accredia.SIGAD.Web.E2E`

---

## ERRORI RISOLTI

### Errore 1: File Locking durante Build
- **Data:** 2025-02-05
- **Errore:** MSB3027 - non è stato possibile copiare Accredia.SIGAD.Shared.dll
- **Causa:** Processo API in esecuzione blocca i file DLL
- **Soluzione:** Terminare il processo (es. `taskkill /F /PID <pid>`) prima del build
- **Prevenzione:** Usare `dotnet watch` o terminare le API prima di rebuild 

### Errore 2: Login Web non funzionante (assenza utente admin)
- **Data:** 2026-02-07
- **Errore:** Login fallisce perché manca un utente nel DB Identity
- **Causa:** Seed EF non eseguito; nessun utente admin creato
- **Soluzione:** Seed DEV via Dapper all'avvio di Identity.Api (utente admin + ruolo SIGAD_SUPERADMIN)
- **Note:** Usa `DevSeedOptions` e password di default in DEV se non configurata

### Errore 3: Messaggio login non chiaro su utente assente
- **Data:** 2026-02-07
- **Errore:** UI mostra "Login fallito" senza indicare utente non presente
- **Causa:** Login 401 restituisce body vuoto, messaggio generico
- **Soluzione:** Messaggio specifico lato Web per 401: "Utente non presente o password errata."

---

## PATTERN APPROVATI

### Dapper Repository
```csharp
public class UserRepository : IUserRepository
{
    private readonly IDbConnectionFactory _connectionFactory;
    
    public async Task<User?> GetByIdAsync(Guid id)
    {
        using var connection = _connectionFactory.CreateConnection();
        return await connection.QuerySingleOrDefaultAsync<User>(
            "SELECT * FROM Identity.Users WHERE UserId = @Id",
            new { Id = id });
    }
}
```

### VSA Endpoint
```csharp
public static class GetUserEndpoint
{
    public static void Map(WebApplication app)
    {
        app.MapGet("/api/v1/users/{id:guid}", Handle)
           .WithName("GetUserById");
    }
    
    private static async Task<IResult> Handle(Guid id, IUserRepository repo)
    {
        var user = await repo.GetByIdAsync(id);
        return user is null ? Results.NotFound() : Results.Ok(user);
    }
}
```

---

## PROSSIMI TASK

1. [x] Chiusura `RU-902` lato sviluppo (test suite pronta, esecuzione reale dipendente da stack/infra disponibile).
2. [x] Decisione architetturale su `Tipologica.*Storico`: confermata non esposizione API.
3. [x] Test integrazione `Tipologiche.Api` aggiunti.
4. [x] Chiusura fase `M6` UX/CRUD (UO, Incarichi, Contatti Persona, Storico eventi minimo).
5. [ ] M7 Documenti Nextcloud (upload/list/download/delete soft + ACL).
6. [ ] M8 hardening pronto esercizio (segreti/config PROD, observability, performance/HA).

---

## NOTE SESSIONE

### Sessione attuale
**Obiettivo:** allineare la memoria persistente allo stato reale dei workplan.
**Completato:** chiusura workplan aperti (RU-902 incluso lato sviluppo), formalizzazione decisione Tipologiche `*Storico`, chiusura milestone UX M6.
**Bloccanti residui:** esecuzione E2E HTTP dipendente da stack locale completo disponibile durante la sessione (Gateway/API/SQL).

---

**Ultimo aggiornamento:** 2026-02-16 (chiusura punti aperti + riallineamento workplan)
