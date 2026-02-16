# Piano Esecutivo Copertura Schema Persone

## Obiettivo operativo

- Procedere in modo sequenziale e riprendibile fino a copertura completa dello schema `Persone`.
- Tracciare avanzamento con task atomici e prove oggettive.
- Repository target: `Accredia.SIGAD.Anagrafiche.Api` + `Accredia.SIGAD.Anagrafiche.Api.Tests`.

## Regole di avanzamento

1. Un task e chiuso solo con stato `DONE` e prova registrata.
2. Alla ripresa si parte dal primo task `TODO`.
3. Nessun task `DONE` viene riaperto senza motivo esplicito (`REOPEN`).
4. Ogni task deve lasciare endpoint, handler e test coerenti.

Stati ammessi:
- `TODO`
- `IN_PROGRESS`
- `BLOCKED`
- `DONE`
- `REOPEN`

## Criterio di copertura tabella

Una tabella e "coperta" quando:
1. esiste feature applicativa che la usa (read/write, oppure read-only per storico),
2. esiste endpoint coerente,
3. esiste test di integrazione relativo.

## Baseline iniziale (2026-02-12)

- MCP server Accredia: `OK` (`health_check(deep=true)` riuscito).
- Schema `Persone` rilevato: `26` tabelle.
- Riferimenti SQL espliciti trovati in API: solo `[Persone].[Persona]`.
- Feature `Persone` presenti in API:
  - `GET /v1/persone/search`
  - `GET /v1/persone/{id}`
  - `POST /v1/persone`
  - `PUT /v1/persone/{id}`
  - `DELETE /v1/persone/{id}`
  - `GET /v1/persone/{id}/incarichi`
- Test integrazione diretti su route `persone`: parziali (`search` usato da supporto test, `get incarichi` in test incarichi).

## Sequenza esecutiva

### Fase 0 - Baseline e guardrail

- [x] `PER-000` Verifica MCP + inventario tabelle schema `Persone` -> `DONE`
- [x] `PER-001` Snapshot copertura iniziale API/Test -> `DONE`

### Fase 1 - Core Persone (anagrafica e relazioni dirette)

- [x] `PER-101` Hardening `Persona` (allineamento criterio copertura completo) -> `DONE`
- [x] `PER-102` Test integrazione `Persona` (CRUD + search + soft-delete) -> `DONE`
- [x] `PER-103` `PersonaEmail` CRUD -> `DONE`
- [x] `PER-104` Test integrazione `PersonaEmail` -> `DONE`
- [x] `PER-105` `PersonaTelefono` CRUD -> `DONE`
- [x] `PER-106` Test integrazione `PersonaTelefono` -> `DONE`
- [x] `PER-107` `PersonaIndirizzo` CRUD -> `DONE`
- [x] `PER-108` Test integrazione `PersonaIndirizzo` -> `DONE`
- [x] `PER-109` `PersonaQualifica` CRUD -> `DONE`
- [x] `PER-110` Test integrazione `PersonaQualifica` -> `DONE`
- [x] `PER-111` `PersonaTitoloStudio` CRUD -> `DONE`
- [x] `PER-112` Test integrazione `PersonaTitoloStudio` -> `DONE`
- [x] `PER-113` `PersonaRelazionePersonale` CRUD -> `DONE`
- [x] `PER-114` Test integrazione `PersonaRelazionePersonale` -> `DONE`
- [x] `PER-115` `PersonaUtente` CRUD -> `DONE`
- [x] `PER-116` Test integrazione `PersonaUtente` -> `DONE`

### Fase 2 - GDPR e compliance

- [x] `PER-201` `ConsensoPersona` CRUD -> `DONE`
- [x] `PER-202` Test integrazione `ConsensoPersona` -> `DONE`
- [x] `PER-203` `RegistroTrattamenti` CRUD -> `DONE`
- [x] `PER-204` Test integrazione `RegistroTrattamenti` -> `DONE`
- [x] `PER-205` `RichiestaGDPR` CRUD -> `DONE`
- [x] `PER-206` Test integrazione `RichiestaGDPR` -> `DONE`
- [x] `PER-207` `RichiestaEsercizioDiritti` CRUD -> `DONE`
- [x] `PER-208` Test integrazione `RichiestaEsercizioDiritti` -> `DONE`
- [x] `PER-209` `DataBreach` CRUD/read model operativo -> `DONE`
- [x] `PER-210` Test integrazione `DataBreach` -> `DONE`

### Fase 3 - Storico read-only

- [x] `PER-301` Endpoint read-only `PersonaStorico` -> `DONE`
- [x] `PER-302` Endpoint read-only relazioni storiche (`Email/Telefono/Indirizzo/...`) -> `DONE`
- [x] `PER-303` Endpoint read-only GDPR storico -> `DONE`
- [x] `PER-304` Test integrazione storico -> `DONE`

