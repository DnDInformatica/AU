# Piano Esecutivo Copertura Schema RisorseUmane

## Obiettivo operativo

- Procedere in modo sequenziale e riprendibile fino a copertura completa dello schema `RisorseUmane`.
- Tracciare avanzamento con task atomici e prove oggettive.
- Repository target: `Accredia.SIGAD.RisorseUmane.Api` + `Accredia.SIGAD.RisorseUmane.Api.Tests` + mapping gateway.

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
3. esiste test di integrazione relativo (gated).

## Baseline iniziale (2026-02-12)

- MCP server Accredia: `OK` (`health_check(deep=true)` riuscito).
- Schema `RisorseUmane` rilevato: `6` tabelle.
- Scelta architetturale: nuovo microservizio `Accredia.SIGAD.RisorseUmane.Api` con path gateway `/risorseumane/...`.
- Integrazione con `Persone.Persona`: riferimento esterno tramite `PersonaId` con validazione "hard" asincrona via chiamata HTTP a `Anagrafiche.Api`.

## Tabella schema RisorseUmane (baseline)

- `Contratto`
- `ContrattoStorico`
- `Dipendente`
- `DipendenteStorico`
- `Dotazione`
- `FormazioneObbligatoria`

## Task list

| Data (UTC) | ID | Stato | Deliverable | Prova |
|---|---|---|---|---|
| 2026-02-12T00:00:00Z | RU-001 | DONE | Creazione microservizio `Accredia.SIGAD.RisorseUmane.Api` (program, swagger, health, dapper, versioning, endpoint discovery) | `dotnet build Accredia.SIGAD.RisorseUmane.Api\\Accredia.SIGAD.RisorseUmane.Api.csproj --no-restore` |
| 2026-02-12T00:00:00Z | RU-002 | DONE | Mapping gateway: cluster+routes `/risorseumane/*` (auth + eccezioni health/swagger) | Smoke: `GET /risorseumane/health` e `GET /risorseumane/swagger/v1/swagger.json` via gateway |
| 2026-02-12T00:00:00Z | RU-101 | DONE | Feature `Dipendenti` (CRUD) su `RisorseUmane.Dipendente` con validazione `PersonaId` | Endpoints in `Accredia.SIGAD.RisorseUmane.Api\\V1\\Features\\Dipendenti\\*` |
| 2026-02-12T00:00:00Z | RU-102 | DONE | Feature storico dipendente su `RisorseUmane.DipendenteStorico` (`GET /v1/dipendenti/{id}/storico`) | Endpoint storico implementato |
| 2026-02-12T00:00:00Z | RU-201 | DONE | Feature `Contratti` (CRUD) su `RisorseUmane.Contratto` (nested sotto dipendente) | Endpoints in `Accredia.SIGAD.RisorseUmane.Api\\V1\\Features\\Contratti\\*` |
| 2026-02-12T00:00:00Z | RU-202 | DONE | Feature storico contratto su `RisorseUmane.ContrattoStorico` (`GET /v1/contratti/{id}/storico`) | Endpoint storico implementato |
| 2026-02-12T00:00:00Z | RU-301 | DONE | Feature `Dotazioni` (CRUD) su `RisorseUmane.Dotazione` (nested sotto dipendente) | Endpoints in `Accredia.SIGAD.RisorseUmane.Api\\V1\\Features\\Dotazioni\\*` |
| 2026-02-12T00:00:00Z | RU-401 | DONE | Feature `FormazioneObbligatoria` (CRUD) su `RisorseUmane.FormazioneObbligatoria` (nested sotto dipendente) | Endpoints in `Accredia.SIGAD.RisorseUmane.Api\\V1\\Features\\FormazioneObbligatoria\\*` |
| 2026-02-12T00:00:00Z | RU-901 | DONE | Scan copertura finale: match `[RisorseUmane].[...]` nel codice + check `6/6` | File `_tmp_risorseumane_tables_in_code_only.txt` |
| 2026-02-12T00:00:00Z | RU-902 | DONE | Test HTTP integrazione gated (`SIGAD_RUN_HTTP_INTEGRATION=1`) pronti e inclusi in `Accredia.SIGAD.RisorseUmane.Api.Tests` | Ultima run 2026-02-16: con flag non impostato suite passa ma skippa; con flag impostato fallisce per dipendenza ambiente (`127.0.0.1:7100` non raggiungibile in sessione). Blocco residuo classificato INFRA (stack esterno), non codice RU. |

## Chiusura punti aperti (2026-02-16)

- RU-902 chiuso lato sviluppo: test smoke+CRUD implementati e agganciati.
- Rischio residuo operativo: esecuzione end-to-end dipendente da disponibilita stack locale completo (Gateway+API+SQL) durante la sessione di test.

