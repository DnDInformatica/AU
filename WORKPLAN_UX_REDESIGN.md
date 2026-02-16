# SIGAD Web UX Redesign + Login Fix Workplan

Data: 2026-02-07  
Input:
- Mockup HTML: `C:\Users\g.denicolo\Downloads\Template3_light_REDESIGN_topbar_admin_rightaligned.html`
- UX spec (incompleta): `C:\db_analyzer\ACCREDIA_DataModel_UX_Spec.md`

## 0. Vincoli e Principi Architetturali

Vincoli (non negoziabili):
- UI basata su **MudBlazor** (Blazor Server).
- Cambiamenti **incrementali**: evitare riscritture “big-bang”.
- Coerenza con i pattern esistenti (token management, gateway client, vertical slice).

Principi:
- **Design system first**: definire token e theme (MudTheme + CSS variables) prima di cambiare tutte le pagine.
- **Composable UI**: componenti riusabili (Shell, Table, Drawer, Tabs) invece di markup duplicato.
- **Failure-first UX**: stati KO (servizi down, 401/403, empty, loading) trattati come feature.
- **API contract-driven**: DTO e response shape stabili; evitare placeholder (Guid.NewGuid/int finti) in produzione.
- “Team UX/Design available”: assumo la possibilità di iterare su visual e microcopy, quindi la struttura deve essere facilmente raffinabile.

## 1. Stato Attuale (Repo)

### 1.1 Frontend (Blazor Server + MudBlazor)
- Layout principale: `Accredia.SIGAD.Web/Components/Layout/MainLayout.razor`
- Login: `Accredia.SIGAD.Web/Components/Pages/Login.razor`
- Render mode: `Routes @rendermode="InteractiveServer"` in `Accredia.SIGAD.Web/Components/App.razor`
- MudBlazor JS: `_content/MudBlazor/MudBlazor.min.js` incluso in `Accredia.SIGAD.Web/Components/App.razor` (necessario per evitare crash del circuito su MudInput)
- Token management:
  - Storage: `Accredia.SIGAD.Web/Services/TokenService.cs` (Session + opzionale Local)
  - Refresh: `Accredia.SIGAD.Web/Services/TokenRefreshService.cs` (timer + refresh reattivo su 401 via handler)
  - Inject token: `Accredia.SIGAD.Web/Services/GatewayAuthorizationHandler.cs`
- Client HTTP:
  - `Accredia.SIGAD.Web/Services/GatewayClient.cs` (Identity, Search, Anagrafiche, Tipologiche)
  - `Accredia.SIGAD.Web/Services/AdminClient.cs` (admin user/role/permission)

### 1.2 Backend/Gateway
- Gateway YARP su `http://localhost:7100/` (config: `Accredia.SIGAD.Gateway/appsettings.json`)
- Identity API su `http://localhost:7001/`
- Start/stop script:
  - `start_sigad.bat` (avvia 7000/7001/7002/7003/7100)
  - `stop_sigad.bat`

### 1.3 Problema “Login non funziona”
Osservazione tecnica (verificata localmente):
- `http://localhost:7100/health` e `http://localhost:7001/health` non rispondono se i servizi non sono avviati.
- In questa condizione il login fallisce per “connection refused”.

Implicazione UX:
- Il login oggi mostra un errore generico/tecnico; l’utente non capisce che mancano i servizi.

## 2. Obiettivo UX (dal Mockup HTML)

Il mockup definisce un “shell” applicativo coerente:
- Topbar sticky: logo a sinistra, ricerca centrale, azioni e profilo a destra
- Sidebar con collapse + tooltip nella modalità collapsed
- Cards con ombre leggere, border sottili, radius importanti
- Tab/section pattern per dettaglio entità (es. scheda Organizzazione con tab: overview/sedi/uo/incarichi/iva/storico)
- Drawer laterale con overlay per quick detail e azioni contestuali

Token di design (da `:root` mockup):
- Palette: grafite `#1a1a2e`, ocra `#d4a574`, ecru `#f8f7f5`
- Radius: `16px`, shadow “soft”
- Tipografia: Montserrat (header) + Open Sans (body)

## 3. Gap vs UX Spec (ACCREDIA_DataModel_UX_Spec.md)

La spec dati descrive:
- Organizzazione: header “stato”, soft-delete, dati fiscali, sedi, UO, incarichi, tipologie, storico
- Persona: anagrafica, contatti, incarichi, GDPR
- Pattern: temporal validity, soft-delete, audit trail, “principale”

