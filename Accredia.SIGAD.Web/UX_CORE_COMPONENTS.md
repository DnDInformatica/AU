# SIGAD Web - UX Core Components

Obiettivo: mantenere coerenza visiva e comportamentale (MudBlazor + shell SIGAD) riducendo markup duplicato.

## Componenti Core (riusabili)

- `MainLayout` (`Accredia.SIGAD.Web/Components/Layout/MainLayout.razor`)
  - Topbar + sidebar + main content.
  - Regola: Topbar sempre presente, search visibile solo autenticato, profilo a destra.

- `NavMenu` (`Accredia.SIGAD.Web/Components/Layout/NavMenu.razor`)
  - Sidebar collassabile con gruppi e tooltip in modalita collapsed.
  - Regola: le voci dipendono sempre da `UserContext.HasPermission(...)`.

- `PageHeader` (`Accredia.SIGAD.Web/Components/Shared/PageHeader.razor`)
  - Titolo, sottotitolo, breadcrumb, azione primaria (opzionale).
  - Regola: usato su tutte le pagine "di elenco" e "di dettaglio".

- `GlobalSearch` (`Accredia.SIGAD.Web/Components/Layout/GlobalSearch.razor`)
  - Ricerca globale con popover risultati, retry e link a `/system-status`.
  - Regola: debounce senza cancellazione delle chiamate HTTP (evita rumorosita TaskCanceled in debug).

- Quick drawer pattern
  - Host: `QuickDrawerHost` + service `QuickDrawerService`.
  - Regola: anteprime rapide da liste senza perdere contesto (Persone/Organizzazioni).

- Stati UX "failure-first"
  - Loading: skeleton o progress.
  - Empty: messaggio informativo con suggerimento.
  - Error: alert con `Riprova` e link a `/system-status`.

- `AccessDenied` (`Accredia.SIGAD.Web/Components/Shared/AccessDenied.razor`)
  - 403/permessi mancanti coerente.
  - Regola: usare sempre questo componente nei moduli protetti.

## CSS / Tokens

- Classi skin (cards/tables/topbar/sidebar) definite in `wwwroot/app.css` e usate con classi `sigad-*`.
- Regola: preferire classi "tokenizzate" (`sigad-card`, `sigad-table-wrap`, `sigad-filterbar`) a stile inline.