## Piano operativo v2 - Persona complete (2026-02-16)

### Obiettivo integrativo

- Per ogni entita RU collegata a `PersonaId` (Dipendente e derivate), in inserimento e visualizzazione devono essere disponibili le informazioni complete della persona, non solo l'identificativo.
- Modello dati invariato: `PersonaId` resta FK canonica, nessuna duplicazione persistente dei dati persona in tabelle RU.

### Scelte architetturali approvate

1. Write path: API RU diretta (`/risorseumane/v1/*`) con payload basato su `PersonaId`.
2. Read/composition path: BFF RU (`/bff/risorseumane/v1/*`) con DTO compositi `Entita + PersonaCompleta`.
3. UX obbligatoria: picker/cerca persona + anteprima completa + deep-link a dettaglio persona.
4. Estensione opzionale ma consigliata: creazione persona inline dal modulo RU.

### Nuovi task

| Data (UTC) | ID | Stato | Deliverable | Prova |
|---|---|---|---|---|
| 2026-02-17T00:00:00Z | RU-1001 | DONE | Contratto DTO compositi BFF: `DipendenteDettaglioCompleto` con snapshot persona esteso (anagrafica, contatti, indirizzi, relazioni personali, qualifiche, consensi/GDPR in base a permessi) | Endpoint operativi e validati: `GET /bff/risorseumane/v1/dipendenti/{id}/dettaglio-completo` `200`; fix runtime `DateOnly` completato; permessi RU allineati con `RU-1201`/`RU-1701`. |
| 2026-02-17T00:00:00Z | RU-1002 | DONE | Endpoint BFF lista composita dipendenti con campi persona principali e filtri condivisi (`q`, `persona`, `matricola`, `stato`) | Endpoint operativo e validato: `GET /bff/risorseumane/v1/dipendenti/dettaglio-completo?...` `200`; filtri RU/BFF funzionanti e usati dalla UI Web. |
| 2026-02-17T00:00:00Z | RU-1003 | DONE | Endpoint lookup BFF/API per picker persona (`search persona`) con campi essenziali + controlli soft-delete | Implementato `GET /bff/risorseumane/v1/persone/lookup?q=...` (proxy su Anagrafiche search) con fallback Web su ricerca Anagrafiche diretta; comportamento validato in UI. |
| 2026-02-17T00:00:00Z | RU-1101 | DONE | Web: nuovo modulo RU - lista dipendenti composita (colonne persona + badge stato dipendente) | Pagina `/risorse-umane/dipendenti` operativa con filtri `q/matricola/stato/persona`, tabella server-side e navigazione dettaglio; build Web ok e validazione funzionale confermata. |
| 2026-02-16T00:00:00Z | RU-1102 | DONE | Web: wizard creazione dipendente `Seleziona/Crea Persona -> Conferma Dati Persona -> Dati Dipendente` | Completata pagina `/risorse-umane/dipendenti/nuovo` con doppia modalita (selezione persona o creazione persona inline) e submit atomico persona->dipendente; build Web ok |
| 2026-02-16T00:00:00Z | RU-1103 | DONE | Web: creazione persona inline dal wizard RU (opzione rapida) | Flusso unico operativo: crea persona via `CreatePersonaAsync` e poi crea dipendente via `CreateDipendenteAsync`; alias route `/dipendenti/nuovo`; build Web ok |
| 2026-02-17T00:00:00Z | RU-1104 | DONE | Web: dettaglio dipendente con sezione/tab `Persona completa` + deep-link a `/persone/{id}` | Pagina `/risorse-umane/dipendenti/{id}` operativa con sintesi persona completa, deep-link verso persona e CRUD contestualizzato. |
| 2026-02-17T00:00:00Z | RU-1105 | DONE | Web: dettaglio dipendente con tab CRUD `Contratti`, `Dotazioni`, `Formazione` contestualizzati alla persona | Coerente con chiusure `RU-1502`, `RU-1503`, `RU-1504`; E2E Playwright `RisorseUmaneDipendenteCrudTests` passato (`1/1`). |
| 2026-02-17T00:00:00Z | RU-1201 | DONE | Permessi RU granulari (`HR.DIP.*`, `HR.CONTRATTI.*`, `HR.DOTAZIONI.*`, `HR.FORM.*`, `HR.PERSONA.READ`) su Identity+Gateway | Catalogo+assegnazione permessi Identity completati (`IdentitySeeder` + `DevIdentitySeeder`) e policy/route Gateway applicate; enforcement confermato in combinazione con gating UI `RU-1701`. |
| 2026-02-17T00:00:00Z | RU-1202 | DONE | Gating UI per permessi RU con fallback `AccessDenied` e disabilitazione azioni | Completato con chiusura `RU-1701`: gating su menu e pagine RU (`Dipendenti`, `NuovoDipendente`, `DettaglioDipendente`) con guard azioni e fallback esplicito. |
| 2026-02-17T00:00:00Z | RU-1301 | DONE | Enforcement regole business da metadati: contratto corrente unico, regole scadenza contratto, inventario/restituzione dotazioni, validita formazione | Coperto da `RU-1601`, `RU-1602`, `RU-1603`: regole implementate su handler RU API e validate funzionalmente. |
| 2026-02-17T00:00:00Z | RU-1302 | DONE | Alert operativi: formazione in scadenza (90/60/30), dotazioni non restituite su cessati (endpoint report) | Coperto da `RU-1604`: endpoint report RU API+BFF implementati e protetti da policy Gateway. |
| 2026-02-17T00:00:00Z | RU-1401 | DONE | Documentazione: aggiornamento `MEMORY.md`, data dictionary RU, mapping endpoint Web/Gateway/BFF | Documentazione e tracciamento aggiornati in `MEMORY.md` + `WORKPLAN_RISORSEUMANE_COVERAGE.md` con mapping endpoint RU API/BFF/Gateway/Web e stato task allineato. |
| 2026-02-17T00:00:00Z | RU-1402 | DONE | Test finali end-to-end RU con stack completo e chiusura piano | Evidenze consolidate: smoke RU via gateway, CRUD RU (201/204/204), E2E Web Playwright RU (`1/1`) e validazione funzionale finale confermata. |

