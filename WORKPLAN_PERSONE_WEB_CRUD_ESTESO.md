# WORKPLAN - Persone Web CRUD Esteso (API -> Gateway -> Web)

Data: 2026-02-16
Owner: SIGAD Web / Anagrafiche

## Obiettivo

Portare in `Accredia.SIGAD.Web` la gestione CRUD completa delle entita Persone gia implementate in `Accredia.SIGAD.Anagrafiche.Api`, con priorita su:

1. Persone
2. Relazioni personali (`Persone/RelazioniPersonali`)
3. GDPR con focus iniziale su `RichiesteGdpr`

## Decisioni operative confermate

- Priorita: **Persone first**
- Mapping relazioni: **Relazioni personali** (`/v1/persone/{personaId}/relazioni-personali`)
- UX strategy: **ibrida**
  - Tab in `Persone/Dettaglio` per moduli leggeri/frequenti (indirizzi, qualifiche, relazioni, titoli, consensi)
  - Pagine dedicate per moduli complessi/voluminosi GDPR (partendo da Richieste GDPR) con filtri, tabella, dettaglio/edit

## Stato attuale (audit sintetico)

### API Persone
- CRUD completo disponibile su: indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente, registro trattamenti, richieste GDPR, richieste esercizio diritti, data breach.
- Storico read-only disponibile anche per relazioni e moduli GDPR.

### Gateway
- Routing gia pronto via catch-all `/anagrafiche/{**catch-all}` (nessun blocco strutturale).

### Web
- Gia presenti: Persona base CRUD, email/telefoni CRUD, incarichi read, storico base (persona/email/telefoni).
- Mancanti in GatewayClient + UI: indirizzi, qualifiche, relazioni personali, titoli studio, consensi, utente, GDPR (incluso Richieste GDPR), storico esteso.

## Piano esecutivo

## Fase P0 - Contratti Web (GatewayClient + DTO)

Obiettivo: allineare il client Web al perimetro API Persone.

Task:
- [x] Aggiungere DTO Web per moduli Persone mancanti (core + Richieste GDPR + storico esteso prioritario).
- [x] Estendere `GatewayClient` con metodi CRUD + lookups per:
  - indirizzi
  - qualifiche
  - relazioni personali
  - titoli studio
  - consensi
  - utente
  - richieste GDPR (priorita 1 GDPR)
- [x] Completare backlog immediato `GatewayClient` per: registro trattamenti, richieste esercizio diritti, data breach.
- [x] Aggiungere metodi storico esteso (indirizzi/qualifiche/titoli/relazioni/consensi/utente/richieste-gdpr).
- [x] Aggiungere storico GDPR restante (registro trattamenti, richieste esercizio diritti, data breach).

Criteri di accettazione:
- Build Web pulita.
- Tutti i nuovi endpoint Persone invocabili dal Web client con `ApiResult` coerente.

## Fase P1 - UI Persone: moduli core nel Dettaglio

Obiettivo: completare il CRUD Persone ad alta frequenza in una UX rapida.

Task:
- [x] Nuovo tab `Indirizzi` (lista + create/edit/delete + lookups).
- [x] Nuovo tab `Qualifiche` (lista + CRUD + lookups).
- [x] Nuovo tab `Relazioni personali` (lista + CRUD + lookups).
- [x] Nuovo tab `Titoli studio` (lista + CRUD + lookups).
- [x] Nuovo tab `Consensi` (lista + CRUD + lookups).
- [x] Nuovo tab `Utente` (vista + create/update/delete).

Criteri di accettazione:
- Pattern uniforme loading/empty/error.
- Soft delete coerente con API.
- Re-render esplicito post-operazioni async (`InvokeAsync(StateHasChanged)`).

## Fase P2 - GDPR: Richieste GDPR (priorita)

Obiettivo: mettere in esercizio il modulo GDPR prioritario senza sovraccaricare il dettaglio persona.

Task:
- [x] Pagina dedicata `Richieste GDPR` con:
  - ricerca/lista paginata
  - create/edit/delete
  - dettaglio record
  - filtri minimi (stato, tipo richiesta, persona, date)
- [x] Deep link dal dettaglio persona (tab GDPR) verso lista filtrata per `personaId`.
- [x] Lookups integrati da API.

Criteri di accettazione:
- Flusso end-to-end completo CRUD su Richieste GDPR.
- UX compatibile con shell attuale e performance accettabile.

## Fase P3 - Storico esteso Persone

Obiettivo: visibilita audit completa per i moduli attivati.

Task:
- [x] Estendere tab `Storico eventi` in `Persone/Dettaglio` con nuove sezioni:
  - indirizzi
  - qualifiche
  - relazioni personali
  - titoli studio
  - consensi
  - utente
  - richieste GDPR

Criteri di accettazione:
- Dati storico caricati on-demand.
- Error handling per endpoint non disponibili senza bloccare la pagina.

## Fase P4 - Backlog GDPR restante

Obiettivo: completare il perimetro compliance dopo Richieste GDPR.

Task:
- [x] Registro Trattamenti (CRUD + UI dedicata o tab evoluto).
- [x] Richieste Esercizio Diritti (CRUD).
- [x] Data Breach (CRUD).

## Rischi e mitigazioni

- Rischio: dettaglio persona troppo pesante con troppi tab.
  - Mitigazione: strategia ibrida (tab per moduli leggeri, pagine dedicate per GDPR).
- Rischio: regressioni su moduli gia operativi (email/telefoni/incarichi).
  - Mitigazione: rollout incrementale per fase + smoke manuale per regressione.
- Rischio: incoerenza permessi.
  - Mitigazione: verificare visibilita azioni CRUD con policy esistenti prima del merge.

## Ordine di esecuzione consigliato

1. P0 (contratti client)
2. P1 (tab core Persone)
3. P2 (Richieste GDPR dedicate)
4. P3 (storico esteso)
5. P4 (resto GDPR)

## Evidenza tecnica (file chiave da toccare)

- `Accredia.SIGAD.Web/Services/GatewayClient.cs`
- `Accredia.SIGAD.Web/Models/Anagrafiche/*`
- `Accredia.SIGAD.Web/Components/Pages/Persone/Dettaglio.razor`
- nuove pagine GDPR in `Accredia.SIGAD.Web/Components/Pages/Persone/` o `Accredia.SIGAD.Web/Components/Pages/Gdpr/`
