# 🎨 Audit UX e Proposta di Miglioramenti — SIGAD Web

**Applicazione:** Accredia.SIGAD.Web (Blazor Server + MudBlazor 8.14.0)
**Soluzione:** Accredia.SIGAD.sln
**Data:** 05/10/2026
**Metodo:** analisi statica del codice (63 file razor, CSS globali, JS custom, theme), su due sweep parallèleli + verifica diretta delle evidenze principali. Precede audit: `SIGAD_UX_Audit_Report_2026-02-08.md` (diverse segnalazioni di allora risultano già integrate, es. gestione errori login).

---

## Executive Summary

La base è **solida**: shell coerente (topbar + drawer a scomparsa), `PageHeader` con breadcrumb semanticamente corretti, ricerche server-side con `CancellationToken`, protezione double-submit nelle form principali, conferma delete nelle liste Anagrafiche e Admin, pager localizzato, gate permessi per modulo. La sezione **Organizzazioni è il riferimento di qualità interno** (empty state differenziati, tooltip, ordinamento nelle sub-tabelle).

Il problema principale non è il singolo componente ma la **mancanza di un unico standard applicato ovunque**: quattro pattern di loading, tre approcci alla conferma di cancellazione (di cui uno è "nessuna conferma"), due sistemi colore in competizione, gerarchia tipografica che di fatto non esiste (bold reso in peso regolare), e una qualità che degrada lungo il gradiente Organizzazioni → Persone/Incarichi → GDPR/Certificazioni/Tipologiche.

**Rischio reputazionale da non sottovalutare:** la dashboard mostra **numeri inventati** (KPI hardcoded) presentati come dati reali.

Punteggio complessivo: ⭐⭐⭐☆☆ (3/5) — potenziale 4.5 con interventi mirati.

---

## 🔴 P0 — Critici (fiducia nei dati, azioni distruttive, accessibilità)

### 1. La dashboard mostra dati finti
`Components/Pages/Home.razor:15,22,29,36` — KPI hardcoded ("128" Organizzazioni, "542" Persone, "87" Incarichi, "6" Segnalazioni) e attività recenti mock (`Home.razor.cs:35-40`). La colonna "Dettagli" (`Home.razor:85`) è testo morto, non un link. Il subtitle della pagina — *"Accesso rapido alle anagrafiche principali con pattern coerenti."* — è gergo da sviluppatore esposto all'utente.
**Proposta:** o collegare i KPI a conteggi reali (conte esiste già lato API per le liste) oppure rimuovere la riga KPI; sostituire "Attività recenti" con scorciatoie reali (ultime entità modificate se disponibile, altrimenti link rapidi); riscrivere il subtitle in linguaggio utente.

### 2. Cancellazioni senza conferma
Le liste Anagrafiche/Admin usano `ShowMessageBox` (corretto), ma:
- **Tutte e 4 le pagine GDPR**: il cestino elimina all'istante, senza dialog e senza snackbar (`Gdpr/DataBreach.razor:64` → `DataBreach.razor.cs:183-200`; idem Richieste, RegistroTrattamenti, RichiesteEsercizioDiritti).
- **Persone/Dettaglio**: tutte le delete inline (email, telefoni, indirizzi, qualifiche, relazioni, titoli, consensi, associazione utente) senza conferma (`Persone/Dettaglio.razor:100,118,179,217,253,290,326,358`).
- **Organizzazioni/Dettaglio**: identificativi fiscali eliminabili senza conferma (`Dettaglio.razor.cs:634-652`).
- **PersonaDocumentiPanel**: soft-delete documento immediata (`PersonaDocumentiPanel.razor:73-77`).
- RisorseUmane usa un terzo pattern ("doppio click Elimina→Conferma") senza timeout di reset.
**Proposta:** un unico helper di conferma (wrapper su `DialogService.ShowMessageBox` con titolo, testo e verbo "Elimina") usato ovunque; snack di esito dopo ogni delete.