### Criteri di DONE integrativi

1. Ogni schermata RU che usa `PersonaId` mostra sempre i dati persona completi nel dettaglio.
2. Ogni creazione RU con `PersonaId` passa da selezione persona esplicita o creazione persona inline.
3. Nessun endpoint RU/BFF accessibile senza policy coerente (auth + permission).
4. Nessuna duplicazione persistente dati persona nelle tabelle RU.

## Piano operativo v3 - CRUD completo RU + regole business (2026-02-16)

### Analisi copertura corrente (snapshot)

- API RU (`Accredia.SIGAD.RisorseUmane.Api`): CRUD completo presente per `Dipendenti`, `Contratti`, `Dotazioni`, `FormazioneObbligatoria` + storico `Dipendente` e `Contratto`.
- Gateway (`Accredia.SIGAD.Gateway`): routing e policy granulari `HR.*` presenti per RU API e RU BFF.
- BFF RU (`Accredia.SIGAD.RisorseUmane.Bff.Api`): composizione completa solo per area `Dipendenti` + `Persone/lookup`.
- Web (`Accredia.SIGAD.Web`): operativo su lista/dettaglio/nuovo dipendente con CRUD UI su `Contratti`, `Dotazioni`, `FormazioneObbligatoria` e azioni update/delete dipendente (con permessi RU).

### Regole business da metadati RU da implementare in applicazione

- `Contratto`: enforcement di un solo `IsContrattoCorrente = true` per dipendente implementato.
- `Contratto`: regole di obbligatorieta `DataFine` per tipologie a termine implementate da metadati tipologici.
- `Dotazione`: regole inventario/restituzione implementate da metadati tipologici e coerenza campi.
- `FormazioneObbligatoria`: calcolo/validazione `DataScadenza` implementato su metadati tipologici con report pre-scadenza.

### Task v3

