# WORKPLAN - Tipologiche (Schema DB: Tipologica)

Data: 2026-02-12

## Obiettivo
Verificare (e completare) la copertura delle tabelle "tipologiche" usate trasversalmente (Organizzazioni, Persone, RisorseUmane, ecc.) mantenendo una logica a microservizi.

Nota importante: nel DB lo schema e' **`Tipologica`** (singolare). La richiesta "Tipologiche" la trattiamo come "servizio Tipologiche.Api che espone dati dallo schema Tipologica".

## Baseline (fonte: MCP Accredia / DB)
- Schema `Tipologica`: **76** tabelle totali
- Tabelle non-storico: **39**
- Tabelle `*Storico`: **37**

## Strategia Architetturale
- `Tipologiche.Api` espone lookup **read-only** per le tipologie correnti (non-storico).
- Le tabelle `*Storico` restano **non esposte** via API (audit/temporal/storicizzazione) salvo necessita' esplicita.
- Le 2 tabelle di mapping (senza colonne descrittive) hanno endpoint dedicati.

## Copertura Attuale
### 1) Lookup generico (copre 37/39 tabelle non-storico)
Endpoint:
- `GET /v1/lookups` (elenco tipi disponibili)
- `GET /v1/lookups/{name}` (paginato + filtro `q`, `includeInactive`, `includeDeleted`)

Copre le seguenti 37 tabelle (schema `Tipologica`, non-storico):
- `CodiceStatoAttivita`
- `DipartimentoAccredia`
- `EnteRilascioQualifica`
- `EsitoMonitoraggio`
- `LivelloTitoloStudio`
- `StatoDipendente`
- `StatoIspettore`
- `TipoCodiceNaturaGiuridica`
- `TipoCompetenzaIspettore`
- `TipoContatto`
- `TipoContratto`
- `TipoDirittoGDPR`
- `TipoDirittoInteressato`
- `TipoDotazione`
- `TipoEmail`
- `TipoEventoRegolatorio`
- `TipoFinalitaTrattamento`
- `TipoFormazioneObbligatoria`
- `TipoFunzioneUnitaLocale`
- `TipoIncompatibilita`
- `TipoIndirizzo`
- `TipoOrganismo`
- `TipoOrganizzazione`
- `TipoOrganizzazioneSede`
- `TipoPotere`
- `TipoProvvedimento`
- `TipoQualifica`
- `TipoRelazionePersonale`
- `TipoRuolo`
- `TipoRuoloIspettore`
- `TipoSede`
- `TipoSistemaFormativo`
- `TipoTelefono`
- `TipoTitoloStudio`
- `TipoUnitaOrganizzativa`
- `TipoUnitaOrganizzativaCategoria`
- `TitoloOnorifico`

### 2) Mapping dedicati (coprono le 2 tabelle non-storico restanti)
Endpoint (nuovi):
- `GET /v1/mappings/categoria-sede`
  - Tabella: `Tipologica.MappingCategoriaSede`
- `GET /v1/mappings/tipo-sede-indirizzo`
  - Tabella: `Tipologica.MappingTipoSedeIndirizzo`

### 3) Storico (37 tabelle)
Scelte come **eccezione architetturale**: presenti nel DB, **non esposte** via `Tipologiche.Api` per ora.
Elenco:
- `CodiceStatoAttivitaStorico`
- `DipartimentoAccreditaStorico`
- `EnteRilascioQualificaStorico`
- `EsitoMonitoraggioStorico`
- `LivelloTitoloStudioStorico`
- `StatoDipendenteStorico`
- `StatoIspettoreStorico`
- `TipoCodiceNaturaGiuridicaStorico`
- `TipoCompetenzaIspettoreStorico`
- `TipoContattoStorico`
- `TipoContrattoStorico`
- `TipoDirittoGDPRStorico`
- `TipoDirittoInteressatoStorico`
- `TipoDotazioneStorico`
- `TipoEmailStorico`
- `TipoEventoRegolatorioStorico`
- `TipoFinalitaTrattamentoStorico`
- `TipoFormazioneObbligatoriaStorico`
- `TipoFunzioneUnitaLocaleStorico`
- `TipoIncompatibilitaStorico`
- `TipoIndirizzoStorico`
- `TipoOrganismoStorico`
- `TipoOrganizzazioneSedeStorico`
- `TipoOrganizzazioneStorico`
- `TipoPotereStorico`
- `TipoProvvedimentoStorico`
- `TipoQualificaStorico`
- `TipoRelazionePersonaleStorico`
- `TipoRuoloIspettoreStorico`
- `TipoRuoloStorico`
- `TipoSedeStorico`
- `TipoSistemaFormativoStorico`
- `TipoTelefonoStorico`
- `TipoTitoloStudioStorico`
- `TipoUnitaOrganizzativaCategoriaStorico`
- `TipoUnitaOrganizzativaStorico`
- `TitoloOnorificoStorico`

## Gateway (Swagger/Health)
Nel Gateway i path sono mappati con `PathRemovePrefix`, quindi Swagger UI deve usare endpoint relativi.
`UseSigadVersionedSwagger()` gia' configura: `SwaggerEndpoint("v1/swagger.json", ...)` (relativo), quindi funziona anche dietro `/tipologiche/swagger/...`.

## Stato Task
- [x] Inventario DB schema `Tipologica` via MCP
- [x] Lookup generico per 37 tabelle (non-storico, con PK singola + colonna descrittiva)
- [x] Endpoint dedicati per i 2 mapping
- [x] Decidere se esporre anche le tabelle `*Storico` (decisione finale: **no**, restano non esposte)
- [x] Aggiungere test di integrazione sugli endpoint tipologiche (`Accredia.SIGAD.Tipologiche.Api.Tests`)

## Chiusura punti aperti (2026-02-16)

- Decisione architetturale `*Storico` formalizzata: esclusione confermata salvo nuova richiesta esplicita.
- Test HTTP integrazione presenti e pronti; ultima run con `SIGAD_RUN_HTTP_INTEGRATION=1` fallita per `127.0.0.1:7100` non raggiungibile in sessione (dipendenza stack/infra), non per regressione endpoint Tipologiche.
