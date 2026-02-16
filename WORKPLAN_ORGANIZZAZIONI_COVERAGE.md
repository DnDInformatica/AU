# Piano Esecutivo Copertura Schema Organizzazioni

## Obiettivo operativo

- Procedere in modo sequenziale e riprendibile fino a copertura completa dello schema `Organizzazioni`.
- Evitare rielaborazioni: ogni task ha ID, stato e prova di chiusura.
- Repository target: `Accredia.SIGAD.Anagrafiche.Api` + `Accredia.SIGAD.Anagrafiche.Api.Tests`.

## Regole di avanzamento (anti-riterazione)

1. Un task si considera chiuso solo con stato `DONE` e prova registrata.
2. A ogni interruzione/ripresa si riparte dal primo task `TODO` in ordine.
3. Nessun task `DONE` viene riaperto senza motivo esplicito (`REOPEN`).
4. Le modifiche sono atomiche: un commit (o blocco logico) per task.
5. Aggiornare sempre la sezione `Registro di avanzamento` prima di fermarsi.

Stati ammessi:
- `TODO`
- `IN_PROGRESS`
- `BLOCKED`
- `DONE`
- `REOPEN`

## Criterio di completamento tabella

Una tabella e "coperta" quando:
1. esiste almeno una feature applicativa che la usa in read/write (o read-only se storico),
2. esiste endpoint coerente,
3. esiste test di integrazione relativo.

## Sequenza esecutiva (ordine vincolante)

### Fase 0 - Baseline e guardrail

- [x] `ORG-000` Stato iniziale copertura (snapshot 4/34) -> `DONE`
- [x] `ORG-001` Template test integrazione riusabile per nuove feature -> `DONE`
- [x] `ORG-002` Checkpoint sicurezza/logging su nuove route -> `DONE`

### Snapshot baseline (ORG-000)

- Timestamp baseline: `2026-02-11T14:44:03Z`
- Tabelle schema `Organizzazioni` rilevate: `34`
- Tabelle coperte da codice API: `4` (`Organizzazione`, `UnitaOrganizzativa`, `Sede`, `Incarico`)
- Comandi/evidenze:
  - SQL MCP: `SELECT t.name AS TableName FROM sys.tables t JOIN sys.schemas s ON s.schema_id = t.schema_id WHERE s.name = 'Organizzazioni'`
  - Scan codice: ricerca pattern `\[Organizzazioni\]\.\[<Tabella>\]` su `Accredia.SIGAD.Anagrafiche.Api`

### Fase 1 - P1 Core

- [x] `ORG-101` `OrganizzazioneTipoOrganizzazione` read/write endpoint -> `DONE`
- [x] `ORG-102` Test integrazione `Tipologie` -> `DONE`
- [x] `ORG-103` `OrganizzazioneSede` link/unlink/list -> `DONE`
- [x] `ORG-104` Test integrazione `OrganizzazioneSede` -> `DONE`
- [x] `ORG-105` `OrganizzazioneIdentificativoFiscale` CRUD -> `DONE`
- [x] `ORG-106` Test integrazione `Identificativi` -> `DONE`

### Fase 2 - P1 Struttura UO

- [x] `ORG-201` `UnitaRelazione` CRUD -> `DONE`
- [x] `ORG-202` Test integrazione `UnitaRelazione` -> `DONE`
- [x] `ORG-203` `UnitaOrganizzativaFunzione` CRUD -> `DONE`
- [x] `ORG-204` Test integrazione `UnitaOrganizzativaFunzione` -> `DONE`
- [x] `ORG-205` `ContattoUnitaOrganizzativa` CRUD -> `DONE`
- [x] `ORG-206` Test integrazione `ContattoUnitaOrganizzativa` -> `DONE`
- [x] `ORG-207` `IndirizzoUnitaOrganizzativa` CRUD -> `DONE`
- [x] `ORG-208` Test integrazione `IndirizzoUnitaOrganizzativa` -> `DONE`
- [x] `ORG-209` `SedeUnitaOrganizzativa` link/unlink/list -> `DONE`
- [x] `ORG-210` Test integrazione `SedeUnitaOrganizzativa` -> `DONE`

### Fase 3 - P2 Estensioni dominio