### 3. Messaggi d'errore tecnici esposti all'utente (~40 punti)
Pattern ricorrente `catch { _errorMessage = ex.Message }`: l'utente vede `HttpRequestException`, messaggi del gateway, dettagli interni. Esempi: `Organizzazioni/Nuova.razor.cs:129`, `Admin/Roles.razor.cs:239`, `Admin/Utenti.razor.cs:90`, `Incarichi/Modifica.razor.cs:316`, e tutti i GDPR.
**Proposta:** centralizzare in un helper (es. `GatewayErrorMapper.ToUserMessage(ex)`) che mappa 401/403/404/timeout/connection-refused a frasi utente + azione ("Riprova", "Verifica stato servizi" → già esiste la pagina `/system-status`); loggare l'eccezione completa lato server, mai mostrarla.

### 4. Accessibilità — blocchi reali
- **ESC non chiude il QuickDrawer**: il selettore JS `.sigad-quickdrawer .mud-drawer-open` è discendente ma le due classi stanno sullo stesso elemento → handler mai eseguito (`js/sigad-ui-enhancements.js:64-75`). Inoltre l'outline di focus è soppresso nel drawer (`QuickDrawerHost.razor.css:22-25`).
- **Skip-link probabilmente inefficace**: `#main-content` non è focusable (manca `tabindex="-1"`), quindi `target.focus()` è un no-op (`MainLayout.razor:80` + `sigad-ui-enhancements.js:49-62`).
- **Screen reader spammed**: il MutationObserver annuncia "Pagina caricata…" ad **ogni** mutazione DOM (ogni digitazione con `Immediate`, ogni refresh tabella) nella live region (`sigad-ui-enhancements.js:89-105`).
- **Icone senza nome**: azioni edit/delete GDPR e tutte le sub-tabelle di Persone/Dettaglio senza `AriaLabel` né tooltip; checkbox di selezione custom nelle liste sono `span` senza `role="checkbox"`/`aria-checked`/`tabindex` → inaccessibili da tastiera (`PersoneResults.razor:103-131`).
- **Login senza `autocomplete="username"/"current-password"`** (`Login.razor:28-53`) → password manager inaffidabili (WCAG 1.3.5). Helper text dichiara "Almeno 8 caratteri" che non è validato. Enter funziona solo sul campo password.
**Proposta:** fix puntuali tutti a basso costo; per il QuickDrawer usare l'API MudBlazor (`OnEscape`/chiusura programmatica) invece dell'hack JS; eliminare il MutationObserver a favore di un annuncio esplicito dopo la navigazione.

### 5. Form Sedi salvabili completamente vuote
`Organizzazioni/Sedi/Nuova.razor.cs:103-110` non chiama mai `_form.Validate()` e i campi non hanno `Required`: l'errore arriva solo dal backend, dopo il submit. Stessa assenza di validazione client nelle form GDPR (validazione manuale su 4 soli campi in DataBreach) e nei form inline di Organizzazioni/Dettaglio (identificativi, `Dettaglio.razor:650-673`).
**Proposta:** allineare tutte le form al pattern già usato da Persone/Incarichi/Organizzazioni (`MudForm` + `Required` + `_form.Validate()`).

---

## 🟠 P1 — Alti (usabilità quotidiana)

### 6. La gerarchia tipografica "bold" non esiste
Open Sans è caricato **solo nel peso 400**; le `@font-face` 600/700 mappano lo stesso file regolare (commento nel codice: *"Temporary: let browser synthesize weights"* — `app.css:26-41`). Risultato: intestazioni tab, thead delle tabelle, tooltip, KPI dichiarati 600–800 rendono **in peso regolare**. Montserrat 800 è mappato sul file 700 (`app.css:9-16`).
**Proposta:** integrare i woff2 mancanti (OpenSans 600/700, Montserrat 600/800) in `wwwroot/brand/fonts/` — è un aspetto in attesa da febbraio; in attesa, rendere esplicito il fallback sintetico (`font-synthesis: weight`) o abbassare i pesi dichiarati per coerenza visiva immediata.

### 7. Due sistemi colore in competizione
`SigadTheme.cs` definisce Primary ocra `#d4a574` (mockup), ma `accredia-custom.css:16-19` **forza via `!important`** `--mud-palette-primary` al blu `#00519E`. Esito: bottoni `Color.Primary` blu, ma focus ring, tab attivi, breadcrumb, slider e hover usano ancora l'ocra. Due lingue visive sulla stessa pagina. Nota brand: l'ocra ufficiale Accredia è `#F39200` (terzo valore in gioco, dichiarato come `--accredia-accent` ma poco usato). C'è anche un vincolo di contrasto: `#d4a574` su bianco è ~1.9:1, sotto ogni soglia WCAG per indicatori UI.
**Proposta:** decidere una volta sola la gerarchia — raccomandazione: **blu/grafite per azioni e stati** (contrasto ok), **ocra ufficiale `#F39200` solo come accento** (indicatori su fondo grafite, dettagli decorativi, badge non essenziali), rimozione del forzaggio `!important` e riallineamento del tema MudBlazor alla scelta. Un'unica fonte di verità: il tema, non i CSS.