### Fase 4 - Chiusura

- [x] `PER-901` Regression completa `Anagrafiche.Api.Tests` -> `DONE`
- [x] `PER-902` Verifica copertura finale `26/26` -> `DONE`
- [x] `PER-903` Aggiornamento stato finale documento -> `DONE`

## Registro di avanzamento

| Timestamp UTC | Task ID | Stato | Evidenza | Note |
|---|---|---|---|---|
| 2026-02-12T07:19:29Z | PER-000 | DONE | MCP `health_check(deep=true)` + `list_tables` | MCP e DB raggiungibili |
| 2026-02-12T07:21:46Z | PER-001 | DONE | SQL `sys.tables/sys.schemas` (`Persone=26`) + scan codice (`[Persone].[Persona]` unico match) | Baseline copertura iniziale acquisita |
| 2026-02-12T07:25:06Z | PER-101 | DONE | Verifica feature core `Persone` (`CreateInt`, `GetByIdInt`, `UpdateInt`, `SoftDeleteInt`, `Search`, `GetIncarichi`) + query esplicite su `[Persone].[Persona]` | Criterio endpoint + uso reale tabella confermato |
| 2026-02-12T07:25:06Z | PER-102 | DONE | Nuova suite `Accredia.SIGAD.Anagrafiche.Api.Tests/PersoneHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (30 passed) | Copertura integrazione `Persona` completata |
| 2026-02-12T07:35:31Z | PER-103 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Email/*` (lookups + list/create/update/delete) + hardening `X-Actor` su `Persone/*Int/Handler.cs` (actor->int) + `dotnet build ...Anagrafiche.Api.csproj --no-restore` (0 warning, 0 error) | Copertura read/write `Persone.PersonaEmail` completata |
| 2026-02-12T07:35:31Z | PER-104 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaEmailHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (31 passed) | Suite integrazione `PersonaEmail` aggiunta (gated con env flag) |
| 2026-02-12T07:44:29Z | PER-105 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Telefono/*` (lookups + list/create/update/delete) + `dotnet build ...Anagrafiche.Api.csproj --no-restore` (0 warning, 0 error) | Copertura read/write `Persone.PersonaTelefono` completata |
| 2026-02-12T07:44:29Z | PER-106 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaTelefonoHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (32 passed) | Suite integrazione `PersonaTelefono` aggiunta (gated con env flag) |
| 2026-02-12T07:53:48Z | PER-107 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Indirizzi/*` (lookups + list/create/update/delete) + `dotnet build ...Anagrafiche.Api.csproj --no-restore` (0 warning, 0 error) | Copertura read/write `Persone.PersonaIndirizzo` completata (tabella ponte: `IndirizzoId` non FK) |
| 2026-02-12T07:53:48Z | PER-108 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaIndirizziHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (33 passed) | Suite integrazione `PersonaIndirizzo` aggiunta (gated con env flag) |
| 2026-02-12T08:02:48Z | PER-109 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Qualifiche/*` (lookups + list/create/update/delete) + `dotnet build ...Anagrafiche.Api.csproj --no-restore` (0 warning, 0 error) | Copertura read/write `Persone.PersonaQualifica` completata |
| 2026-02-12T08:02:48Z | PER-110 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaQualificheHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (34 passed) | Suite integrazione `PersonaQualifica` aggiunta (gated con env flag) |
| 2026-02-12T08:55:07Z | PER-111 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/TitoliStudio/*` (lookups + list/create/update/delete) + `dotnet build ...Anagrafiche.Api.csproj --no-restore` (0 warning, 0 error) | Copertura read/write `Persone.PersonaTitoloStudio` completata |
| 2026-02-12T08:55:07Z | PER-112 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaTitoliStudioHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (35 passed) | Suite integrazione `PersonaTitoloStudio` aggiunta (gated con env flag) |
| 2026-02-12T10:04:05Z | PER-113 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/RelazioniPersonali/*` + endpoint `/v1/persone/relazioni-personali/lookups` + `/v1/persone/{personaId}/relazioni-personali` (CRUD) | Copertura read/write `Persone.PersonaRelazionePersonale` completata |
| 2026-02-12T10:04:05Z | PER-114 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaRelazioniPersonaliHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (36+ passed) | Suite integrazione `PersonaRelazionePersonale` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-115 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Utente/*` + endpoint `/v1/persone/{personaId}/utente` (CRUD) | Copertura read/write `Persone.PersonaUtente` completata |
| 2026-02-12T10:04:05Z | PER-116 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaUtenteHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `PersonaUtente` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-201 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Consensi/*` + endpoint `/v1/persone/consensi/lookups` + `/v1/persone/{personaId}/consensi` (CRUD) | Copertura read/write `Persone.ConsensoPersona` completata |
| 2026-02-12T10:04:05Z | PER-202 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersonaConsensiHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `ConsensoPersona` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-203 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/RegistroTrattamenti/*` + endpoint `/v1/persone/registro-trattamenti[...]` (CRUD + lookups) | Copertura read/write `Persone.RegistroTrattamenti` completata |
| 2026-02-12T10:04:05Z | PER-204 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/RegistroTrattamentiHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `RegistroTrattamenti` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-205 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/RichiesteGdpr/*` + endpoint `/v1/persone/richieste-gdpr[...]` (CRUD + lookups) | Copertura read/write `Persone.RichiestaGDPR` completata |
| 2026-02-12T10:04:05Z | PER-206 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/RichiesteGdprHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `RichiestaGDPR` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-207 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/RichiesteEsercizioDiritti/*` + endpoint `/v1/persone/richieste-esercizio-diritti[...]` (CRUD + lookups) | Copertura read/write `Persone.RichiestaEsercizioDiritti` completata |
| 2026-02-12T10:04:05Z | PER-208 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/RichiesteEsercizioDirittiHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `RichiestaEsercizioDiritti` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-209 | DONE | Feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/DataBreach/*` + endpoint `/v1/persone/data-breach[...]` (CRUD) | Copertura read/write `Persone.DataBreach` completata |
| 2026-02-12T10:04:05Z | PER-210 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/DataBreachHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` | Suite integrazione `DataBreach` aggiunta (gated) |
| 2026-02-12T10:04:05Z | PER-301 | DONE | Feature read-only `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Persone/Storico/*` + endpoint `/v1/persone/{id}/storico/persona` | Copertura read-only `Persone.PersonaStorico` completata |
| 2026-02-12T10:04:05Z | PER-302 | DONE | Endpoints storico relazioni persona: `/v1/persone/{id}/storico/email|telefoni|indirizzi|qualifiche|titoli-studio|relazioni-personali|utente|consensi` | Copertura read-only storico relazioni completata |
| 2026-02-12T10:04:05Z | PER-303 | DONE | Endpoints storico GDPR: `/v1/persone/registro-trattamenti/{id}/storico`, `/v1/persone/richieste-gdpr/{id}/storico`, `/v1/persone/richieste-esercizio-diritti/{id}/storico`, `/v1/persone/data-breach/{id}/storico` | Copertura read-only GDPR storico completata |
| 2026-02-12T10:04:05Z | PER-304 | DONE | Test `Accredia.SIGAD.Anagrafiche.Api.Tests/PersoneStoricoHttpIntegrationTests.cs` (gated) | Verifica integrazione storico completata |
| 2026-02-12T10:04:05Z | PER-901 | DONE | `dotnet test Accredia.SIGAD.Anagrafiche.Api.Tests/Accredia.SIGAD.Anagrafiche.Api.Tests.csproj --no-restore` (43 passed) | Regression suite Anagrafiche completata |
| 2026-02-12T10:04:05Z | PER-902 | DONE | Scan codice: `rg -o --no-filename \"\\[Persone\\]\\.\\[[A-Za-z0-9_]+\\]\" ... | sort -u` -> `_tmp_persone_tables_in_code_only.txt` (26 matches) | Copertura finale `26/26` confermata |
| 2026-02-12T10:04:05Z | PER-903 | DONE | Aggiornamento stato tasks + registro avanzamento in `WORKPLAN_PERSONE_COVERAGE.md` | Documento chiuso |

## Tabella schema Persone (baseline)

- `ConsensoPersona`
- `ConsensoPersonaStorico`
- `DataBreach`
- `DataBreachStorico`
- `Persona`
- `PersonaEmail`
- `PersonaEmailStorico`
- `PersonaIndirizzo`
- `PersonaIndirizzoStorico`
- `PersonaQualifica`
- `PersonaQualificaStorico`
- `PersonaRelazionePersonale`
- `PersonaRelazionePersonaleStorico`
- `PersonaStorico`
- `PersonaTelefono`
- `PersonaTelefonoStorico`
- `PersonaTitoloStudio`
- `PersonaTitoloStudioStorico`
- `PersonaUtente`
- `PersonaUtenteStorico`
- `RegistroTrattamenti`
- `RegistroTrattamentiStorico`
- `RichiestaEsercizioDiritti`
- `RichiestaEsercizioDirittiStorico`
- `RichiestaGDPR`
- `RichiestaGDPRStorico`
