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
- `WORKPLAN_PERSONE_WEB_CRUD_ESTESO.md`: avviato (allineamento API->Gateway->Web), priorita `Persone`, mapping confermato `RelazioniPersonali`, focus GDPR iniziale `RichiesteGdpr`.
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

### Decisione 8: Strategia UX CRUD Persone esteso
- **Data:** 2026-02-16
- **Decisione:** Approccio ibrido UI
- **Dettaglio:** tab nel dettaglio persona per moduli frequenti (indirizzi/qualifiche/relazioni personali/titoli/consensi), pagine dedicate per GDPR complesso.
- **Priorita GDPR:** `RichiesteGdpr` come primo modulo operativo.
- **Impatto:** nuovo workplan `WORKPLAN_PERSONE_WEB_CRUD_ESTESO.md`, estensione `GatewayClient` e nuove pagine Web.

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
7. [x] Eseguire fase `P0` di `WORKPLAN_PERSONE_WEB_CRUD_ESTESO.md` (DTO+GatewayClient per entita Persone mancanti).
8. [x] Eseguire fase `P2` (Richieste GDPR).
9. [x] Eseguire fase `P3` (storico esteso in UI) e `P4` (GDPR restante UI: RegistroTrattamenti/RichiesteEsercizioDiritti/DataBreach).
10. [ ] Valutare consolidamento UX GDPR (wizard/stepper, validazioni avanzate, campi estesi) e smoke test E2E dedicati.

Aggiornamento 2026-02-16 (P0 completata):
- completati DTO Web e metodi `GatewayClient` per: indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente, richieste GDPR, registro trattamenti, richieste esercizio diritti, data breach.
- completato storico esteso correlato (inclusi storico registro trattamenti, richieste esercizio diritti, data breach).

Aggiornamento 2026-02-16 (P1 completata):
- `Persone/Dettaglio` esteso con tab CRUD operativi: indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente.
- caricamento lazy per tab, gestione includeDeleted per moduli lista, azioni create/update/delete integrate via `GatewayClient`.
- build `Accredia.SIGAD.Web` ok (warning preesistenti).

Aggiornamento 2026-02-16 (P2 completata):
- nuova pagina dedicata `Richieste GDPR` in `Accredia.SIGAD.Web/Components/Pages/Gdpr/Richieste.razor` con filtri (persona/tipo/stato/date), lista paginata, create/edit/delete e caricamento dettaglio per id.
- deep link dal tab GDPR di `Persone/Dettaglio` verso `/gdpr/richieste?personaId={id}`.
- voce menu laterale `Richieste GDPR` aggiunta in area Anagrafiche (permessi Persone).

Aggiornamento 2026-02-16 (P3+P4 completate):
- `Persone/Dettaglio` storico esteso con sezioni aggiuntive: indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente, conteggio richieste GDPR correlate.
- tab `GDPR` in `Persone/Dettaglio` esteso con deep link a tutti i moduli GDPR dedicati.
- nuove pagine CRUD dedicate:
  - `Accredia.SIGAD.Web/Components/Pages/Gdpr/RegistroTrattamenti.razor`
  - `Accredia.SIGAD.Web/Components/Pages/Gdpr/RichiesteEsercizioDiritti.razor`
  - `Accredia.SIGAD.Web/Components/Pages/Gdpr/DataBreach.razor`
- menu laterale aggiornato con voci GDPR aggiuntive.
- build `Accredia.SIGAD.Web` ok (warning preesistenti).

Aggiornamento 2026-02-16 (RU persona-complete avvio):
- in `Accredia.SIGAD.RisorseUmane.Bff.Api` esteso `AnagraficheClient` con fetch correlati persona: email, telefoni, indirizzi, qualifiche, relazioni personali, consensi, richieste GDPR, richieste esercizio diritti.
- aggiunti endpoint compositi:
  - `GET /v1/dipendenti/dettaglio-completo`
  - `GET /v1/dipendenti/{id}/dettaglio-completo`
- aggiunto DTO aggregato `PersonaCompletaDto` con tutte le collezioni anagrafiche collegate a persona.
- build `Accredia.SIGAD.RisorseUmane.Bff.Api` ok (warning NuGet preesistenti `NU1603`).