- [x] `ORG-301` `Competenza` CRUD -> `DONE`
- [x] `ORG-302` Test integrazione `Competenza` -> `DONE`
- [x] `ORG-303` `Potere` CRUD -> `DONE`
- [x] `ORG-304` Test integrazione `Potere` -> `DONE`
- [x] `ORG-305` `GruppoIVA` CRUD -> `DONE`
- [x] `ORG-306` `GruppoIVAMembri` CRUD -> `DONE`
- [x] `ORG-307` Test integrazione `GruppoIVA/GruppoIVAMembri` -> `DONE`
- [x] `ORG-308` `UnitaAttivita` CRUD -> `DONE`
- [x] `ORG-309` Test integrazione `UnitaAttivita` -> `DONE`

### Fase 4 - P3 Storico read-only

- [x] `ORG-401` Endpoint read-only storico `OrganizzazioneStorico` -> `DONE`
- [x] `ORG-402` Endpoint read-only storico `UnitaOrganizzativaStorico` -> `DONE`
- [x] `ORG-403` Endpoint read-only storico `SedeStorico` -> `DONE`
- [x] `ORG-404` Endpoint read-only storico `IncaricoStorico` -> `DONE`
- [x] `ORG-405` Endpoint read-only storico relazioni/bridge -> `DONE`
- [x] `ORG-406` Endpoint read-only storico attributi (`CompetenzaStorico`, `PotereStorico`, ecc.) -> `DONE`
- [x] `ORG-407` Test integrazione storico -> `DONE`

### Fase 5 - Chiusura programma

- [x] `ORG-901` Regression completa `Anagrafiche.Api.Tests` -> `DONE`
- [x] `ORG-902` Verifica copertura finale 34/34 -> `DONE`
- [x] `ORG-903` Aggiornamento documento stato finale -> `DONE`

## Registro di avanzamento

Compilare una riga per ogni task completato o bloccato.