Stato codice oggi:
- Organizzazioni: esistono chiamate API in `GatewayClient` (search/detail/sedi/uo/incarichi/tipi/identificativi)
- UI: non risulta ancora una “scheda Organizzazione” completa allineata al mockup; parte dell’Admin UI è presente ma con DTO placeholder
- Persone/Accreditamento/GDPR: non risultano implementati lato UI

## 4. Strategia (Pragmatica)

Vincoli:
- Preferire modifiche minime e controllate
- Ridurre “big-bang rewrite”

Approccio:
1. Rendere il login “robusto” e diagnosticabile (prima di rifare look&feel)
2. Introdurre design tokens e shell (topbar/sidebar) **via MudBlazor Theme + CSS** senza riscrivere tutte le pagine
3. Portare 1 vertical slice end-to-end (Organizzazioni: lista + dettaglio) aderente a mockup/spec
4. Iterare su Persone e moduli successivi

## 5. Piano di Lavoro (con milestone)

### M0 (Stabilità) - Login + Diagnostica runtime
- [x] Messaggi errore “gateway non raggiungibile/timeout” (in `GatewayClient`)
- [x] Disabilitare submit fino a JS disponibile (in `Login.razor`)
- [x] Aggiungere pagina “System status” (health check gateway/identity/anagrafiche/tipologiche) visibile anonima (`/system-status`)
- [x] (Opzionale) Evidenziare avvio rapido con `start_sigad.bat` e mostrare gli URL verificati (in `/system-status`)

Accettazione:
- Se servizi non avviati, login mostra messaggio chiaro e azionabile.
- Se servizi avviati e credenziali valide, login porta a home e `AuthorizeView` cambia stato.
- Nessuna eccezione `JSDisconnectedException` in debug per disconnessioni (gestita in AuthProvider/MainLayout).
- Nessun crash MudBlazor JS interop (`mudElementRef.*`) grazie allo script incluso.

### M1 (Design tokens) - Base theme + CSS
- [x] Definire CSS variables globali + font (Open Sans/Montserrat) in `Accredia.SIGAD.Web/wwwroot`
- [x] Allineare **MudTheme** (palette primary=ocra, background=ecru, typography, radius) e mappare token -> MudBlazor
- [x] Classi CSS “shell” per topbar/sidebar/cards/tables, usate come “skin” sopra componenti Mud esistenti
- [x] Guideline componenti core (Topbar, Sidebar, Table, Drawer, Tabs, EmptyState, Skeleton): `Accredia.SIGAD.Web/UX_CORE_COMPONENTS.md`

Accettazione:
- Look generale vicino al mockup senza cambiare logica pagine.

### M2 (Shell) - Topbar + Sidebar behavior
- [x] MainLayout: topbar right-aligned con search + avatar menu (fix layout: `flex` + wrapper left/center/right)
- [x] Sidebar: modalità collapsed con tooltip (equivalente mockup) e gruppi navigazione (NavMenu)
- [x] Drawer “quick detail” come pattern riutilizzabile

Accettazione:
- Navigazione coerente, sidebar collassabile, topbar consistente.

### M3 (Vertical slice) - Organizzazioni (Lista + Dettaglio)
- [x] Lista Organizzazioni:
  - filtri (query, tipo, stato)
  - paginazione server-side
  - colonne “CF/PIVA/Denominazione/Stato/Soft delete”
- [x] Dettaglio Organizzazione:
  - header con stato pill + soft-delete
  - tab: overview/sedi/uo/incarichi/tipologie/iva/storico (anche parziali, ma con skeleton)
  - tipologie: principale + altre (compatibile con spec e mockup)
- [x] Error/empty/skeleton states

Accettazione:
- Utente può cercare una organizzazione, aprire dettaglio, vedere le sezioni principali.

### M4 - Persone (Lista + Dettaglio) + Incarichi cross-link
- [x] Lista persone e scheda persona (lista + quick detail; dettaglio completo da iterare)
- [x] Deep-link da ricerca globale e liste (persone/incarichi) + incroci base
- [x] Dettaglio persona: overview + incarichi + placeholder coerenti (contatti/GDPR/documenti)