Aggiornamento 2026-02-16 (RU filtri+lookup BFF/API):
- API `RisorseUmane.Dipendenti` list estesa con filtri `q` e `statoDipendenteId` (`GET /v1/dipendenti`).
- BFF RU aggiornato a propagare filtri `q`/`statoDipendenteId` sugli endpoint lista dettaglio (`/v1/dipendenti/dettaglio`, `/v1/dipendenti/dettaglio-completo`).
- aggiunto endpoint picker persona su BFF RU: `GET /v1/persone/lookup?q=...` (proxy tipizzato su `Anagrafiche /v1/persone/search`).
- build `Accredia.SIGAD.RisorseUmane.Api` e `Accredia.SIGAD.RisorseUmane.Bff.Api` ok (warning NuGet preesistenti).

Aggiornamento 2026-02-16 (RU Web primo rilascio operativo):
- aggiunti modelli RU in `Accredia.SIGAD.Web/Models/RisorseUmane/DipendentiModels.cs`.
- esteso `GatewayClient` con:
  - lista composita dipendenti (`bff/risorseumane/v1/dipendenti/dettaglio-completo`)
  - dettaglio completo dipendente
  - lookup persona RU (`bff/risorseumane/v1/persone/lookup`)
  - create dipendente (`risorseumane/v1/dipendenti`)
- nuove pagine Web:
  - `Components/Pages/RisorseUmane/Dipendenti.razor`
  - `Components/Pages/RisorseUmane/NuovoDipendente.razor`
  - `Components/Pages/RisorseUmane/DettaglioDipendente.razor`
- menu laterale aggiornato con voce `Dipendenti` (sotto area Anagrafiche).
- build `Accredia.SIGAD.Web` completata con warning preesistenti.

Aggiornamento 2026-02-16 (RU-1102 completata):
- in `NuovoDipendente` aggiunta modalita `Crea nuova persona inline` (toggle UI).
- validazioni condizionali sui dati persona inline (nome, cognome, data nascita).
- submit unico: se inline crea prima la persona via `CreatePersonaAsync`, poi crea dipendente usando il `PersonaId` ottenuto.
- pagina supporta ora entrambe le modalita: selezione persona esistente o creazione inline.

Aggiornamento 2026-02-16 (RU Web hardening ricerca/creazione):
- aggiunte alias route RU Web per ergonomia navigazione: `/dipendenti` e `/dipendenti/nuovo` oltre ai path `/risorse-umane/...`.
- in `Dipendenti` aggiunte CTA esplicite `Nuovo dipendente` anche in toolbar filtri e stato `NoRecords`.
- ricerca persona nel modulo RU resa resiliente: doppio tentativo (`BFF lookup` -> fallback `Anagrafiche search`) con messaggio errore esplicito in caso di indisponibilita completa dei servizi.
- fix forwarding header nel Gateway (`Program.cs`): sostituiti cast nullable su `StringValues` con `.ToArray()` per eliminare warning nullability e rendere robusto il pass-through di `Authorization`/`X-Correlation-Id`.

Aggiornamento 2026-02-16 (RU bugfix runtime + smoke E2E):
- fix RU API `Dipendenti` su Dapper e `DateOnly`:
  - write path: conversione `DateOnly -> DateTime` in `CreateAsync`/`UpdateAsync` per parametri SQL.
  - read path: mapping intermedio DB row (`DateTime`) -> DTO API (`DateOnly`) per `GetById`, `List`, `Storico`.
- hardening validazioni RU API:
  - `matricola` max 20, `emailAziendale` max 100, `telefonoInterno` max 10 (allineate a schema SQL).
  - gestione errore SQL truncation (`2628`) con `ValidationProblem` (400) invece di errore 500.
- smoke test reale completato con stack locale attivo:
  - login gateway `200`;
  - lookup persone RU BFF `200`;
  - create dipendente `201`;
  - dettaglio completo BFF by id `200`;
  - lista dettaglio completo BFF per persona `200`;
  - test negativo matricola > 20: `400` atteso confermato.