| Timestamp UTC | Task ID | Stato | Evidenza (file/test/comando) | Note |
|---|---|---|---|---|
| 2026-02-11T14:44:03Z | ORG-000 | DONE | MCP SQL `sys.tables/sys.schemas` + scan codice `[Organizzazioni].[Table]` (`coveredCount=4`, `total=34`) | Baseline iniziale confermata |
| 2026-02-11T14:46:12Z | ORG-001 | DONE | `Accredia.SIGAD.Anagrafiche.Api.Tests/IntegrationTestSupport.cs` + refactor `Accredia.SIGAD.Anagrafiche.Api.Tests/IncarichiHttpIntegrationTests.cs` + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (12 passed) | Template test HTTP riusabile introdotto |
| 2026-02-11T14:46:12Z | ORG-002 | DONE | Scan logging/sensibili su `Accredia.SIGAD.Anagrafiche.Api` (`rg` su logger/log/secret/password/token), evidenza di logging centralizzato in `Program.cs` | Checkpoint sicurezza baseline completato |
| 2026-02-11T14:51:46Z | ORG-101 | DONE | Refactor bridge-first tipologie in `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GetTipologie/Handler.cs` e `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SetTipologie/Handler.cs`; build API su output dedicato (`dotnet build ... -p:OutputPath=C:\\Accredia\\Sviluppo\\AU\\_tmpbuild\\anagrafiche-api -p:UseAppHost=false`) | Allineamento tabella ponte + fallback legacy |
| 2026-02-11T14:51:46Z | ORG-102 | DONE | Nuovi test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniTipologieHttpIntegrationTests.cs`; `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (14 passed) | Suite tipologie aggiunta (gated con env flag) |
| 2026-02-11T14:51:46Z | ORG-103 | IN_PROGRESS | Analisi schema `Organizzazioni.OrganizzazioneSede` (27 colonne) + verifica feature esistenti `Sedi*` su tabella `Sede` | Pianificata implementazione `list/link/unlink` dedicata |
| 2026-02-11T20:16:50Z | ORG-103 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SediLink/*` con endpoint versionati `GET/POST/DELETE /v1/organizzazioni/{orgId}/sedi-link` | Copertura read/write tabella `Organizzazioni.OrganizzazioneSede` completata |
| 2026-02-11T20:16:50Z | ORG-104 | DONE | Nuovi test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniSediLinkHttpIntegrationTests.cs`; `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (16 passed) | Suite integrazione `OrganizzazioneSede` aggiunta (gated con env flag) |
| 2026-02-11T20:22:00Z | ORG-105 | DONE | Bridge-first su `GetIdentificativi` + nuovi endpoint CRUD `IdentificativiCreate/*`, `IdentificativiUpdate/*`, `IdentificativiDelete/*` | Copertura read/write tabella `Organizzazioni.OrganizzazioneIdentificativoFiscale` completata |
| 2026-02-11T20:22:00Z | ORG-106 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniIdentificativiHttpIntegrationTests.cs`; `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (17 passed) | Suite integrazione identificativi aggiunta (gated con env flag) |
| 2026-02-11T20:26:49Z | ORG-201 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaRelazioni/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/unita-relazioni` | Copertura read/write tabella `Organizzazioni.UnitaRelazione` completata |
| 2026-02-11T20:26:49Z | ORG-202 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniUnitaRelazioniHttpIntegrationTests.cs`; `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (18 passed) | Suite integrazione `UnitaRelazione` aggiunta (gated con env flag) |
| 2026-02-11T20:32:19Z | ORG-203 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaFunzioni/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/unita-funzioni` | Copertura read/write tabella `Organizzazioni.UnitaOrganizzativaFunzione` completata |
| 2026-02-11T20:32:19Z | ORG-204 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniUnitaFunzioniHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (19 passed) | Suite integrazione `UnitaOrganizzativaFunzione` aggiunta (gated con env flag) |
| 2026-02-11T20:37:17Z | ORG-205 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaContatti/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/unita-contatti` | Copertura read/write tabella `Organizzazioni.ContattoUnitaOrganizzativa` completata |
| 2026-02-11T20:37:17Z | ORG-206 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniUnitaContattiHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (20 passed) | Suite integrazione `ContattoUnitaOrganizzativa` aggiunta (gated con env flag) |
| 2026-02-11T20:41:38Z | ORG-207 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaIndirizzi/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/unita-indirizzi` | Copertura read/write tabella `Organizzazioni.IndirizzoUnitaOrganizzativa` completata |
| 2026-02-11T20:41:38Z | ORG-208 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniUnitaIndirizziHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (21 passed) | Suite integrazione `IndirizzoUnitaOrganizzativa` aggiunta (gated con env flag) |
| 2026-02-11T20:46:16Z | ORG-209 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SediUnita/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/sedi-unita` | Copertura read/write tabella `Organizzazioni.SedeUnitaOrganizzativa` completata |
| 2026-02-11T20:46:16Z | ORG-210 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniSediUnitaHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (22 passed) | Suite integrazione `SedeUnitaOrganizzativa` aggiunta (gated con env flag) |
| 2026-02-11T20:55:42Z | ORG-301 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Competenze/*` con endpoint versionati CRUD su `/v1/organizzazioni/competenze` | Copertura read/write tabella `Organizzazioni.Competenza` completata |
| 2026-02-11T20:55:42Z | ORG-302 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniCompetenzeHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (23 passed) | Suite integrazione `Competenza` aggiunta (gated con env flag) |
| 2026-02-11T21:00:03Z | ORG-303 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Poteri/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/poteri` | Copertura read/write tabella `Organizzazioni.Potere` completata |
| 2026-02-11T21:00:03Z | ORG-304 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniPoteriHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (24 passed) | Suite integrazione `Potere` aggiunta (gated con env flag) |
| 2026-02-11T21:07:05Z | ORG-305 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GruppiIva/*` con endpoint versionati CRUD su `/v1/organizzazioni/gruppi-iva` | Copertura read/write tabella `Organizzazioni.GruppoIVA` completata |
| 2026-02-11T21:07:05Z | ORG-306 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GruppiIvaMembri/*` con endpoint versionati CRUD su `/v1/organizzazioni/gruppi-iva/{gruppoIvaId}/membri` | Copertura read/write tabella `Organizzazioni.GruppoIVAMembri` completata |
| 2026-02-11T21:07:05Z | ORG-307 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniGruppiIvaHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (25 passed) | Suite integrazione GruppoIVA/Membri aggiunta (gated con env flag) |
| 2026-02-11T21:11:22Z | ORG-308 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaAttivita/*` con endpoint versionati CRUD su `/v1/organizzazioni/{id}/unita-attivita` | Copertura read/write tabella `Organizzazioni.UnitaAttivita` completata |
| 2026-02-11T21:11:22Z | ORG-309 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniUnitaAttivitaHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (26 passed) | Suite integrazione `UnitaAttivita` aggiunta (gated con env flag) |
| 2026-02-12T06:54:44Z | ORG-401 | DONE | Nuova feature `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Storico/*` con endpoint read-only `/v1/organizzazioni/{id}/storico/organizzazione` | Copertura storico `OrganizzazioneStorico` completata |
| 2026-02-12T06:54:44Z | ORG-402 | DONE | Endpoint read-only `/v1/organizzazioni/{id}/storico/unita-organizzative` | Copertura storico `UnitaOrganizzativaStorico` completata |
| 2026-02-12T06:54:44Z | ORG-403 | DONE | Endpoint read-only `/v1/organizzazioni/{id}/storico/sedi` | Copertura storico `SedeStorico` completata |
| 2026-02-12T06:54:44Z | ORG-404 | DONE | Endpoint read-only `/v1/organizzazioni/{id}/storico/incarichi` | Copertura storico `IncaricoStorico` completata |
| 2026-02-12T06:54:44Z | ORG-405 | DONE | Endpoint read-only `/v1/organizzazioni/{id}/storico/relazioni` (bridge/relazioni: `OrganizzazioneTipoOrganizzazioneStorico`, `OrganizzazioneSedeStorico`, `UnitaRelazioneStorico`, `UnitaOrganizzativaFunzioneStorico`, `SedeUnitaOrganizzativaStorico`, `GruppoIVAStorico`, `GruppoIVAMembriStorico`) | Copertura storico relazioni completata |
| 2026-02-12T06:54:44Z | ORG-406 | DONE | Endpoint read-only `/v1/organizzazioni/{id}/storico/attributi` (`OrganizzazioneIdentificativoFiscaleStorico`, `ContattoUnitaOrganizzativaStorico`, `IndirizzoUnitaOrganizzativaStorico`, `CompetenzaStorico`, `PotereStorico`, `UnitaAttivitaStorico`) | Copertura storico attributi completata |
| 2026-02-12T06:54:44Z | ORG-407 | DONE | Nuovo test `Accredia.SIGAD.Anagrafiche.Api.Tests/OrganizzazioniStoricoHttpIntegrationTests.cs`; `dotnet build ...Anagrafiche.Api.csproj --no-restore -p:UseAppHost=false` (0 warning, 0 error) + `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet test ...Anagrafiche.Api.Tests.csproj --no-restore` (27 passed) | Suite integrazione storico aggiunta (gated con env flag) |
| 2026-02-12T06:56:13Z | ORG-901 | DONE | `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 dotnet test .\\Accredia.SIGAD.Anagrafiche.Api.Tests\\Accredia.SIGAD.Anagrafiche.Api.Tests.csproj --no-restore` (27 passed) | Regressione completa suite integrazione Anagrafiche eseguita |
| 2026-02-12T06:56:13Z | ORG-902 | DONE | Verifica copertura tabella operativa: `ROWS=34;DONE=34`; verifica schema via MCP `list_tables` (34 tabelle in schema `Organizzazioni`) | Copertura finale 34/34 confermata |
| 2026-02-12T06:56:13Z | ORG-903 | DONE | Aggiornamento finale `WORKPLAN_ORGANIZZAZIONI_COVERAGE.md` con chiusura Fasi 4/5 e tutti task in stato `DONE` | Documento stato finale aggiornato |
|  |  |  |  |  |

## Tabella di copertura (fonte verita operativa)

| Tabella | Priorita | Task implementazione | Task test | Stato |
|---|---|---|---|---|
| Organizzazione | P0 | n/a (gia coperta) | hardening in `ORG-901` | DONE |
| UnitaOrganizzativa | P0 | n/a (gia coperta) | hardening in `ORG-901` | DONE |
| Sede | P0 | n/a (gia coperta) | hardening in `ORG-901` | DONE |
| Incarico | P0 | n/a (gia coperta) | hardening in `ORG-901` | DONE |
| OrganizzazioneTipoOrganizzazione | P1 | `ORG-101` | `ORG-102` | DONE |
| OrganizzazioneSede | P1 | `ORG-103` | `ORG-104` | DONE |
| OrganizzazioneIdentificativoFiscale | P1 | `ORG-105` | `ORG-106` | DONE |
| UnitaRelazione | P1 | `ORG-201` | `ORG-202` | DONE |
| UnitaOrganizzativaFunzione | P1 | `ORG-203` | `ORG-204` | DONE |
| ContattoUnitaOrganizzativa | P1 | `ORG-205` | `ORG-206` | DONE |
| IndirizzoUnitaOrganizzativa | P1 | `ORG-207` | `ORG-208` | DONE |
| SedeUnitaOrganizzativa | P1 | `ORG-209` | `ORG-210` | DONE |
| Competenza | P2 | `ORG-301` | `ORG-302` | DONE |
| Potere | P2 | `ORG-303` | `ORG-304` | DONE |
| GruppoIVA | P2 | `ORG-305` | `ORG-307` | DONE |
| GruppoIVAMembri | P2 | `ORG-306` | `ORG-307` | DONE |
| OrganizzazioneStorico | P3 | `ORG-401` | `ORG-407` | DONE |
| UnitaOrganizzativaStorico | P3 | `ORG-402` | `ORG-407` | DONE |
| SedeStorico | P3 | `ORG-403` | `ORG-407` | DONE |
| IncaricoStorico | P3 | `ORG-404` | `ORG-407` | DONE |
| GruppoIVAMembriStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| UnitaAttivitaStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| UnitaOrganizzativaFunzioneStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| UnitaRelazioneStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| IndirizzoUnitaOrganizzativaStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| ContattoUnitaOrganizzativaStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| CompetenzaStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| OrganizzazioneSedeStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| PotereStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| OrganizzazioneTipoOrganizzazioneStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| GruppoIVAStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| OrganizzazioneIdentificativoFiscaleStorico | P3 | `ORG-406` | `ORG-407` | DONE |
| SedeUnitaOrganizzativaStorico | P3 | `ORG-405` | `ORG-407` | DONE |
| UnitaAttivita | P1 | `ORG-308` | `ORG-309` | DONE |

## File target per fase

Fase 1:
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SetTipologie/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GetTipologie/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SediLink/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Identificativi*/*`
- `Accredia.SIGAD.Anagrafiche.Api.Tests/*Tipologie*`
- `Accredia.SIGAD.Anagrafiche.Api.Tests/*SediLink*`
- `Accredia.SIGAD.Anagrafiche.Api.Tests/*Identificativi*`

Fase 2:
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaRelazioni/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaFunzioni/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaContatti/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaIndirizzi/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/SediUnita/*`

Fase 3:
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Competenze/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/Poteri/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GruppiIva/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/GruppiIvaMembri/*`
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/UnitaAttivita/*`

Fase 4:
- `Accredia.SIGAD.Anagrafiche.Api/V1/Features/Organizzazioni/*History/*`
- `Accredia.SIGAD.Anagrafiche.Api.Tests/*History*`

## Protocollo di ripresa

Alla ripartenza:

1. Aprire questo file.
2. Leggere `Registro di avanzamento` dall'ultima riga.
3. Individuare il primo task in stato `TODO` nella `Sequenza esecutiva`.
4. Impostarlo a `IN_PROGRESS`.
5. A chiusura, passare a `DONE` e registrare evidenza.
6. Fermarsi solo dopo aver aggiornato il registro.

## Evidenze minime per chiudere un task

Usare almeno una di queste prove:

1. file path modificati,
2. test singolo o suite eseguita,
3. query/endpoint verificato.

## Definition of Done per task

1. Endpoint versionato con DTO request/response.
2. Validazione input completa (`Validator`).
3. Handler async con query parametrizzate.
4. Codici HTTP coerenti (`200/201/204/400/401/403/404/409/422`).
5. Test integrazione HTTP verdi + regressione SQL dove necessario.
6. Nessun warning in build del progetto toccato.
7. Nessun log di segreti/token.