### M5 - Admin (Users/Roles/Permissions)
- [x] Rimuovere placeholder `int`/`Guid.NewGuid()` in `AdminClient` e allineare ai nuovi endpoint Identity (userId string)
- [x] UI admin coerente con shell e permessi (utenti/ruoli/permessi + stati errore/empty/loading + access denied condiviso)

## 6. Rischi / Dipendenze
- Servizi non avviati: UI deve degradare bene (M0).
- Contratti Identity vs modelli Web “legacy”: va normalizzato (M5).
- Spec UX incompleta: per le parti mancanti serve conferma (es. mapping “TipoLegacy” vs tabella ponte).

## 7. Prossime Azioni (da eseguire nell’ordine)
Stato (aggiornato 2026-02-08): **M0-M5 completati**, avvio fase CRUD Anagrafiche.

Note:
- Le sezioni “in roadmap” (GDPR/Documenti/Storico eventi) sono presenti in UI con pattern `loading/empty/error` e microcopy coerente; l’integrazione dati potra essere estesa quando i relativi endpoint saranno disponibili.

## 8. Piano Esteso (CRUD + Pronto Esercizio)

Contesto operativo (confermato):
- Hosting: **Blazor Server**
- Deploy: **DEV + PROD**
- HA/scale-out: **>= 1** istanza (previsto)
- Storage documentale: **Nextcloud** (WebDAV), ACL dedicata per documento ma *policy di permessi per modulo*
- Soft delete: **solo soft delete** (no hard delete)
- Audit/logging/monitoring: richiesti (da completare)

### M6 - CRUD Anagrafiche (End-to-End)
Obiettivo: rendere operative tutte le funzionalita CRUD principali con pattern coerenti (UX + API).

Stato attuale:
- [x] Organizzazioni CRUD (create/update/soft-delete) + UI
- [x] Persone CRUD (create/update/soft-delete) + UI
- [x] Sedi CRUD (nested in organizzazione) + UI (principale unica)
- [x] **Unita Organizzative (UO) CRUD** (nested in organizzazione) + UI (principale unica)
- [x] Incarichi (lista/dettaglio + CRUD dove applicabile) + cross-link Org/Persona
- [x] Contatti Persona (email/telefono/PEC) CRUD
- [x] Storico eventi min (audit trail funzionale, anche “read-only”)

Deliverable e criteri accettazione (per ciascun modulo):
- Endpoint API versionati correttamente, status code coerenti, DTO stabili
- UI: lista + dettaglio + create/edit + soft-delete con conferma e stati `loading/empty/error`
- Validazioni input lato UI + lato API
- Permessi: link/menu/azioni visibili solo se autorizzati (policy-based)

### M7 - Documenti (Nextcloud) - Base Operativa
Obiettivo: upload/list/download/delete (soft) con ACL e tracking minimo.

Scelte (da confermare tecnicamente in implementazione):
- Trasporto: WebDAV verso Nextcloud via service account
- ACL: enforcement in SIGAD (DB/claims/permessi) + mapping su cartelle/metadata in Nextcloud
- Permessi: per modulo (es. Organizzazioni.Documenti.*), non per singolo documento in UI finche non definito

### M8 - Pronto Esercizio / Produzione (Hardening)
Obiettivo: rendere la soluzione rilasciabile in PROD con requisiti minimi enterprise.

Checklist (minimo):
- Autenticazione/Autorizzazione:
  - Gateway/Backend protetti (JWT), policy coerenti, 401/403 puliti
  - Token refresh robusto (nessun loop, gestione disconnessioni circuit Blazor)
- Config e segreti:
  - Nessun segreto in repo, secrets via env/KeyVault/secret manager
  - Config per DEV/PROD separate, CORS/cookie/samesite verificati
- Observability:
  - Logging strutturato (correlation id end-to-end)
  - Metriche/health check completi e page `/system-status` usabile
- Data:
  - Migrazioni/DDL versionate, soft delete consistente, vincoli univocita dove richiesto
- Performance:
  - Paginazione server-side ovunque, debounce search, timeouts e cancellation token
  - Validazione HA: session affinity o state management per Blazor Server (se multi-istanzato)

## Chiusura punti aperti (2026-02-16)

- Milestone M6 chiusa: CRUD Anagrafiche operativo su Organizzazioni/Persone/Sedi/UO/Incarichi + contatti persona e storico minimo.
- Le eventuali estensioni successive (Documenti avanzati, GDPR esteso, audit approfondito) restano nel backlog M7/M8.