### 8. Perdita silenziosa delle modifiche
Nessun dirty-check in tutta l'app (zero occorrenze di `NavigationLock`/`LocationChanging`): "Annulla", breadcrumb e back scartano il lavoro senza avviso (es. `Persone/Modifica.razor:99-101`).
**Proposta:** componente/servizio condiviso `UnsavedChangesGuard` che registra lo stato sporco della form e intercetta la navigazione (`LocationChanging`) + conferma su "Annulla".

### 9. Titolo scheda browser mancante su 36 pagine su 42
Solo Admin e Error impostano `PageTitle`. Il componente `PageHeader` (presente quasi ovunque) è il posto naturale: aggiungere lì il `<PageTitle>` derivato da Title + breadcrumb → fix in un componente, beneficio su tutto.
**Proposta:** estendere `PageHeader` con `PageTitle` (e opzionale `Title` dinamico per dettagli: "Organizzazione — ACME S.p.A.").

### 10. Liste principali senza ordinamento
Persone, Incarichi, Organizzazioni: intestazioni non ordinabili (`PersoneResults.razor:114-118`, `IncarichiResults.razor:114-120`, `OrganizzazioniResults.razor:142-147`) mentre le sub-tabelle di Organizzazioni/Dettaglio lo sono — incoerenza interna. Su 50+ risultati l'utente non può riordinare.
**Proposta:** `SortLabel` sulle colonne chiave (denominazione/cognome, data, stato) con `sortBy/sortDirection` passati alle API (le ricerche sono già server-side).