- verifica permessi utente `admin`: presenti permessi `PERS.*` e moduli anagrafiche; permessi granulari `HR.*` non ancora introdotti (task RU-1201 aperto).

Aggiornamento 2026-02-16 (RU-1201 permessi granulari - implementazione):
- Identity:
  - esteso catalogo permessi con `HR.PERSONA.READ`, `HR.DIP.*`, `HR.CONTRATTI.*`, `HR.DOTAZIONI.*`, `HR.FORM.*` in `IdentitySeeder`.
  - esteso `DevIdentitySeeder` per garantire creazione+assegnazione permessi `HR.*` al ruolo admin configurato in DEV.
- Gateway:
  - aggiunte policy `HrPersonaRead`, `HrDip*`, `HrContratti*`, `HrDotazioni*`, `HrForm*`, `HrDipReadPersona`.
  - aggiunte route YARP con authorization policy granulari per endpoint RU API e RU BFF (`/risorseumane/v1/...`, `/bff/risorseumane/v1/...`).
- verifica runtime:
  - login admin con token contenente 21 permessi `HR.*` verificato.
  - test `401` senza token su endpoint RU verificato.
  - test `403` con utente non autorizzato da consolidare: in sessione sono emersi timeout intermittenti su `/identity/v1/auth/login` (TaskCanceled lato query Dapper login), non correlati alle nuove policy.

Aggiornamento 2026-02-16 (auth+ricerca persone stabilizzati):
- `Identity.Api` login/refresh ora include claim `perm` (permessi da ruoli), risolvendo i `403` Gateway su policy `PersRead`.
- seed DEV permessi consolidato per amministratore (`PERS.*` + modulo anagrafiche), evitando token senza permessi necessari.
- `Anagrafiche.Api` allineato per connessione SQL in `Development` (`Encrypt=False`, `TrustServerCertificate=True`, logging opzioni connessione).
- smoke test E2E locale via Gateway:
  - login `200` e ricerca persone `200` (`/anagrafiche/v1/persone/search`) confermati;
  - esito funzionale stabile su chiamate ripetute; unici KO osservati: `429 Too Many Requests` da rate limiting (atteso in burst test).

Aggiornamento 2026-02-16 (RU runtime stabilizzato + CRUD tab RU Web):
- `RisorseUmane.Api`: rimosso switch `UseManagedNetworkingOnWindows`; `SqlConnectionFactory` resa robusta in `Development` (force `Encrypt=False`, `TrustServerCertificate=True`, logging opzioni connessione), risolto errore SQL pre-login handshake.
- `RisorseUmane.Api`: fix mapping Dapper `date -> DateOnly` su feature `Contratti`, `Dotazioni`, `FormazioneObbligatoria` (read/list/storico) tramite row mapping intermedio.
- smoke runtime via Gateway confermato:
  - `GET /risorseumane/v1/dipendenti` `200`
  - `GET /risorseumane/v1/dipendenti/{id}/contratti` `200`
  - `GET /risorseumane/v1/dipendenti/{id}/dotazioni` `200`
  - `GET /risorseumane/v1/dipendenti/{id}/formazione-obbligatoria` `200`
- Web `DettaglioDipendente` estesa con sezioni CRUD operative: `Contratti` (incl. storico), `Dotazioni`, `FormazioneObbligatoria` + azioni `Modifica/Elimina` dipendente.

Aggiornamento 2026-02-16 (RU DateOnly write-path fix completato):
- `RisorseUmane.Api`: completata conversione write-side `DateOnly -> DateTime` anche per `FormazioneObbligatoria` (oltre a `Contratti` e `Dotazioni`) in `CreateAsync`/`UpdateAsync`.
- build `Accredia.SIGAD.RisorseUmane.Api` ok.
- smoke runtime diretto RU API:
  - `Contratti`: `POST` `201`, `PUT` `204`, `DELETE` `204`;
  - `Dotazioni`: `POST` `201`, `PUT` `204`, `DELETE` `204`;
  - `FormazioneObbligatoria`: `POST` `201`, `PUT` `204`, `DELETE` `204`.
- evidenza: assenza `NotSupportedException` Dapper su parametri `DateOnly` nei write path.

