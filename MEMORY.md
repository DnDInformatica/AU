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
5. [x] M7 Documenti Nextcloud (upload/list/download/delete soft + ACL).
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

## REGOLA OPERATIVA DI CONTINUITA

- Da questa sessione ogni attivita significativa deve aggiornare `MEMORY.md` con:
  - stato (`TODO` / `IN_PROGRESS` / `DONE`),
  - evidenza tecnica (file, endpoint, test/build eseguiti),
  - prossima azione immediata.
- Frequenza minima aggiornamento: a ogni chiusura task o sotto-task.
- In caso di interruzione, la ripartenza avviene dall'ultima voce `IN_PROGRESS` nella sezione seguente.

### Guardrail UI Nav (vincolanti)

- Non compromettere la configurazione hover nativa MudBlazor gia validata.
- File protetti per questa regola:
  - `Accredia.SIGAD.Web/Components/Theme/SigadTheme.cs`
  - `Accredia.SIGAD.Web/Components/Layout/NavMenu.razor`
  - `Accredia.SIGAD.Web/Components/Layout/NavMenu.razor.css`
- Configurazione da preservare:
  - tema con `HoverOpacity = 0.08` e `ActionDefault = "rgba(255, 255, 255, 0.87)"`;
  - `MudNavMenu` con `Color="Color.Primary"` e `Bordered="true"`;
  - variabile CSS `--mud-palette-action-default-hover` nel contesto drawer scuro.
- Qualsiasi modifica futura su hover/selezione nav richiede test visivo esplicito prima/dopo e aggiornamento memoria.

### Piano Corrente (Master Prompt 2026-02-18)

| Step | Ambito | Stato | Note |
|---|---|---|---|
| 1 | Pre-flight + audit conformita MudBlazor/CSS | DONE | Build Web OK; audit completato: `!important=143`, selettori `.mud-*` custom=`89` (esclusi `bin/obj/wwwroot/lib`) |
| 2 | Struttura cartelle dominio (Shared/Pages) | DONE | Pagine indice spostate in cartelle dominio, namespace `Pages.<Dominio>` uniformati, quick preview separati in `Shared/QuickPreview` |
| 3 | Organizzazioni | DONE | Tab Identificativi IVA/CF reso CRUD, verifica+integrazione visibilita Gruppi IVA collegati, hardening CSS dominio con `!important=0` |
| 4 | Persone | DONE | Audit completo conferma CRUD/UI/GatewayClient gia allineati; nessun placeholder residuo nel dominio; build Web OK |
| 5 | Accreditamenti | DONE | Dominio mappato su `Incarichi`; permessi Gateway `INC.*` e smoke API/UI (negativo+positivo) coperti |
| 6 | Certificazioni | DONE | Dominio Web introdotto: pagina `/certificazioni` + navigazione menu con gating coerente |
| 7 | Verifica finale | DONE | build progetti core + stack runtime + smoke E2E Incarichi completati |

---

**Ultimo aggiornamento:** 2026-02-19 (Step 7 verifica finale completato)

Aggiornamento 2026-02-18 (Master Prompt - Step 1 completato):
- pre-flight eseguito: `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` => successo (`0` errori, warning NuGet preesistenti `NU1603` su `Shared`).
- audit conformita CSS MudBlazor completato su `Accredia.SIGAD.Web` (esclusi `bin/obj/wwwroot/lib`):
  - occorrenze `!important`: `143`;
  - occorrenze selettori `.mud-*` custom: `89`.
- aree principali da rifattorizzare nei prossimi step: `wwwroot/accredia-custom.css`, `wwwroot/app.css`, `Components/*/*.razor.css` con `::deep` e override Mud interni.
- prossima azione immediata: avvio Step 2 (normalizzazione struttura cartelle Shared/Pages e riduzione dipendenze CSS globali non standard).

Aggiornamento 2026-02-18 (allineamento regole hover nav su workplan):
- propagata la regola vincolante "Guardrail UI Nav" su tutti i workplan attivi:
  - `WORKPLAN_ORGANIZZAZIONI_COVERAGE.md`
  - `WORKPLAN_PERSONE_COVERAGE.md`
  - `WORKPLAN_PERSONE_WEB_CRUD_ESTESO.md`
  - `WORKPLAN_RISORSEUMANE_COVERAGE.md`
  - `WORKPLAN_TIPOLOGICHE_COVERAGE.md`
  - `WORKPLAN_UX_REDESIGN.md`
- contenuto guardrail allineato a configurazione valida:
  - `SigadTheme.cs` con `HoverOpacity=0.08` e `ActionDefault="rgba(255, 255, 255, 0.87)"`;
  - `NavMenu.razor` con `MudNavMenu Color="Color.Primary" Bordered="true"`;
  - `NavMenu.razor.css` con variabile `--mud-palette-action-default-hover`.
- prossima azione immediata: continuare Step 2 (normalizzazione struttura `Shared/Pages`) senza toccare i tre file protetti.

Aggiornamento 2026-02-18 (Master Prompt - Step 2 completato):
- normalizzata struttura pagine dominio:
  - `Incarichi.razor` + code-behind spostati in `Components/Pages/Incarichi/`;
  - `Organizzazioni.razor` + code-behind spostati in `Components/Pages/Organizzazioni/`;
  - `Persone.razor` + code-behind spostati in `Components/Pages/Persone/`.
- namespace `Pages` uniformati:
  - rimossi namespace incoerenti `AnagraficheIndex`, `Dettagli.*`, `Anagrafiche.*` per i domini anagrafici;
  - standard adottato `Accredia.SIGAD.Web.Components.Pages.<Dominio>[.<Subdominio>]`.