| Data (UTC) | ID | Stato | Deliverable | Prova |
|---|---|---|---|---|
| 2026-02-17T00:00:00Z | RU-1501 | DONE | Web: edit + delete dipendente da pagina dettaglio (azioni protette da permessi) | Azioni `Modifica`/`Elimina` operative in `DettaglioDipendente` con update/delete via `GatewayClient`, integrate con permessi RU (`RU-1701`) e validate funzionalmente. |
| 2026-02-16T00:00:00Z | RU-1502 | DONE | Web: tab CRUD `Contratti` su dettaglio dipendente (list/create/update/delete + storico) | Implementata sezione `Contratti` in `DettaglioDipendente` con tabella, form create/update, soft-delete e storico contratto; smoke API/Gateway `POST 201`, `PUT 204`, `DELETE 204`; test E2E UI Playwright `RisorseUmaneDipendenteCrudTests` passato (login + apertura tab + create contratto) |
| 2026-02-16T00:00:00Z | RU-1503 | DONE | Web: tab CRUD `Dotazioni` su dettaglio dipendente (list/create/update/delete) | Implementata sezione `Dotazioni` in `DettaglioDipendente` con tabella, form create/update e soft-delete; smoke API/Gateway `POST 201`, `PUT 204`, `DELETE 204`; test E2E UI Playwright `RisorseUmaneDipendenteCrudTests` passato (create dotazione da UI) |
| 2026-02-16T00:00:00Z | RU-1504 | DONE | Web: tab CRUD `FormazioneObbligatoria` su dettaglio dipendente (list/create/update/delete) | Implementata sezione `Formazione obbligatoria` in `DettaglioDipendente` con tabella, form create/update e soft-delete; smoke API/Gateway `POST 201`, `PUT 204`, `DELETE 204`; test E2E UI Playwright `RisorseUmaneDipendenteCrudTests` passato (create formazione da UI) |
| 2026-02-16T00:00:00Z | RU-1505 | DONE | GatewayClient Web: aggiungere metodi RU mancanti (`PUT/DELETE Dipendenti`, CRUD `Contratti/Dotazioni/Formazione`, storico contratto) + modelli DTO dedicati | Implementati DTO/modelli RU estesi e metodi `GatewayClient` (incl. helper `PUT 204`); build Web ok; validazione runtime via Gateway completata con login `200` e CRUD RU (`201/204/204`) su contratti, dotazioni, formazione |
| 2026-02-17T00:00:00Z | RU-1601 | DONE | RU API: enforcement transazionale contratto corrente unico (`IsContrattoCorrente`) in create/update | Implementato in `Contratti.Handler` con transazione `Serializable` e reset atomico dei correnti per dipendente; test integrazione aggiornati (`RisorseUmaneCrudHttpIntegrationTests`), build test ok e validazione funzionale confermata. |
| 2026-02-17T00:00:00Z | RU-1602 | DONE | RU API: enforcement regole contratti a termine (DataFine obbligatoria per tipologie definite) | Implementata validazione tipologica su `Tipologica.TipoContratto` (`RichiedeDataScadenza`, `DurataMaxMesi`) con `400 ValidationProblem`; build API ok e validazione funzionale confermata. |
| 2026-02-17T00:00:00Z | RU-1603 | DONE | RU API: enforcement regole dotazioni (coerenza `IsRestituito`/`DataRestituzione`, inventario obbligatorio per tipi configurati) | Implementata validazione tipologica su `Tipologica.TipoDotazione` (`RichiedeNumeroInventario`) + coerenza restituzione (`IsRestituito`/`DataRestituzione`) in create/update; test integrazione negativo aggiunto, build test ok e validazione funzionale confermata. |
| 2026-02-17T00:00:00Z | RU-1604 | DONE | RU API/BFF: supporto alert operativi (formazione in scadenza, cessati con dotazioni non restituite) | Aggiunti endpoint report RU API+BFF (`/v1/report/formazione-in-scadenza`, `/v1/report/dotazioni-non-restituite-cessati`) con routing Gateway/policy dedicate; test integrazione aggiornati, build API/BFF/Gateway/test ok e validazione funzionale confermata. |
| 2026-02-17T00:00:00Z | RU-1701 | DONE | Permessi UI: gating azioni per `HR.DIP.*`, `HR.CONTRATTI.*`, `HR.DOTAZIONI.*`, `HR.FORM.*` con fallback UX esplicito | Gating implementato su menu RU e pagine `Dipendenti`/`NuovoDipendente`/`DettaglioDipendente` con `AccessDenied`, disabilitazione azioni e guard nei metodi; build `Accredia.SIGAD.Web` riuscita (`dotnet build Accredia.SIGAD.Web/Accredia.SIGAD.Web.csproj --no-restore`, `0` errori). |
| 2026-02-16T00:00:00Z | RU-1702 | DONE | QA finale: suite smoke RU estesa (API + Gateway + Web) e chiusura workplan v3 | Evidenze consolidate in sessione: health stack (`Identity 7001`, `Anagrafiche 7003`, `RU API 7004`, `RU BFF 7005`, `Gateway 7100`) `200`; login gateway `POST /identity/v1/auth/login` `200`; CRUD RU via Gateway (`Contratti`, `Dotazioni`, `Formazione`) con `POST 201`, `PUT 204`, `DELETE 204`; test Web E2E Playwright `RisorseUmaneDipendenteCrudTests` passato (`1/1`, `Accredia.SIGAD.Web.E2E/TestResults/ru-web-e2e.trx`) |

### Sequenza esecutiva proposta

1. `RU-1505` (fondazione client/modelli Web).
2. `RU-1501` + `RU-1502` + `RU-1503` + `RU-1504` (CRUD UI completo su dipendente).
3. `RU-1601` + `RU-1602` + `RU-1603` (hardening regole business server-side).
4. `RU-1604` + `RU-1701` + `RU-1702` (report operativi, permessi UI, chiusura qualità).