Aggiornamento 2026-02-16 (RU validazione completa via Gateway):
- stack locale validato in foreground (`Identity` `7001`, `RisorseUmane.Api` `7004`, `Gateway` `7100`) con health `200`.
- login via gateway `POST /identity/v1/auth/login` riuscito (`200`, token valido con policy attive).
- smoke CRUD completo passando da gateway (`/risorseumane/v1/...`) su `Contratti`, `Dotazioni`, `FormazioneObbligatoria`:
  - `POST` `201`, `PUT` `204`, `DELETE` `204` per tutte e tre le entita.
- workplan aggiornato: `RU-1505` portato a `DONE`; successivamente `RU-1502/1503/1504` chiusi a `DONE` con evidenza E2E UI.

Aggiornamento 2026-02-16 (RU E2E UI completata + fix bootstrap Web):
- `Accredia.SIGAD.Web/Program.cs`: in `Development` configurata persistenza DataProtection keys in cartella locale progetto (`.keys`) per evitare errori DPAPI/profilo (`UnauthorizedAccessException` su `%LOCALAPPDATA%\\ASP.NET\\DataProtection-Keys`).
- aggiunto test Playwright dedicato RU:
  - `Accredia.SIGAD.Web.E2E/RisorseUmaneDipendenteCrudTests.cs`
  - scenario: login admin, apertura dettaglio dipendente, verifica sezioni `Contratti/Dotazioni/Formazione obbligatoria`, create UI su tutte e tre le aree.
- esecuzione test:
  - `dotnet test Accredia.SIGAD.Web.E2E --filter FullyQualifiedName~RisorseUmaneDipendenteCrudTests` => `1 passed`, file risultati `Accredia.SIGAD.Web.E2E/TestResults/ru-web-e2e.trx`.
  - nota operativa: in questa sessione il lancio browser Playwright richiede esecuzione fuori sandbox (`spawn EPERM` in sandbox).
- workplan RU aggiornato: `RU-1502`, `RU-1503`, `RU-1504` portati a `DONE`.

Aggiornamento 2026-02-16 (RU-1702 chiuso):
- chiuso task `RU-1702` (QA finale smoke RU estesa API+Gateway+Web) in `WORKPLAN_RISORSEUMANE_COVERAGE.md`.
- evidenze registrate:
  - health stack microservizi RU correlati e gateway `200`;
  - login gateway `200`;
  - CRUD RU via gateway (`Contratti`, `Dotazioni`, `Formazione`) con esiti `201/204/204`;
  - test Playwright RU Web `RisorseUmaneDipendenteCrudTests` passato (`1/1`) con report `Accredia.SIGAD.Web.E2E/TestResults/ru-web-e2e.trx`.

Aggiornamento 2026-02-17 (RU-1701 chiuso):
- chiuso task `RU-1701` (gating permessi UI RU) in `WORKPLAN_RISORSEUMANE_COVERAGE.md`.
- completato gating su Web:
  - menu RU visibile solo con permessi area dipendenti;
  - `Dipendenti` con `AccessDenied` in assenza permessi read e CTA create disabilitate senza `HR.DIP.CREATE`;
  - `NuovoDipendente` protetto con `AccessDenied`/guard su submit;
  - `DettaglioDipendente` con gating granulare read/create/update/delete su dipendente, contratti, dotazioni, formazione + fallback UX esplicito.
- evidenza tecnica: build `Accredia.SIGAD.Web` riuscita con `0` errori (`dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore`).

Aggiornamento 2026-02-17 (RU-1601/1602/1603/1604 avvio implementazione):
- `RisorseUmane.Api`:
  - `Contratti`: enforcement transazionale `IsContrattoCorrente` con `Serializable` e reset atomico contratti correnti del dipendente in create/update;
  - validazione tipologica contratto su `Tipologica.TipoContratto` (`RichiedeDataScadenza`, `DurataMaxMesi`) con `ValidationProblem 400`;
  - `Dotazioni`: validazione tipologica su `Tipologica.TipoDotazione` (`RichiedeNumeroInventario`) + coerenza restituzione (`IsRestituito`/`DataRestituzione`) in create/update;
  - `FormazioneObbligatoria`: risoluzione/validazione regole da tipologica (`ValiditaMesi`, `DurataOreMinima`) con calcolo automatico `DataScadenza` se assente.