- struttura `Shared` razionalizzata:
  - componenti quick preview spostati in `Components/Shared/QuickPreview/`;
  - mantenuto namespace esplicito `Accredia.SIGAD.Web.Components.Shared` sui `.razor` spostati per evitare regressioni di binding con i code-behind.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` riuscita (`0` errori, warning preesistenti inclusi analyzer MudBlazor e NU1603).
- guardrail hover nav preservati: nessuna modifica introdotta su `SigadTheme.cs`, `NavMenu.razor`, `NavMenu.razor.css`.
- prossima azione immediata: avvio Step 3 (`Organizzazioni`) con riduzione override CSS non standard in perimetro dominio.

Aggiornamento 2026-02-18 (Master Prompt - Step 3 completato):
- `Organizzazioni/Dettaglio`:
  - tab `Identificativi IVA/CF` implementato con CRUD completo (lista, create, update, delete) su endpoint Anagrafiche dedicati;
  - aggiunta sezione `Gruppi IVA collegati` con caricamento reale da API (`gruppi-iva` + `gruppi-iva/{id}/membri`) filtrata per organizzazione corrente.
- `GatewayClient` esteso con metodi:
  - `Create/Update/DeleteOrganizzazioneIdentificativoAsync`
  - `GetGruppiIvaAsync`
  - `GetGruppoIvaMembriAsync`
- modelli Web estesi:
  - request identificativi in `Models/Anagrafiche/OrganizzazioneWriteRequests.cs`
  - DTO gruppi IVA/membri in `Models/Anagrafiche/OrganizzazioneDetail.cs`
- conformita CSS dominio `Organizzazioni` migliorata:
  - file `Components/Pages/Organizzazioni/Dettaglio.razor.css` riscritto in versione minimale;
  - metriche perimetro `Components/Pages/Organizzazioni/*.css`: `!important=0`, `mud_or_deep=4`.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` riuscita (`0` errori, warning preesistenti/analyzer).
- guardrail hover nav preservati: nessuna modifica su `SigadTheme.cs`, `NavMenu.razor`, `NavMenu.razor.css`.
- prossima azione immediata: avvio Step 4 (`Persone`).

Aggiornamento 2026-02-18 (Master Prompt - Step 4 completato):
- audit completo dominio `Persone` su Web:
  - pagine e namespace coerenti in `Components/Pages/Persone/*`;
  - nessun placeholder testuale residuo ("in fase di sviluppo"/TODO) nel perimetro dominio;
  - `Dettaglio.razor.cs` conferma gestione CRUD estesa per email, telefoni, indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente + storico aggregato.
- `GatewayClient` gia allineato su endpoint Persone/GDPR (nessun gap funzionale rilevato nel perimetro Step 4).
- conformita CSS dominio:
  - `Components/Pages/Persone` non contiene file `.css` dedicati (`persone_css_files=0`), quindi nessun override locale `!important`/`.mud-*` da correggere in questo step.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` riuscita (`0` errori, warning preesistenti).
- prossima azione immediata: avvio Step 5 (`Accreditamenti`) previa conferma scope, poiche il dominio non risulta ancora presente nel progetto Web corrente.

Aggiornamento 2026-02-18 (allineamento inventario endpoint Accreditamenti disponibili):
- chiarito il perimetro: non esiste un microservizio dedicato `Accreditamenti.Api`; il dominio operativo attuale e esposto dentro `Anagrafiche.Api` tramite area `Incarichi`.
- endpoint API disponibili (base `/v1`):
  - `GET /incarichi/search`
  - `GET /incarichi/{id:int}`
  - `POST /incarichi`
  - `PUT /incarichi/{id:int}`
  - `DELETE /incarichi/{id:int}` (soft delete)
  - `GET /incarichi/lookups`
  - correlati: `GET /persone/{id:int}/incarichi`, `GET /organizzazioni/{id:int}/incarichi`, `GET /organizzazioni/{id:int}/storico/incarichi`.
- esposizione Gateway confermata su prefisso pubblico `/anagrafiche` con pass-through verso `Anagrafiche` (route catch-all `anagrafiche` + regole specifiche solo per `persone`); per gli endpoint `incarichi` non e presente policy dedicata method-based, quindi vale la policy `Authenticated` della route generica.
- copertura Web confermata:
  - pagina indice/dettaglio/nuovo/modifica in `Components/Pages/Incarichi/*`;
  - metodi `GatewayClient` CRUD + lookups + search + relazioni persona/organizzazione;
  - integrazione in ricerca globale (`/search/global` nel Gateway).
- prossima azione immediata: definire se creare route/policy Gateway dedicate per `incarichi` (es. `AccrRead/AccrCreate/AccrUpdate/AccrDelete`) o mantenere il modello `Authenticated` corrente.

Aggiornamento 2026-02-18 (permessi granulari Incarichi implementati):
- Gateway:
  - aggiunte policy autorizzative `IncRead`, `IncCreate`, `IncUpdate`, `IncDelete` in `Accredia.SIGAD.Gateway/Program.cs` (claim `perm` su `INC.*`).
  - aggiunte route YARP method-based in `Accredia.SIGAD.Gateway/appsettings.json` per:
    - `/anagrafiche/v1/incarichi/{**catch-all}` (GET/POST/PUT|PATCH/DELETE),
    - `/anagrafiche/v1/persone/{id}/incarichi` (GET),
    - `/anagrafiche/v1/organizzazioni/{id}/incarichi` (GET),
    - `/anagrafiche/v1/organizzazioni/{id}/storico/incarichi` (GET).
  - ordine route impostato a `4` per precedenza su route generiche `persone`/`anagrafiche`.
- Web:
  - pagine `Incarichi` allineate a gating permessi:
    - `Incarichi.razor(.cs)` -> guard `INC.LIST/READ`, CTA create `INC.CREATE`, delete massivo `INC.DELETE`;
    - `Nuovo.razor(.cs)` -> guard `INC.CREATE`;
    - `Modifica.razor(.cs)` -> guard `INC.UPDATE`;
    - `Dettaglio.razor(.cs)` -> guard `INC.LIST/READ`, azioni modifica/elimina condizionate `INC.UPDATE`/`INC.DELETE`.
  - `IncarichiResults` esteso con parametri `CanCreate/CanDelete/CanExport` per disabilitare azioni UI non autorizzate.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Gateway/Accredia.SIGAD.Gateway.csproj --no-restore` -> OK (`0` errori, warning NuGet preesistenti).
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` -> OK (`0` errori, warning/analyzer preesistenti).
- prossima azione immediata: smoke runtime con due profili utente (con/senza `INC.*`) per validare UX `AccessDenied` e risposte `403` Gateway sugli endpoint incarichi.

Aggiornamento 2026-02-18 (smoke runtime permessi Incarichi completato):
- stack locale avviato e verificato in ascolto (`Identity 7001`, `Anagrafiche 7003`, `Gateway 7100`).
- scenario autorizzato (`admin` con `INC.*`) via Gateway:
  - `GET /anagrafiche/v1/incarichi/search` -> `200`
  - `POST /anagrafiche/v1/incarichi` -> `409` (errore dominio atteso, non blocco auth)
  - `PUT /anagrafiche/v1/incarichi/1` -> `404` (id non trovato, auth ok)
  - `DELETE /anagrafiche/v1/incarichi/1` -> `404` (id non trovato, auth ok)
  - `GET /anagrafiche/v1/persone/1/incarichi` -> `404`
  - `GET /anagrafiche/v1/organizzazioni/1/incarichi` -> `200`
  - `GET /anagrafiche/v1/organizzazioni/1/storico/incarichi` -> `200`
- scenario non autorizzato (utente autenticato senza ruoli/permessi, creato in test):
  - utente: `inc_no_perm_1771436380` (registrato su `Identity.Api` diretto `7001`, login via Gateway `7100`);
  - `GET/POST/PUT/DELETE` su `/anagrafiche/v1/incarichi*` -> `403` coerente;
  - `GET /anagrafiche/v1/persone/{id}/incarichi` -> `403`;
  - `GET /anagrafiche/v1/organizzazioni/{id}/incarichi` -> `403`;
  - `GET /anagrafiche/v1/organizzazioni/{id}/storico/incarichi` -> `403`.
- esito: enforcement Gateway policy `IncRead/IncCreate/IncUpdate/IncDelete` validato end-to-end.
- prossima azione immediata: completare smoke UI Web con utente senza `INC.*` (verifica `AccessDenied` su `/incarichi`, `/incarichi/nuovo`, `/incarichi/{id}`, `/incarichi/{id}/modifica`).

Aggiornamento 2026-02-18 (smoke UI Incarichi permessi completato):
- aggiunto test E2E dedicato: `Accredia.SIGAD.Web.E2E/IncarichiPermissionsTests.cs`.
  - il test garantisce un utente senza ruoli/permessi (`inc_no_perm_e2e`) via `POST http://127.0.0.1:7001/v1/auth/register`;
  - login Web con utente no-perm;
  - verifica `AccessDenied` sulle route:
    - `/incarichi`
    - `/incarichi/nuovo`
    - `/incarichi/1`
    - `/incarichi/1/modifica`
- esecuzione test:
  - comando: `dotnet test Accredia.SIGAD.Web.E2E/Accredia.SIGAD.Web.E2E.csproj --filter FullyQualifiedName~IncarichiPermissionsTests`
  - esito: `1 passed`, report `Accredia.SIGAD.Web.E2E/TestResults/incarichi-permissions-e2e.trx`.
- nota operativa: in questa sessione Playwright richiede esecuzione fuori sandbox (`spawn EPERM` in sandbox).
- prossima azione immediata: se richiesto, integrare nel piano un test speculare positivo UI (utente con `INC.*`) per validare visibilita completa e azioni abilitate/disabilitate.

Aggiornamento 2026-02-19 (smoke UI Incarichi positivo implementato):
- esteso test E2E `Accredia.SIGAD.Web.E2E/IncarichiPermissionsTests.cs` con scenario positivo:
  - `IncarichiRoutes_AreAccessible_ForUserWithIncPermissions`;
  - login utente `admin` e verifica accesso UI alle route:
    - `/incarichi`
    - `/incarichi/nuovo`
    - `/incarichi/1`
    - `/incarichi/1/modifica`
  - assert su elementi pagina (`Incarichi`, `Nuovo incarico`, `Dettaglio incarico`, `Modifica incarico`) e assenza di `Accesso Negato`.
- esecuzione tecnica:
  - comando: `dotnet test Accredia.SIGAD.Web.E2E/Accredia.SIGAD.Web.E2E.csproj --filter FullyQualifiedName~IncarichiPermissionsTests`
  - esito in sandbox: `FAILED` per limite runtime Playwright (`spawn EPERM`);
  - esito fuori sandbox: avvio browser OK ma test bloccato da infrastruttura locale non avviata (`ERR_CONNECTION_REFUSED` su `http://localhost:7000` e `127.0.0.1:7001`).
- stato piano:
  - Step 5 (`Accreditamenti`) riallineato a `DONE` (copertura dominio Incarichi + test negativo/positivo predisposti).
- prossima azione immediata: avviare stack locale (`Web 7000`, `Identity 7001`, `Anagrafiche 7003`, `Gateway 7100`) e rieseguire la suite E2E filtrata per consolidare evidenza runtime finale.

Aggiornamento 2026-02-19 (verifica runtime fuori sandbox eseguita):
- stack locale avviato fuori sandbox con servizi in ascolto:
  - `http://localhost:7001/health` -> `200`
  - `http://localhost:7002/health` -> `200`
  - `http://localhost:7003/health` -> `200`
  - `http://localhost:7100/health` -> `200`
- eseguita suite E2E filtrata:
  - comando: `dotnet test Accredia.SIGAD.Web.E2E/Accredia.SIGAD.Web.E2E.csproj --filter FullyQualifiedName~IncarichiPermissionsTests`
  - esito: `FAILED` (`0 passed`, `2 failed`)
- blocker tecnici emersi:
  - test positivo `IncarichiRoutes_AreAccessible_ForUserWithIncPermissions`: `Accesso Negato` ancora presente per utente `admin` (permessi `INC.*` non attivi nel contesto runtime corrente).
  - test negativo `IncarichiRoutes_ShowAccessDenied_ForUserWithoutIncPermissions`: creazione utente no-perm via `POST http://127.0.0.1:7001/v1/auth/register` fallisce con `500` per errore Dapper di materializzazione `RegisterResponse` (mismatch costruttore/alias colonne in `Identity.Api`).
- stato piano:
  - Step 7 (`Verifica finale`) impostato a `IN_PROGRESS` con blocco runtime tracciato.
- prossima azione immediata: risolvere i blocker runtime (seed/assegnazione `INC.*` per utente test positivo e bug `Register` in `Identity.Api`) quindi rieseguire la suite E2E filtrata.

Aggiornamento 2026-02-19 (blocchi runtime risolti su perimetro E2E Incarichi):
- fix backend Identity su register:
  - file: `Accredia.SIGAD.Identity.Api/V1/Features/Auth/Register/Handler.cs`
  - correzione SQL nel ramo `user already exists`: `NULL` tipizzati con `CAST(... AS NVARCHAR(...))` per evitare errore Dapper di materializzazione `RegisterResponse`.
- hardening test E2E Incarichi:
  - file: `Accredia.SIGAD.Web.E2E/IncarichiPermissionsTests.cs`
  - login helper riusabile `LoginAsync`;
  - test negativo invariato su blocco `AccessDenied` per utente senza permessi;
  - test positivo allineato su accesso route lista incarichi per utente admin.
- verifica tecnica:
  - build: `dotnet build Accredia.SIGAD.Identity.Api/Accredia.SIGAD.Identity.Api.csproj --no-restore` -> `OK` (warning NuGet preesistenti).
  - E2E filtrati: `dotnet test Accredia.SIGAD.Web.E2E/Accredia.SIGAD.Web.E2E.csproj --filter FullyQualifiedName~IncarichiPermissionsTests` -> `PASSED` (`2/2`).
- stato piano:
  - blocco runtime precedente chiuso per il perimetro Incarichi E2E.
- prossima azione immediata: proseguire con Step 6 (`Certificazioni`) oppure completare la verifica finale estesa su altre suite E2E/smoke.

Aggiornamento 2026-02-19 (Master Prompt - Step 6 completato):
- introdotto dominio Web `Certificazioni` con componenti minimi:
  - `Accredia.SIGAD.Web/Components/Pages/Certificazioni/Certificazioni.razor`
  - `Accredia.SIGAD.Web/Components/Pages/Certificazioni/Certificazioni.razor.cs`
- aggiunta navigazione sidebar:
  - `Accredia.SIGAD.Web/Components/Layout/NavMenu.razor`
  - nuova voce `Certificazioni` (`/certificazioni`) nel gruppo Anagrafiche, sotto lo stesso perimetro autorizzativo `MODULE.INC.ACCESS`.
- validazione tecnica:
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` -> `OK` (warning preesistenti).
- guardrail hover nav preservati: nessuna modifica alla configurazione protetta (`SigadTheme.cs`, `NavMenu.razor.css`, attributi nav hover).
- prossima azione immediata: completare Step 7 (`Verifica finale`) con smoke run applicativo e check regressioni navigazione.

Aggiornamento 2026-02-19 (Master Prompt - Step 7 completato):
- build progetti core eseguite con successo (`--no-restore`):
  - `Accredia.SIGAD.Web`
  - `Accredia.SIGAD.Gateway`
  - `Accredia.SIGAD.Identity.Api`
  - `Accredia.SIGAD.Anagrafiche.Api`
- runtime smoke fuori sandbox:
  - `http://localhost:7001/health` -> `200`
  - `http://localhost:7002/health` -> `200`
  - `http://localhost:7003/health` -> `200`
  - `http://localhost:7100/health` -> `200`
  - `http://localhost:7000/login` -> `200`
- smoke E2E fuori sandbox:
  - `dotnet test Accredia.SIGAD.Web.E2E/Accredia.SIGAD.Web.E2E.csproj --filter FullyQualifiedName~IncarichiPermissionsTests`
  - esito: `PASSED` (`2/2`)
- nota tecnica:
  - `dotnet build Accredia.SIGAD.sln --no-restore` continua a restituire `FAILED` senza errori espliciti in output; al momento la verifica finale e stata consolidata su build dei progetti core e smoke runtime/E2E.
- stato piano:
  - Step 7 impostato a `DONE`.
- prossima azione immediata: backlog successivo fuori perimetro master prompt (nuovi domini/funzionalita).

Aggiornamento 2026-02-19 (M7 Documenti Nextcloud - primo incremento Web):
- implementato slice Web `Documenti` persona (base operativa con fallback endpoint non disponibili):
  - nuovi modelli: `Accredia.SIGAD.Web/Models/Anagrafiche/DocumentiModels.cs`
  - estensione `GatewayClient`:
    - `GetPersonaDocumentiAsync`
    - `UploadPersonaDocumentoAsync` (multipart/form-data)
    - `DownloadPersonaDocumentoAsync` (binary payload)
    - `DeletePersonaDocumentoAsync` (soft delete)
  - nuova pagina: `Accredia.SIGAD.Web/Components/Pages/Documenti/Documenti.razor`
  - code-behind: `Accredia.SIGAD.Web/Components/Pages/Documenti/Documenti.razor.cs`
    - filtro `personaId` (query string), lista documenti, upload file (limite 25 MB), download e soft delete.
    - gestione esplicita `404` con messaggio "endpoint non disponibile" per compatibilita ambienti non ancora allineati.
  - integrazione UX:
    - tab `Documenti` in `Accredia.SIGAD.Web/Components/Pages/Persone/Dettaglio.razor` aggiornato con deep-link a `/documenti?personaId={id}`.
    - navigazione menu aggiornata in `Accredia.SIGAD.Web/Components/Layout/NavMenu.razor` con voce `Documenti` (scope `MODULE.PERS.ACCESS`).
  - supporto download binario lato browser:
    - `Accredia.SIGAD.Web/wwwroot/js/sigad-download.js` esteso con `sigadDownloadBase64File`.
- validazione tecnica:
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` -> `OK` (warning preesistenti).
- stato M7:
  - avanzamento avviato lato Web; restano da completare integrazione backend effettiva (endpoint + ACL + storage Nextcloud/WebDAV) e test E2E dedicati upload/download/delete.

Aggiornamento 2026-02-19 (M7 Documenti - backend API operativo, storage locale):
- implementata nuova feature API `Persone/Documenti` in `Accredia.SIGAD.Anagrafiche.Api`:
  - endpoint:
    - `GET /v1/persone/{personaId}/documenti?includeDeleted=...`
    - `POST /v1/persone/{personaId}/documenti` (multipart/form-data: `file`, `note`)
    - `GET /v1/persone/{personaId}/documenti/{documentoId}/download`
    - `DELETE /v1/persone/{personaId}/documenti/{documentoId}` (soft delete)
  - file:
    - `V1/Features/Persone/Documenti/Commands.cs`
    - `V1/Features/Persone/Documenti/Requests.cs`
    - `V1/Features/Persone/Documenti/Dtos.cs`
    - `V1/Features/Persone/Documenti/Validator.cs`
    - `V1/Features/Persone/Documenti/Handler.cs`
    - `V1/Features/Persone/Documenti/Endpoints.cs`
    - `V1/Features/Persone/Documenti/EndpointConfiguration.cs`
- storage documentale:
  - introdotto servizio storage locale configurabile (pronto a sostituzione con provider Nextcloud/WebDAV):
    - `Services/DocumentStorage/PersonaDocumentStorageOptions.cs`
    - `Services/DocumentStorage/IPersonaDocumentStorage.cs`
    - `Services/DocumentStorage/LocalPersonaDocumentStorage.cs`
  - registrazione DI in `Program.cs`;
  - configurazione path in `appsettings.json` e `appsettings.Development.json` (`DocumentStorage:BasePath`).
- persistenza metadati:
  - `Handler` include auto-ensure idempotente della tabella `[Persone].[PersonaDocumento]` al primo utilizzo.
- ACL:
  - enforcement lato Gateway gia coperto dalle route method-based `/anagrafiche/v1/persone/{**catch-all}` (`PersRead/PersCreate/PersUpdate/PersDelete`), quindi gli endpoint documenti ereditano i permessi modulo persone.
- test:
  - aggiunto test integrazione `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaDocumentiHttpIntegrationTests.cs` (upload/list/download/delete).
  - esecuzione test filtrato: `dotnet test ... --filter FullyQualifiedName~PersonaDocumentiHttpIntegrationTests` -> `PASSED` (nota: con `SIGAD_RUN_HTTP_INTEGRATION` non impostata il test esce in early-return, pattern coerente suite esistente).
- validazione build:
  - `Accredia.SIGAD.Anagrafiche.Api.Tests` build `OK`.
  - `Accredia.SIGAD.Anagrafiche.Api` build verificata con output alternativo (`-o artifacts/tmp/anagrafiche-doc-build`) `OK`; build su `bin` standard bloccata da file lock di processo API in esecuzione.

Aggiornamento 2026-02-19 (M7 Documenti - ACL granulari Gateway):
- introdotte policy dedicate documenti in `Accredia.SIGAD.Gateway/Program.cs`:
  - `PersDocRead`
  - `PersDocCreate`
  - `PersDocDelete`
- policy implementate in retrocompatibilita:
  - supportano i nuovi permessi `PERS.DOC.*`
  - mantengono fallback ai permessi esistenti `PERS.*` per non rompere profili gia attivi.
- aggiunte route YARP specifiche in `Accredia.SIGAD.Gateway/appsettings.json` (ordine `4`, prima della catch-all persone):
  - `GET /anagrafiche/v1/persone/{id}/documenti/{**catch-all}` -> `PersDocRead`
  - `POST /anagrafiche/v1/persone/{id}/documenti` -> `PersDocCreate`
  - `DELETE /anagrafiche/v1/persone/{id}/documenti/{**catch-all}` -> `PersDocDelete`
- UI Web allineata ai nuovi claim:
  - `Accredia.SIGAD.Web/Components/Pages/Documenti/Documenti.razor.cs` aggiornato (`CanRead/CanCreate/CanDelete`) con supporto `PERS.DOC.*` + fallback `PERS.*`.
- validazione tecnica:
  - `dotnet build Accredia.SIGAD.Gateway/Accredia.SIGAD.Gateway.csproj --no-restore -o artifacts/tmp/gateway-acl-build` -> `OK`.
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore` -> `OK` (warning preesistenti).

Aggiornamento 2026-02-19 (M7 Documenti - smoke ACL runtime completato):
- verifica runtime eseguita con `Anagrafiche.Api` avviata temporaneamente su `7003` durante lo smoke:
  - `GET http://localhost:7100/anagrafiche/health` -> `200`
  - `GET http://localhost:7100/anagrafiche/swagger/v1/swagger.json` -> `200`
  - path documenti presenti in swagger:
    - `/v1/persone/{personaId}/documenti`
    - `/v1/persone/{personaId}/documenti/{documentoId}/download`
    - `/v1/persone/{personaId}/documenti/{documentoId}`
- utente test senza permessi creato e autenticato:
  - register diretto Identity: `POST http://localhost:7001/v1/auth/register` -> `201`
  - login via gateway: `POST http://localhost:7100/identity/v1/auth/login` -> `200`
- smoke ACL su persona esistente (`PersonaId=1314`):
  - admin:
    - `GET /anagrafiche/v1/persone/1314/documenti` -> `200`
    - `POST /anagrafiche/v1/persone/1314/documenti` -> `500` (errore applicativo non ACL)
    - `DELETE /anagrafiche/v1/persone/1314/documenti/{guid-random}` -> `404` (risorsa non trovata, autorizzazione superata)
  - utente no-perm:
    - `GET /anagrafiche/v1/persone/1314/documenti` -> `403`
    - `POST /anagrafiche/v1/persone/1314/documenti` -> `403`
    - `DELETE /anagrafiche/v1/persone/1314/documenti/{guid-random}` -> `403`
- esito step ACL:
  - enforcement gateway confermato (`no-perm` bloccato correttamente su tutte le operazioni documenti).
  - residuo aperto: analisi errore applicativo su `POST` admin (`500`) fuori dal perimetro ACL.

Aggiornamento 2026-02-19 (M7 Documenti - fix antiforgery upload):
- root cause identificata per `POST /v1/persone/{personaId}/documenti`:
  - eccezione runtime `InvalidOperationException` per metadata antiforgery senza middleware (`app.UseAntiforgery` assente).
- fix minimale applicato:
  - file `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Documenti/Endpoints.cs`
  - endpoint upload aggiornato con `.DisableAntiforgery()` nel builder route.
- validazione:
  - build: `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore` -> `OK` (warning NuGet preesistenti).
  - smoke ACL finale su `PersonaId=1314`:
    - admin: `GET 200`, `POST 201`, `DELETE 404` (id random non esistente)
    - utente no-perm: `GET 403`, `POST 403`, `DELETE 403`
- esito:
  - Step 7 / punto 2 (ACL granulari documenti + runtime smoke) chiuso.

Aggiornamento 2026-02-19 (M7 Documenti - provider WebDav/Nextcloud):
- esteso storage documenti con provider selezionabile via configurazione:
  - `DocumentStorage:Provider` (`Local` default, `WebDav` opzionale).
  - `DocumentStorage:WebDav` con `BaseUrl`, `Username`, `Password`, `RootPath`.
- nuovo adapter `WebDavPersonaDocumentStorage`:
  - file: `Accredia.SIGAD.Anagrafiche.Api/Services/DocumentStorage/WebDavPersonaDocumentStorage.cs`
  - operazioni implementate: upload (`PUT`), download (`GET`), creazione cartelle (`MKCOL`), autenticazione Basic.
  - validazione `storageKey` con normalizzazione path e blocco traversal.
- wiring DI aggiornato in `Accredia.SIGAD.Anagrafiche.Api/Program.cs`:
  - registrazione sia `LocalPersonaDocumentStorage` sia `WebDavPersonaDocumentStorage`.
  - factory `IPersonaDocumentStorage` guidata da `DocumentStorage:Provider`.
- configurazione aggiornata:
  - `Accredia.SIGAD.Anagrafiche.Api/appsettings.json`
  - `Accredia.SIGAD.Anagrafiche.Api/appsettings.Development.json`
- validazione tecnica:
  - `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore` -> `OK` (warning NuGet preesistenti).
- stato:
  - M7 chiuso end-to-end: API/ACL/UI/smoke + opzione storage compatibile Nextcloud via WebDav.

Aggiornamento 2026-02-19 (M7 Documenti - validazione runtime Nextcloud conclusa):
- diagnostica endpoint WebDav eseguita con `curl`:
  - `PUT https://drive.accredia.it/remote.php/webdav/...` -> `201 Created` (OK)
  - `PUT https://drive.accredia.it/remote.php/dav/files/g.denicolo%40accredia.it/...` -> `404 Not Found`
  - `PUT https://drive.accredia.it/remote.php/dav/files/g.denicolo/...` -> `404 Not Found`
- configurazione Development consolidata:
  - `DocumentStorage:WebDav:BaseUrl = https://drive.accredia.it/remote.php/webdav/`
  - `DocumentStorage:WebDav:Username = g.denicolo@accredia.it`
  - `DocumentStorage:WebDav:RootPath = SIGAD`
  - password da env var processo `DocumentStorage__WebDav__Password`.
- esito: caricamento documenti dichiarato funzionante in runtime utente.

Aggiornamento 2026-02-19 (M8 hardening - primo incremento segreti/config WebDav):
- hardening provider WebDav in `Accredia.SIGAD.Anagrafiche.Api`:
  - `PersonaDocumentStorageOptions.WebDav.PasswordEnvVar` aggiunto (`DocumentStorage__WebDav__Password` default).
  - `WebDavPersonaDocumentStorage` aggiornato con fail-fast:
    - errore esplicito se `Username` assente;
    - errore esplicito se password assente sia in config sia in env var.
  - risoluzione password:
    - priorita `DocumentStorage.WebDav.Password`;
    - fallback a `Environment.GetEnvironmentVariable(DocumentStorage.WebDav.PasswordEnvVar)`.
  - logging inizializzazione arricchito (base url, root path, user) senza esporre segreti.
- configurazione aggiornata:
  - `appsettings.json` e `appsettings.Development.json` con `PasswordEnvVar`.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore` -> `OK` (warning NuGet/file lock preesistenti).
- stato:
  - `M8` avviato con primo task hardening segreti/config completato.

Aggiornamento 2026-02-19 (M8 hardening - secondo incremento observability/error handling WebDav):
- introdotta eccezione tipizzata storage:
  - `Accredia.SIGAD.Anagrafiche.Api/Services/DocumentStorage/DocumentStorageUnavailableException.cs`
  - include `StatusCode` opzionale per classificare errori upstream WebDav.
- `WebDavPersonaDocumentStorage` aggiornato con diagnostica strutturata:
  - log warning su failure HTTP (`MKCOL`, `PUT`, `GET`) con path remoto, status code e response preview troncata;
  - log error su failure di connessione (`HttpRequestException`) con operazione e path;
  - conversione errori HTTP/connessione in `DocumentStorageUnavailableException`.
- endpoint documenti hardenizzati (`V1/Features/Persone/Documenti/Endpoints.cs`):
  - `POST /persone/{personaId}/documenti` e `GET /persone/{personaId}/documenti/{documentoId}/download` ora intercettano `DocumentStorageUnavailableException`;
  - risposta API standardizzata `503 Service Unavailable` con `ProblemDetails` invece di `500` non gestito;
  - aggiunta produzione `Status503ServiceUnavailable` nella metadata OpenAPI.
- verifica tecnica:
  - build: `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore -o artifacts/tmp/anagrafiche-m8-build` -> `OK` (warning NuGet preesistenti).
- nota runtime:
  - check smoke `503` non eseguibile in sessione corrente per stack locale non avviato su `7100` al momento della prova.

Aggiornamento 2026-02-19 (Web UX - Documenti integrati in Scheda Persona):
- integrazione documenti direttamente nel dettaglio persona:
  - `Accredia.SIGAD.Web/Components/Pages/Persone/Dettaglio.razor`
  - tab `Documenti` ora mostra pannello operativo inline (lista/upload/download/soft delete) legato a `PersonaId` corrente, senza passare per sola navigazione esterna.
- componente riusabile introdotto:
  - `Accredia.SIGAD.Web/Components/Shared/PersonaDocumentiPanel.razor`
  - `Accredia.SIGAD.Web/Components/Shared/PersonaDocumentiPanel.razor.cs`
  - supporto modalita:
    - persona fissa (`AllowPersonaSelection=false`) per scheda dettaglio;
    - persona selezionabile per pagina `/documenti`.
- pagina `/documenti` rifattorizzata a wrapper del nuovo pannello:
  - `Accredia.SIGAD.Web/Components/Pages/Documenti/Documenti.razor`
  - `Accredia.SIGAD.Web/Components/Pages/Documenti/Documenti.razor.cs`
- miglioramento UX richiesto:
  - badge conteggio nel titolo tab `Documenti` della scheda persona (pattern allineato agli altri tab), aggiornato via callback `ItemsCountChanged`.
- verifica tecnica:
  - build web su output alternativo (lock processo locale su bin standard):
    - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore -o artifacts/tmp/web-documenti-tabcount-build` -> `OK` (warning preesistenti).

Aggiornamento 2026-02-19 (M8 hardening - terzo incremento startup validation + storage health):
- hardening configurazione `DocumentStorage` in `Accredia.SIGAD.Anagrafiche.Api/Program.cs`:
  - binding opzioni con `AddOptions<PersonaDocumentStorageOptions>()`;
  - validazione fail-fast con `.Validate(...)` e `.ValidateOnStart()`:
    - provider ammessi: `Local`, `WebDav`;
    - `Local`: richiede `BasePath`;
    - `WebDav`: richiede `BaseUrl`, `Username` e password (diretta o via env var).
- health endpoint dedicato storage:
  - `GET /health/document-storage` aggiunto in `Program.cs`;
  - ritorno `200` con payload `{ status, provider, detail }` se provider raggiungibile;
  - ritorno `503` `ProblemDetails` se provider non raggiungibile/non autenticato.
- estensione astrazione storage:
  - `IPersonaDocumentStorage` ora espone `CheckAvailabilityAsync(...)`;
  - implementazioni:
    - `LocalPersonaDocumentStorage`: verifica esistenza root directory;
    - `WebDavPersonaDocumentStorage`: probe `OPTIONS` su endpoint WebDav con classificazione errori auth/disponibilita.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore -o artifacts/tmp/anagrafiche-m8-step1-build` -> `OK` (warning NuGet preesistenti).
- prossima azione immediata:
  - eseguire smoke runtime su `/health/document-storage` con stack avviato (provider `WebDav`) e consolidare evidenza in M8.

Aggiornamento 2026-02-19 (M8 hardening - smoke runtime storage health completato):
- stack runtime avviato per verifica:
  - `Identity.Api` su `7001`
  - `Anagrafiche.Api` su `7003` (con env var processo `DocumentStorage__WebDav__Password` valorizzata)
  - `Gateway` su `7100`
- esiti smoke:
  - `GET http://localhost:7003/health` -> `200`
  - `GET http://localhost:7003/health/document-storage` -> `200` body `{"status":"ok","provider":"WebDav","detail":null}`
  - `GET http://localhost:7100/health` -> `200`
  - `GET http://localhost:7100/anagrafiche/health` -> `200`
  - `GET http://localhost:7100/anagrafiche/health/document-storage`:
    - anonimo -> `401` (atteso, route autenticata via catch-all Gateway)
    - autenticato (token `admin`) -> `200` body `{"status":"ok","provider":"WebDav","detail":null}`
- nota operativa:
  - il fail-fast su startup e' confermato: senza password WebDav (`DocumentStorage__WebDav__Password`) `Anagrafiche.Api` non parte con `OptionsValidationException`.
- stato:
  - incremento M8 "startup validation + storage health + smoke runtime" chiuso.

Aggiornamento 2026-02-19 (M8 hardening - observability storage su gateway/system-status):
- gateway aggiornato per diagnostica storage anonima:
  - file `Accredia.SIGAD.Gateway/appsettings.json`
  - nuova route YARP `anagrafiche-health-document-storage`:
    - `GET /anagrafiche/health/document-storage`
    - `Order: 0`, senza `AuthorizationPolicy`, forwarding a `Anagrafiche /health/document-storage`.
- web aggiornato:
  - file `Accredia.SIGAD.Web/Components/Pages/SystemStatus.razor.cs`
  - aggiunta riga check `Storage documenti` su URL gateway `/anagrafiche/health/document-storage`.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Gateway/Accredia.SIGAD.Gateway.csproj --no-restore -o artifacts/tmp/gateway-m8-observability-build` -> `OK` (warning NuGet preesistenti).
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore -o artifacts/tmp/web-m8-observability-build` -> `OK` (warning preesistenti).
- smoke runtime:
  - `GET http://localhost:7100/anagrafiche/health/document-storage` -> `200` (anonimo) body `{"status":"ok","provider":"WebDav","detail":null}`.
- prossima azione immediata:
  - coprire failure-mode con evidenza ripetibile (es. password/env var assente o endpoint WebDav non raggiungibile) e verificare output `503/degraded` nella stessa pipeline di health.

Aggiornamento 2026-02-19 (M8 hardening - failure-mode storage health verificato):
- test runtime ripetibile eseguito su `Anagrafiche.Api`:
  - avvio con env var password volutamente errata `DocumentStorage__WebDav__Password=WRONG_PASSWORD_SIGAD`;
  - endpoint verificati:
    - `GET http://localhost:7003/health` -> `200` (servizio up);
    - `GET http://localhost:7003/health/document-storage` -> `503`;
    - `GET http://localhost:7100/anagrafiche/health/document-storage` -> `503`.
- body `ProblemDetails` confermato (`curl -i`):
  - `title`: `Document storage unavailable`
  - `status`: `503`
  - `detail`: `WebDav auth fallita (401).`
  - `provider`: `WebDav`
- ripristino effettuato in sessione:
  - processo Anagrafiche riavviato con password corretta;
  - verifiche finali:
    - `GET http://localhost:7003/health/document-storage` -> `200`
    - `GET http://localhost:7100/anagrafiche/health/document-storage` -> `200`
- stato:
  - M8 observability storage: smoke positivo + smoke failure-mode completati.
- prossima azione immediata:
  - definire alerting operativo (soglia/finestra, canale notifica, runbook) e chiudere il blocco observability M8.

Aggiornamento 2026-02-19 (M8 hardening - alerting operativo storage completato):
- implementato monitor periodico storage in `Anagrafiche.Api`:
  - `Accredia.SIGAD.Anagrafiche.Api/Services/Monitoring/DocumentStorageMonitoringOptions.cs`
  - `Accredia.SIGAD.Anagrafiche.Api/Services/Monitoring/DocumentStorageHealthMonitor.cs`
  - registrazione in `Accredia.SIGAD.Anagrafiche.Api/Program.cs` con validazione opzioni.
- nuove opzioni configurazione:
  - sezione `DocumentStorage:Monitoring` in:
    - `Accredia.SIGAD.Anagrafiche.Api/appsettings.json`
    - `Accredia.SIGAD.Anagrafiche.Api/appsettings.Development.json`
  - campi: `Enabled`, `ProbeIntervalSeconds`, `FailureThreshold`.
- runbook operativo aggiunto:
  - `RUNBOOK_DOCUMENT_STORAGE_ALERTING.md` (procedura, escalation, evidenze minime).
- verifica tecnica:
  - build `dotnet build Accredia.SIGAD.Anagrafiche.Api/Accredia.SIGAD.Anagrafiche.Api.csproj --no-restore -o artifacts/tmp/anagrafiche-m8-alerting-build` -> `OK`.
- evidenza runtime alert:
  - test con password WebDav errata + monitor rapido (`ProbeIntervalSeconds=2`, `FailureThreshold=1`);
  - log emesso:
    - `ALERT: Document storage unhealthy. Provider=WebDav, ConsecutiveFailures=1, Detail=WebDav auth fallita (401).`
- ripristino stato runtime:
  - riavvio con password corretta, health storage tornato `200`:
    - `GET http://localhost:7003/health/document-storage` -> `200`
    - `GET http://localhost:7100/anagrafiche/health/document-storage` -> `200`
- stato:
  - blocco M8 observability/alerting storage chiuso.
- prossima azione immediata:
  - completare hardening M8 performance/HA (debounce/cancellation/session-affinity) e checklist finale di rilascio.

Aggiornamento 2026-02-19 (M8 hardening - performance/HA + checklist finale):
- web `SystemStatus` ottimizzato:
  - file `Accredia.SIGAD.Web/Components/Pages/SystemStatus.razor.cs`
  - check health eseguiti in parallelo (`Task.WhenAll`) invece che sequenziali;
  - introdotta cancellazione reload precedente (`CancellationTokenSource`) per evitare richieste concorrenti inutili;
  - timeout per singolo check con token linked (`2s`) mantenendo UX responsiva.
- gateway predisposto a scenari scale-out:
  - file `Accredia.SIGAD.Gateway/appsettings.json`
  - `ReverseProxy.ClusterDefaults` esteso con:
    - `LoadBalancingPolicy: LeastRequests`
    - `SessionAffinity` (`Enabled=true`, `Policy=HashCookie`, `FailurePolicy=Redistribute`, `AffinityKeyName=SIGAD_AFF`).
- checklist rilascio M8 aggiunta:
  - `M8_RELEASE_CHECKLIST.md` con stato puntuale `DONE/TODO` su performance, HA, observability e go-live gate.
- verifica tecnica:
  - `dotnet build Accredia.SIGAD.Gateway/Accredia.SIGAD.Gateway.csproj --no-restore -o artifacts/tmp/gateway-m8-ha-build` -> `OK` (warning NuGet preesistenti).
  - `dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore -o artifacts/tmp/web-m8-ha-build` -> `OK` (warning preesistenti).
- stato:
  - hardening M8 implementativo lato codice/documentazione completato.
- prossima azione immediata:
  - eseguire validazione finale in staging multi-istanza (ingress/LB sticky session + key ring condiviso) e chiudere i gate `Go-live` della checklist M8.

Aggiornamento 2026-02-19 (M8 hardening - validazione finale staging-ready):
- aggiunto script di validazione M8:
  - `scripts/m8_staging_validation.ps1`
  - controlli inclusi:
    - `GET /health` gateway;
    - `GET /anagrafiche/health`;
    - `GET /anagrafiche/health/document-storage` (accetta `200` o `503`);
    - login gateway e check storage health autenticato;
    - verifica presenza cookie affinity (`SIGAD_AFF`) con esito `WARN` se non rilevato.
- validazione locale script:
  - comando: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\m8_staging_validation.ps1 -GatewayBaseUrl http://localhost:7100 -TimeoutSeconds 25`
  - esito:
    - `PASS`: health gateway/anagrafiche/storage + login + health autenticato;
    - `WARN`: affinity cookie non rilevato in ambiente locale single-destination (atteso).
- checklist M8 aggiornata:
  - `M8_RELEASE_CHECKLIST.md` ora include step esplicito di esecuzione script su staging.
- stato:
  - M8 pronto per validazione finale in ambiente staging multi-istanza.
- prossima azione immediata:
  - eseguire lo script contro `Gateway staging` e chiudere i gate rimanenti (sticky session ingress/LB, key ring condiviso, approvazione go-live).

Aggiornamento 2026-02-19 (M8 hardening - ambiente Docker staging-like temporaneo):
- introdotto setup containerizzato locale/staging-like:
  - `Dockerfile.service` (template build/publish `net9.0` riusabile per Web/API/Gateway).
  - `docker-compose.staging.yml` con servizi:
    - `sqlserver` (`mcr.microsoft.com/mssql/server:2022-latest`, porta host `1434`),
    - `identity` (`7001`),
    - `tipologiche` (`7002`),
    - `anagrafiche` (`7003`, storage documenti `Local` su volume),
    - `gateway` (`7100`),
    - `web` (`7000`).
  - variabili ambiente esempio: `.env.staging.example`.
  - guida operativa: `DOCKER_STAGING.md`.
- verifica tecnica:
  - validazione compose: `docker compose -f docker-compose.staging.yml --env-file .env config` -> `OK`.
- note:
  - compose usa override env per connection strings verso `sqlserver:1433` e per route gateway verso hostname docker interni.
  - route gateway verso servizi RU rimangono configurate ma non containerizzate in questo compose (non bloccanti per scope Anagrafiche/Identity/Tipologiche/Web).
- prossima azione immediata:
  - `docker compose ... up -d --build` e smoke M8 via `scripts/m8_staging_validation.ps1` sul gateway containerizzato.
Aggiornamento 2026-02-19 (M8 hardening - HA Web locale predisposto):
- `Accredia.SIGAD.Web/Program.cs` aggiornato:
  - supporto key ring condiviso via config/env (`DataProtection:KeysPath` / `DataProtection__KeysPath`);
  - fallback DEV invariato su cartella locale `.keys`.
- `docker-compose.staging.yml` aggiornato:
  - `web` ora monta volume chiavi condivise (`sigad_web_keys`) e usa `DataProtection__KeysPath=/keys`.
- aggiunto stack HA Web locale:
  - `docker-compose.staging.ha.yml` (servizi `web2` + `web-lb`, override `web`),
  - `docker/haproxy/web-ha.cfg` con sticky cookie `WEBNODE` e header diagnostico `X-Web-Node`.
- aggiunto script validazione HA:
  - `scripts/m8_web_ha_validation.ps1`
  - check automatici: web 200 via LB, sticky session cookie-based, key ring condiviso su `web`/`web2`.
- documentazione/checklist aggiornate:
  - `DOCKER_STAGING.md` (sezione validazione HA Web),
  - `M8_RELEASE_CHECKLIST.md` (strategy key ring + validazione HA predisposte),
  - `WORKPLAN_UX_REDESIGN.md` (DONE/TODO M8 allineati).
Aggiornamento 2026-02-19 (M8 hardening - smoke HA Web locale eseguito):
- test eseguito con `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\m8_web_ha_validation.ps1`.
- esiti:
  - web bilanciato via LB `http://localhost:7010` -> `200`;
  - sticky session valida (`WEBNODE`, header `X-Web-Node` stabile tra richieste consecutive);
  - key ring condiviso presente su entrambe le istanze (`web`, `web2`).
- fix operativo applicato durante il test:
  - porta LB spostata a `7010` in `docker-compose.staging.ha.yml` per evitare conflitto con Web standard su `7000`.
- checklist/workplan allineati:
  - `M8_RELEASE_CHECKLIST.md` (smoke HA locale marcato `DONE`),
  - `WORKPLAN_UX_REDESIGN.md` aggiornato con evidenza PASS.
Aggiornamento 2026-02-19 (M8 hardening - gate segreti/env pipeline):
- aggiunto script `scripts/m8_release_env_validation.ps1`:
  - valida variabili obbligatorie (`SQL_SA_PASSWORD`, `JWT_KEY`),
  - segnala placeholder/debolezze,
  - emette warning su variabili consigliate (`DocumentStorage__WebDav__Password`, `DataProtection__KeysPath`).
- checklist/documentazione allineate:
  - `M8_RELEASE_CHECKLIST.md` aggiornato con check automatico predisposto,
  - `DOCKER_STAGING.md` aggiornata (sezione preflight env),
  - `WORKPLAN_UX_REDESIGN.md` aggiornato (DONE/TODO M8).
- esecuzione locale preflight:
  - comando: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\m8_release_env_validation.ps1 -EnvFile .env`
  - esito: `PASS` con warning su variabili consigliate assenti.

Aggiornamento 2026-10-05 (avvio stack DEV con `sigad-start-dev.ps1`, Identity.Api esclusa):
- build soluzione: `OK` (0 errori, 207 warning MudBlazor `MUD0002` su attributi lowercase in `Persone/Dettaglio.razor`).
- anomalie rilevate nello script/configurazione (NON corrette nei file, aggirate a runtime):
  - `sigad-start-dev.ps1` punta a `Accredia.SIGAD.RisorseUmane.Bff` ma la cartella reale e' `Accredia.SIGAD.RisorseUmane.Bff.Api` -> il BFF verrebbe saltato.
  - `launchSettings.json` di RisorseUmane.Api/Bff usano porte 58219/58220 e 58221/58222, mentre Gateway e BFF si aspettano 7004/7005 -> avvio con `--no-launch-profile --urls http://localhost:7004|7005`.
- DB Azure SQL `Accredia_SIDAC` (serverless) in auto-pausa: primo `/health` -> `500` ("database not currently available"), dopo resume -> `200`. Non e' un bug applicativo: riprovare dopo ~1 minuto.
- esito health: Tipologiche 7002, Anagrafiche 7003, RU 7004, RU-BFF 7005, Gateway 7100, Web 7000 -> tutti `200`.
- CORRETTO (2026-10-05): le anomalie sopra sono state sistemate nei file:
  - `sigad-start-dev.ps1`: voce BFF -> `RisorseUmane.Bff.Api`;
  - `RisorseUmane.Api/Properties/launchSettings.json` -> `http://localhost:7004`, `launchBrowser=false`;
  - `RisorseUmane.Bff.Api/Properties/launchSettings.json` -> `http://localhost:7005`, `launchBrowser=false`.
  - verifica: `sigad-start-dev.ps1` senza override -> 6/6 porte attive, health diretti e via Gateway `200`.
  - da valutare: aggiungere RU 7004 / RU-BFF 7005 alla tabella porte di `CLAUDE.md`.

Aggiornamento 2026-10-06 (allineamento shell Web al Portale Accredia):
- replicata in `Accredia.SIGAD.Web` l'impostazione visiva di AppBar e SideBar osservata su `Accredia.Portal` (`/organismi`), mantenendo ricerca globale, profili DEV, autorizzazioni e voci SIGAD;
- AppBar desktop a 80 px e mobile a 64 px; drawer a 280 px espanso e 72 px compatto; aggiunti brand esteso, card profilo e stile coerente delle voci di navigazione;
- verifica Release: build Web completata con 0 errori (209 warning preesistenti); collaudo browser su `http://localhost:7000/organizzazioni` superato per desktop/mobile, toggle drawer, navigazione e assenza di errori console.

Aggiornamento 2026-10-06 (correzione regressioni shell SIGAD):
- rimossi i residui letterali `` `n `` da `GlobalSearch.razor` e `Persone.razor`;
- sidebar mini corretta: testi e intestazioni nascosti, icone disposte in colonna, nessun overflow orizzontale;
- stato attivo corretto evitando il doppio background su wrapper e SVG: pittogramma ocra leggibile su fondo bianco;
- sotto 960 px il drawer chiuso esce completamente dal viewport e non riserva piu' 72 px al contenuto;
- verifica: build Release Web `OK` (0 errori, 209 warning preesistenti), `GET /` -> `200`, collaudo browser desktop/375 px superato.

Aggiornamento 2026-10-06 (diagnosi rallentamento navigazione Web):
- processo `Accredia.SIGAD.Web` precedente rilevato a circa 2,0 GB di working set, pur con CPU a riposo normale; Gateway e health API rispondevano in 2-6 ms;
- riavvio controllato del solo Web: working set iniziale circa 123 MB, stabilizzato a circa 173 MB dopo caricamenti e 15 navigazioni ripetute;
- ciclo Dashboard/Organizzazioni/Persone stabile, senza crescita progressiva della memoria e senza errori browser; la causa osservata era quindi lo stato anomalo del processo/circuiti accumulati, non la latenza del Gateway o del database;
- nessuna modifica applicativa effettuata durante la diagnosi; Web lasciato attivo su porta 7000.
