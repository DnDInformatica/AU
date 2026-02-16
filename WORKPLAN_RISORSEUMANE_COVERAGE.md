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