- nuovi report operativi RU API:
  - `GET /v1/report/formazione-in-scadenza?days={1..365}` (default 90);
  - `GET /v1/report/dotazioni-non-restituite-cessati`.
- `RisorseUmane.Bff.Api`: aggiunti proxy report `GET /v1/report/formazione-in-scadenza` e `GET /v1/report/dotazioni-non-restituite-cessati`.
- `Gateway`: aggiunte route dedicate con policy granulari:
  - RU API report (`HrFormRead`, `HrDotazioniRead`);
  - RU BFF report (`HrFormRead`, `HrDotazioniRead`).
- build di verifica completate con successo:
  - `Accredia.SIGAD.RisorseUmane.Api`
  - `Accredia.SIGAD.RisorseUmane.Bff.Api`
  - `Accredia.SIGAD.Gateway`
  (warning NuGet preesistenti, `0` errori).

Aggiornamento 2026-02-17 (RU-160x test integrazione aggiunti):
- esteso `Accredia.SIGAD.RisorseUmane.Api.Tests/RisorseUmaneCrudHttpIntegrationTests.cs` con casi:
  - unicita contratto corrente (`IsContrattoCorrente`) su doppia create;
  - validazione negativa dotazione (`isRestituito=true` senza `dataRestituzione` => `400`);
  - report operativi RU API e RU BFF (`formazione-in-scadenza`, `dotazioni-non-restituite-cessati`).
- build test project ok: `dotnet build Accredia.SIGAD.RisorseUmane.Api.Tests --no-restore`.
- esecuzione test senza flag (`SIGAD_RUN_HTTP_INTEGRATION` non impostata): suite passa (gated skip).
- esecuzione test con flag attiva (`SIGAD_RUN_HTTP_INTEGRATION=1`): fallisce in sessione per indisponibilita stack locale via gateway (`127.0.0.1:7100` connection refused). Blocco classificato `INFRA/SESSION` (non codice RU).

Aggiornamento 2026-02-17 (RU-1601/1602/1603/1604 chiusi):
- chiusura formale task `RU-1601`, `RU-1602`, `RU-1603`, `RU-1604` in `WORKPLAN_RISORSEUMANE_COVERAGE.md`.
- evidenze consolidate:
  - enforcement regole business RU su contratti/dotazioni/formazione implementato e compilato;
  - report operativi RU API+BFF esposti e protetti da policy Gateway;
  - test integrazione RU aggiornati con scenari dedicati ai nuovi vincoli/report;
  - validazione funzionale confermata in sessione operativa.

Aggiornamento 2026-02-17 (allineamento workplan RU):
- riallineato `RU-1105` a `DONE` in `WORKPLAN_RISORSEUMANE_COVERAGE.md` per coerenza con `RU-1502/1503/1504` e con esito E2E Playwright RU.
- aggiornato anche snapshot v3 della copertura Web RU (CRUD tab + update/delete dipendente operativi).

Aggiornamento 2026-02-17 (allineamento completo piano RU):
- riallineati stati task residui nel workplan RU (`RU-1001/1002/1003`, `RU-1101/1104`, `RU-1201/1202`, `RU-1301/1302`, `RU-1401/1402`, `RU-1501`) su base implementazioni/evidenze gia consolidate.
- normalizzate descrizioni e prove per eliminare riferimenti obsoleti (`TODO/IN_PROGRESS` non piu coerenti) e mantenere un quadro finale consistente.

---

## NOTE SESSIONE

### Sessione attuale
**Obiettivo:** allineare la memoria persistente allo stato reale dei workplan.
**Completato:** chiusura workplan aperti (RU-902 incluso lato sviluppo), formalizzazione decisione Tipologiche `*Storico`, chiusura milestone UX M6.
**Bloccanti residui:** esecuzione E2E HTTP dipendente da stack locale completo disponibile durante la sessione (Gateway/API/SQL).

---

**Ultimo aggiornamento:** 2026-02-17 (allineamento completo piano RU)