### 11. Certificazioni: sezione sotto il minimo
Nessun indicatore di caricamento (la tabella appare vuota durante il load, `Certificazioni.razor:117-176`), nessuna vista dettaglio (l'unica azione è "Modifica" che sovrascrive il form inline), e dopo il salvataggio il criterio di ricerca digitato viene **sovrascrito silenziosamente** con la denominazione salvata (`Certificazioni.razor.cs:203-212`).
**Proposta:** loading state, empty state, riga cliccabile → dettaglio (anche solo drawer QuickPreview, pattern già esistente), non toccare il termine di ricerca dell'utente.

### 12. ID di database esposti come campi utente
RisorseUmane chiede all'utente di digitare **ID numerici**: "Stato ID", "Tipo contratto ID", "Tipo dotazione ID", "Tipo formazione ID" (`NuovoDipendente.razor:122-129`, `DettaglioDipendente.razor` in più punti); GDPR mostra "PersonaId"; Persone/Dettaglio mostra "IndirizzoId", "UserId"; Incarichi/Dettaglio mostra "UO: 123".
**Proposta:** sostituire ogni input/colonna di ID grezzi con `LookupAutocomplete` (componente già esistente in `Shared/`) sulle tipologiche; nei dettagli mostrare l'etichetta, non la chiave.

---

## 🟡 P2 — Medi (coerenza e polish)

13. **Quattro pattern di loading**: skeleton (Admin), spinner in toolbar (liste Anagrafiche), `MudProgressLinear` (GDPR/dettagli), nulla (Certificazioni, Tipologiche). → Un componente `SigadPageState` (loading/error/empty) unico, usato da tutti.
14. **Gate permessi incoerente**: `AccessDenied` assente nelle liste Persone/Organizzazioni, nelle form Organizzazioni (Nuova/Modifica/Sedi/Uo), Documenti e Tipologiche → l'utente senza permessi vede la pagina e prende l'errore dal server.
15. **Error.razor in inglese** con istruzioni "Development Mode" visibili agli utenti (`Error.razor:1-25`). → Italiano + messaggio di cortesia + link a `/system-status`.
16. **Formati data misti**: `dd/MM/yyyy` in Anagrafiche/GDPR, `yyyy-MM-dd` in RisorseUmane (`Dipendenti.razor:119`, `DettaglioDipendente.razor:261-264`).
17. **Densità tabelle mista**: `Dense="false"` solo in `OrganizzazioniResults.razor:128`.
18. **Pagine GDPR orfane**: i link esistono nel NavMenu ma sono commentati (`NavMenu.razor:35-38,69-72`) — quattro pagine raggiungibili solo via URL. Decidere: abilitare (e allora portarle allo standard) o rimuovere.
19. **Pagine Admin senza `PageHeader`/breadcrumb**: intestazioni handmade, nessun "torna a /admin" (`AdminHome.razor:15-18`, `Utenti.razor:21-29`, `Roles.razor:20-28`, `Permissions.razor:20-27`).
20. **Errori bulk non tracciabili**: "Eliminazione parziale: N errori" senza elenco delle righe fallite (`Persone.razor.cs:296-299`, `Organizzazioni.razor.cs:466-469`).
21. **Download silenziosi in errore**: `sigad-download.js` inghiotte gli errori di proposito (:13-16, :37-40) — l'utente non sa se il file è partito.
22. **Responsive non provato a 375px**: nessuna media query dedicata; tabelle larghe probabilmente fuoriescono orizzontalmente (supposizione da verificare a runtime); nessun `prefers-reduced-motion` nonostante animazioni drawer 0.3s; classe `body.is-mobile` impostata dal JS ma mai usata da alcun CSS (codice morto).
23. **Debito CSS**: Bootstrap + MudBlazor caricati insieme (conflitti documentati nei commenti stessi, ~40 `!important`), blocco hack tab verticali duplicato due volte con `left:-252px` (`accredia-custom.css:475-489` e `505-519`), `.font-monospace` forzato a Courier New contro il mono brand Roboto Mono, `:focus-visible` globale che cambia `border-radius` all'elemento focusato.
24. **Dead code JS**: blocco "Blazor reconnect" irraggiungibile (`sigad-ui-enhancements.js:129-135`, gira prima del caricamento di blazor.web.js), listener su nodi che il re-render distrugge, `lastScrollTop` mai letto.

---

## 🗺️ Roadmap proposta

**Onda 1 — Quick win (pochi giorni, alto ritorno)**
1. Fix JS: selettore ESC QuickDrawer (o meglio, chiusura via API MudBlazor), rimozione MutationObserver, `tabindex="-1"` su `#main-content`.
2. `PageTitle` dentro `PageHeader` (1 componente → 36 pagine).
3. Conferma di cancellazione unificata (helper condiviso) applicata a GDPR, Persone/Dettaglio, Org/Dettaglio, Documenti.
4. Login: attributi autocomplete + Enter su username + helper text onesto.
5. Helper mappa errori → messaggi utente, sostituzione dei ~40 `ex.Message`.
6. `Error.razor` in italiano; date e densità uniformate; icone con `AriaLabel`.

**Onda 2 — Strutturale (settimane)**
7. Decisione colore unica (blu/grafice azioni + ocra `#F39200` accento) e pulizia `!important`.
8. Font: integrazione pesi mancanti Open Sans/Montserrat.
9. `SigadPageState` unico (loading/error/empty) e adozione progressiva.
10. Dirty-check condiviso sulle form.
11. Ordinamento server-side nelle tre liste principali.
12. Sostituzione ID grezzi con lookup (soprattutto RisorseUmane).

**Onda 3 — Esperienza**
13. Dashboard con dati reali (o senza KPI finti) e microcopy utente.
14. Certificazioni: loading + dettaglio; GDPR: abilitare o rimuovere dal nav.
15. Sessione di verifica a 375px/960px/1920px su tabelle e drawer + `prefers-reduced-motion`.
16. Keyboard/focus completo nel QuickDrawer (focus trap, ritorno focus al chiamante).

---

## Note di metodo e limiti

- Analisi statica: le evidenze file:line sono verificate nel codice; le uniche supposizioni dichiarate sono l'overflow tabelle a 375px e la resa runtime di alcuni stati (da confermare con una sessione su browser).
- I bug JS (selettore ESC, reconnect block) sono certi per analisi statica; consigliata conferma runtime.
- Collegamento con audit precedente (`SIGAD_UX_Audit_Report_2026-02-08.md`): il bug "Totale: 0" e la gestione errori login ivi segnalati risultano indirizzati; questo report li considera risolti e non li ripropone.
