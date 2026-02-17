# SIGAD UX/UI Design System — Guida Ufficiale Redesign

> **Versione:** 1.0
> **Autore:** Principal UX/UI Designer & Frontend Architect
> **Target:** Blazor Server + MudBlazor · Enterprise data-heavy · Stile istituzionale Accredia
> **Obiettivo:** Redesign completo dell'interfaccia SIGAD per renderla moderna, professionale, efficiente e consistente.

---

## SEZIONE 1 — PRINCIPI UX SIGAD

### 1.1 Gerarchia Visiva Chiara
Ogni schermata deve rispondere in <2 secondi a tre domande: **Dove sono? Cosa vedo? Cosa posso fare?**

| Livello | Elemento | Trattamento |
|---------|----------|-------------|
| **L1** | Titolo pagina + breadcrumb | `H5 Montserrat 800` — primo elemento letto |
| **L2** | KPI / metriche hero | Card numerica prominente, colore accent |
| **L3** | Filtri e azioni | Toolbar compatta, azioni primarie a destra |
| **L4** | Contenuto dati | Tabella/form — corpo principale |
| **L5** | Azioni secondarie | Inline row actions, link sottili |

**Regola:** non più di **3 livelli di enfasi visiva** contemporaneamente in viewport. Se serve un quarto, ridurre un altro.

### 1.2 Chiarezza Operativa
- Ogni azione **primaria** ha un solo bottone prominente (Color.Primary, Variant.Filled)
- Le azioni **distruttive** richiedono sempre conferma a due step
- Lo stato corrente è sempre visibile: loading skeleton, empty state, error state, success feedback
- **Zero azioni nascoste:** niente hamburger menu per azioni critiche su desktop

### 1.3 Riduzione Carico Cognitivo
- **Progressive disclosure:** mostrare prima il sommario, poi il dettaglio on-demand
- **Filtri intelligenti:** collassati di default se >2 filtri, badge contatore filtri attivi
- **Default ragionevoli:** pre-selezionare i filtri più comuni (es. "Solo attivi")
- **Chunking visivo:** raggruppare dati in sezioni logiche con intestazione, mai muro di campi

### 1.4 Consistenza Strutturale
- **Ogni pagina lista** segue lo stesso template (header → filtri → tabella → paginazione)
- **Ogni pagina dettaglio** segue lo stesso template (header con back → hero card → tabs)
- **Ogni form** segue lo stesso pattern (label sopra, validazione inline, azioni in fondo a destra)
- **Nomenclatura uniforme:** "Nuovo/a [entità]", "Modifica [entità]", "Elimina [entità]"

### 1.5 Efficienza Operativa
- **Keyboard-first:** Tab attraverso filtri, Enter per cercare, Esc per chiudere dialog
- **Scorciatoie contestuali:** Ctrl+N per nuovo (su liste), Ctrl+S per salvare (su form)
- **Persistenza stato:** filtri, ordinamento, paginazione sopravvivono alla navigazione
- **Azioni bulk:** sempre disponibili quando la selezione multipla ha senso

### 1.6 Feedback Immediato
- **Ogni azione produce feedback:** Snackbar di conferma (success/error) entro 300ms
- **Loading states:** skeleton per caricamento iniziale, spinner per azioni utente
- **Empty states:** illustrazione + messaggio + CTA, mai tabella vuota senza spiegazione
- **Error recovery:** messaggio chiaro + azione suggerita ("Riprova" / "Torna alla lista")

---

## SEZIONE 2 — LAYOUT GENERALE APPLICAZIONE

### 2.1 Struttura Macro

```
┌──────────────────────────────────────────────────────┐
│  AppBar (56px, fixed top, glassmorphic)              │
│  [☰ Logo SIGAD]     [🔍 Search]     [👤 User menu]  │
├────────┬─────────────────────────────────────────────┤
│ Drawer │  Content Area                               │
│ 280px  │  ┌─────────────────────────────────────┐    │
│ (exp)  │  │ PageHeader: breadcrumbs + title     │    │
│ ──── ─ │  │            + actions (right)         │    │
│ 72px   │  ├─────────────────────────────────────┤    │
│ (mini) │  │ Page Content                        │    │
│        │  │ (padded, max-width 1440px centered) │    │
│        │  │                                     │    │
│        │  └─────────────────────────────────────┘    │
└────────┴─────────────────────────────────────────────┘
```

### 2.2 AppBar — Specifiche

```razor
<MudAppBar Fixed="true" Dense="true" Elevation="0"
           Class="sigad-appbar">
    <!-- LEFT: hamburger + logo -->
    <MudIconButton Icon="@Icons.Material.Filled.Menu"
                   OnClick="ToggleDrawer" />
    <MudImage Src="/img/sigad-logo.svg" Height="28" Class="ml-2" />

    <!-- CENTER: global search (solo authenticated) -->
    <MudSpacer />
    <GlobalSearch Class="sigad-search" />
    <MudSpacer />

    <!-- RIGHT: notifications + user -->
    <MudBadge Content="@notificationCount" Color="Color.Error"
              Overlap="true" Visible="@(notificationCount > 0)">
        <MudIconButton Icon="@Icons.Material.Outlined.Notifications" />
    </MudBadge>
    <UserMenu />
</MudAppBar>
```

**Specifiche visive:**
- Altezza: **56px** (Dense)
- Background: `rgba(255,255,255,0.85)` con `backdrop-filter: blur(12px)`
- Border-bottom: `1px solid var(--sigad-line)`
- Z-index: 1100 (sopra drawer)
- Logo: SVG monocromatico, altezza 28px

### 2.3 Drawer Laterale — Specifiche

**Due stati:**
| Stato | Larghezza | Mostra | Trigger |
|-------|-----------|--------|---------|
| Espanso | 280px | Icona + label + section headers | Click hamburger |
| Mini | 72px | Solo icona centrata + tooltip | Click hamburger |

```razor
<MudDrawer @bind-Open="_drawerOpen"
           ClipMode="DrawerClipMode.Always"
           Variant="DrawerVariant.Mini"
           MiniWidth="72px"
           Width="280px"
           Elevation="0"
           Class="sigad-drawer">
    <NavMenu IsExpanded="_drawerOpen" />
</MudDrawer>
```

**Specifiche visive:**
- Background: `var(--sigad-graphite)` (#1a1a2e) — scuro per contrasto
- Testo: `rgba(255,255,255,0.87)` primario, `rgba(255,255,255,0.54)` secondario
- Active item: barra verticale accent `var(--sigad-ocra)` 3px a sinistra + background `rgba(212,165,116,0.12)`
- Hover: `rgba(255,255,255,0.06)`
- Section headers: uppercase, `font-size: 0.7rem`, letter-spacing `0.08em`, `rgba(255,255,255,0.38)`
- Transizione expand/collapse: `width 200ms cubic-bezier(0.4, 0, 0.2, 1)`

### 2.4 Content Area — Specifiche

```razor
<MudMainContent Class="sigad-main">
    <MudContainer MaxWidth="MaxWidth.False" Class="sigad-content">
        @Body
    </MudContainer>
</MudMainContent>
```

**Specifiche:**
- Padding: `24px 32px` (desktop), `16px` (mobile <960px)
- Max-width contenuto: **1440px** centrato (per schermi ultra-wide)
- Background: `var(--sigad-ecru)` (#f8f7f5) — off-white caldo
- Min-height: `calc(100vh - 56px)` — nessuno spazio morto

### 2.5 PageHeader — Pattern Unificato

Ogni pagina DEVE avere un PageHeader con questa struttura:

```
┌──────────────────────────────────────────────────────┐
│ ← Torna a Organizzazioni     [breadcrumb > trail]    │
│                                                      │
│ Dettaglio Organizzazione          [Modifica] [Altro] │
│ Sottotitolo opzionale                                │
└──────────────────────────────────────────────────────┘
```

```razor
<PageHeader Title="Dettaglio Organizzazione"
            Subtitle="@org.Denominazione"
            BreadcrumbItems="@_breadcrumbs"
            BackLabel="Torna a Organizzazioni"
            BackHref="@_returnUrl"
            PrimaryActionLabel="Modifica"
            PrimaryActionIcon="@Icons.Material.Filled.Edit"
            OnPrimaryAction="StartEdit" />
```

**Regole:**
- Breadcrumbs: **sempre strutturati** (clickable), mai stringa legacy
- Back button: **sempre presente** su pagine dettaglio, usa `returnUrl` se disponibile
- Azioni: massimo **2 bottoni** nel header (primary + secondary). Overflow → menu "Altro ▼"
- Spaziatura: `margin-bottom: 24px` dal contenuto

---

## SEZIONE 3 — PAGINA LISTA IDEALE

### 3.1 Struttura Completa

```
┌──────────────────────────────────────────────────────┐
│ PageHeader: "Organizzazioni" + [+ Nuova org.]        │
├──────────────────────────────────────────────────────┤
│ ┌──────────────────────────────────────────────────┐ │
│ │ FilterBar                                        │ │
│ │ [🔍 Cerca...]  [Stato ▼]  [Tipo ▼]  [Filtri(2)] │ │
│ └──────────────────────────────────────────────────┘ │
│                                                      │
│ ┌──────────────────────────────────────────────────┐ │
│ │ MudTable (server-side paginated)                 │ │
│ │ ┌──┬──────────────┬────────┬────────┬─────────┐  │ │
│ │ │☑ │ Denominazione │ P.IVA  │ Stato  │ Azioni  │  │ │
│ │ ├──┼──────────────┼────────┼────────┼─────────┤  │ │
│ │ │☐ │ Acme S.r.l.  │ 01234..│ 🟢 Att │ ⋯       │  │ │
│ │ │☐ │ Beta S.p.A.  │ 56789..│ 🔴 Ina │ ⋯       │  │ │
│ │ └──┴──────────────┴────────┴────────┴─────────┘  │ │
│ │ [Paginazione]                 Showing 1-20 of 147│ │
│ └──────────────────────────────────────────────────┘ │
│                                                      │
│ ┌──────────────────────────────────────────────────┐ │
│ │ BulkBar (visible when selection > 0)             │ │
│ │ "3 selezionati"  [Esporta CSV] [Cambia stato]    │ │
│ └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

### 3.2 FilterBar — Pattern Standard

```razor
<MudPaper Elevation="0" Class="sigad-filterbar">
    <MudStack Row="true" AlignItems="AlignItems.Center" Spacing="3">

        <!-- Ricerca principale: SEMPRE primo elemento -->
        <MudTextField @bind-Value="_query"
                      Placeholder="Cerca organizzazione..."
                      Adornment="Adornment.Start"
                      AdornmentIcon="@Icons.Material.Filled.Search"
                      Immediate="true"
                      DebounceInterval="400"
                      Variant="Variant.Outlined"
                      Margin="Margin.Dense"
                      Class="sigad-search-field" />

        <!-- Filtri select: max 2 visibili, resto in panel -->
        <MudSelect T="int?" @bind-Value="_statoId"
                   Label="Stato"
                   Variant="Variant.Outlined"
                   Margin="Margin.Dense"
                   Clearable="true"
                   Dense="true">
            @foreach (var s in _stati)
            {
                <MudSelectItem Value="@s.Id">@s.Descrizione</MudSelectItem>
            }
        </MudSelect>

        <!-- Badge filtri attivi + toggle panel -->
        <MudBadge Content="@_activeFiltersCount"
                  Color="Color.Primary"
                  Visible="@(_activeFiltersCount > 0)"
                  Overlap="true">
            <MudIconButton Icon="@Icons.Material.Filled.FilterList"
                           OnClick="ToggleFilterPanel" />
        </MudBadge>

        <MudSpacer />

        <!-- Azioni bulk (visibili con selezione) -->
        @if (_selectedItems.Count > 0)
        {
            <MudChip T="string" Color="Color.Primary" Size="Size.Small">
                @_selectedItems.Count selezionati
            </MudChip>
            <MudButton Variant="Variant.Text" Size="Size.Small"
                       StartIcon="@Icons.Material.Filled.Download"
                       OnClick="ExportSelected">Esporta</MudButton>
        }
    </MudStack>
</MudPaper>
```

### 3.3 Regole FilterBar
1. **Campo ricerca sempre primo** — occupa lo spazio maggiore (`flex-grow: 1`, `max-width: 400px`)
2. **Max 2 filtri select visibili** — il resto in panel espandibile
3. **Badge contatore** — sempre visibile quando filtri attivi > 0
4. **Debounce 400ms** sulla ricerca testuale
5. **Clearable** su ogni filtro select
6. **Reset All** link quando almeno 1 filtro attivo: "Azzera filtri"

### 3.4 Azioni Lista — Gerarchia

| Posizione | Tipo | Esempio | MudBlazor |
|-----------|------|---------|-----------|
| PageHeader (destra) | Azione primaria pagina | "+ Nuova organizzazione" | `Variant.Filled, Color.Primary` |
| FilterBar (destra) | Azioni bulk | "Esporta CSV" | `Variant.Text, Size.Small` |
| Row (ultima colonna) | Azioni riga | ⋮ menu | `MudMenu` con `Icon=MoreVert` |
| Row inline | Azione rapida | Link denominazione | `<a>` con classe `sigad-table-link` |

### 3.5 Empty States

```razor
@if (!_isLoading && _totalCount == 0)
{
    <MudPaper Elevation="0" Class="sigad-empty-state">
        <MudStack AlignItems="AlignItems.Center" Spacing="3"
                  Class="py-12">
            <MudIcon Icon="@Icons.Material.Outlined.Business"
                     Size="Size.Large"
                     Color="Color.Default"
                     Style="opacity:0.3" />
            <MudText Typo="Typo.h6" Color="Color.Default">
                Nessuna organizzazione trovata
            </MudText>
            <MudText Typo="Typo.body2" Color="Color.Secondary">
                @if (_hasActiveFilters)
                {
                    <span>Prova a modificare i criteri di ricerca</span>
                }
                else
                {
                    <span>Non ci sono ancora organizzazioni registrate</span>
                }
            </MudText>
            @if (!_hasActiveFilters)
            {
                <MudButton Variant="Variant.Filled" Color="Color.Primary"
                           StartIcon="@Icons.Material.Filled.Add"
                           Href="/organizzazioni/nuova">
                    Nuova organizzazione
                </MudButton>
            }
        </MudStack>
    </MudPaper>
}
```

---

## SEZIONE 4 — PAGINA DETTAGLIO IDEALE

### 4.1 Struttura Completa

```
┌──────────────────────────────────────────────────────┐
│ PageHeader: breadcrumbs + "← Torna" + [Modifica]     │
├──────────────────────────────────────────────────────┤
│ ┌──────────────────────────────────────────────────┐ │
│ │ Hero Card                                        │ │
│ │ ┌────┐  Acme S.r.l.               🟢 Attiva     │ │
│ │ │ AB │  P.IVA 01234567890 · CF ABCDE12345       │ │
│ │ └────┘  REA MI-123456                            │ │
│ └──────────────────────────────────────────────────┘ │
│                                                      │
│ ┌──────────────────────────────────────────────────┐ │
│ │ KPI Cards (opzionale)                            │ │
│ │ [Sedi: 5] [Incarichi: 12] [Dipendenti: 8]       │ │
│ └──────────────────────────────────────────────────┘ │
│                                                      │
│ ┌──────────────────────────────────────────────────┐ │
│ │ Tabs                                             │ │
│ │ [Panoramica] [Sedi (5)] [Incarichi (12)] [...]   │ │
│ │ ──────────────────────────────────────────────── │ │
│ │                                                  │ │
│ │  Tab Content (lazy-loaded)                       │ │
│ │  ┌─────────────────────────────────────────────┐ │ │
│ │  │ Section card con titolo + azioni            │ │ │
│ │  │ [Tabella / Form / Dettagli]                 │ │ │
│ │  └─────────────────────────────────────────────┘ │ │
│ │                                                  │ │
│ └──────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

### 4.2 Hero Card — Pattern Standard

```razor
<MudPaper Elevation="0" Class="sigad-hero-card">
    <MudStack Row="true" AlignItems="AlignItems.Center" Spacing="4">

        <!-- Avatar/Icona -->
        <MudAvatar Size="Size.Large"
                   Color="Color.Primary"
                   Variant="Variant.Outlined"
                   Class="sigad-hero-avatar">
            @GetInitials(entity.Denominazione)
        </MudAvatar>

        <!-- Info principale -->
        <MudStack Spacing="0" Class="flex-grow-1">
            <MudText Typo="Typo.h5" Class="sigad-hero-title">
                @entity.Denominazione
            </MudText>
            <MudStack Row="true" Spacing="2" Class="mt-1">
                <MudText Typo="Typo.caption" Color="Color.Secondary">
                    P.IVA @entity.PartitaIva
                </MudText>
                <MudText Typo="Typo.caption" Color="Color.Secondary">·</MudText>
                <MudText Typo="Typo.caption" Color="Color.Secondary">
                    CF @entity.CodiceFiscale
                </MudText>
            </MudStack>
        </MudStack>

        <!-- Stato badge -->
        <MudChip T="string"
                 Color="@GetStatoColor(entity.StatoId)"
                 Size="Size.Small"
                 Variant="Variant.Filled">
            @entity.StatoDescrizione
        </MudChip>
    </MudStack>
</MudPaper>
```

**Specifiche Hero Card:**
- Background: `var(--sigad-white)` con `border: 1px solid var(--sigad-line)`
- Padding: `24px`
- Border-radius: `var(--sigad-radius)` (16px)
- Margin-bottom: `16px`
- **Nessuna elevation** — bordo sottile per leggerezza

### 4.3 KPI Cards — Pattern Opzionale

Usare solo quando ci sono **metriche aggregate significative** (conteggi entità correlate).

```razor
<MudGrid Spacing="3" Class="mb-4">
    <MudItem xs="12" sm="6" md="3">
        <MudPaper Elevation="0" Class="sigad-kpi-card">
            <MudText Typo="Typo.caption" Color="Color.Secondary">Sedi</MudText>
            <MudText Typo="Typo.h4" Color="Color.Primary">@_sediCount</MudText>
        </MudPaper>
    </MudItem>
    <!-- ripetere per ogni KPI -->
</MudGrid>
```

**Regole KPI:**
- Max **4 KPI** per riga
- Solo numeri interi, mai decimali
- Click sul KPI → scroll/switch al tab corrispondente
- Se il conteggio è 0 → mostrare "0" con opacità ridotta, non nascondere

### 4.4 Tabs — Pattern Standard

```razor
<MudPaper Elevation="0" Class="sigad-tabs-container">
    <MudTabs @bind-ActivePanelIndex="_activeTab"
             Rounded="true"
             ApplyEffectsToContainer="true"
             PanelClass="pa-6"
             Class="sigad-tabs">

        <MudTabPanel Text="@GetTabText("Panoramica")"
                     Icon="@Icons.Material.Outlined.Info">
            <!-- Panoramica: campi principali in grid DL -->
            <DetailOverview Entity="@entity" />
        </MudTabPanel>

        <MudTabPanel Text="@GetTabText("Sedi", _sediCount)"
                     Icon="@Icons.Material.Outlined.LocationOn"
                     BadgeData="@_sediCount"
                     BadgeColor="Color.Primary">
            <!-- Lazy-loaded: carica al primo click -->
            @if (_sediLoaded)
            {
                <SediTab Items="@_sedi" OnChanged="ReloadSedi" />
            }
            else
            {
                <MudProgressLinear Indeterminate="true" />
            }
        </MudTabPanel>

        <!-- ... altri tab -->
    </MudTabs>
</MudPaper>
```

**Regole Tabs:**
1. **Max 7 tab** visibili — oltre, usare scroll orizzontale (mai dropdown)
2. **Lazy loading** obbligatorio: caricare dati solo al primo click sul tab
3. **Conteggio nel label:** "Sedi (5)" — formato costante `"{Nome} ({count})"`
4. **Icona** per ogni tab — aiuta scanning visivo rapido
5. **Tab Panoramica** sempre primo — contiene i campi principali in sola lettura
6. **Persistent tab state:** il tab attivo sopravvive a reload dati

### 4.5 Section Card (dentro tab) — Pattern Standard

Ogni sezione di contenuto dentro un tab usa questo pattern:

```razor
<MudPaper Elevation="0" Class="sigad-section-card">
    <!-- Section header -->
    <MudStack Row="true" AlignItems="AlignItems.Center"
              Class="sigad-section-header">
        <MudText Typo="Typo.subtitle1">Sedi</MudText>
        <MudSpacer />
        <MudButton Variant="Variant.Outlined"
                   Size="Size.Small"
                   Color="Color.Primary"
                   StartIcon="@Icons.Material.Filled.Add"
                   OnClick="OpenAddSede">
            Aggiungi sede
        </MudButton>
    </MudStack>

    <MudDivider Class="mb-4" />

    <!-- Section content -->
    <MudTable Items="@_sedi" Dense="true" Hover="true" ...>
        <!-- ... -->
    </MudTable>
</MudPaper>
```

### 4.6 Definition List (Panoramica) — Pattern Standard

Per i campi in sola lettura nella tab Panoramica:

```razor
<MudGrid Spacing="4">
    <MudItem xs="12" md="6">
        <dl class="sigad-dl">
            <div class="sigad-dl-item">
                <dt>Denominazione</dt>
                <dd>@entity.Denominazione</dd>
            </div>
            <div class="sigad-dl-item">
                <dt>Partita IVA</dt>
                <dd>@entity.PartitaIva</dd>
            </div>
            <!-- ... -->
        </dl>
    </MudItem>
    <MudItem xs="12" md="6">
        <!-- seconda colonna -->
    </MudItem>
</MudGrid>
```

**CSS:**
```css
.sigad-dl-item { margin-bottom: 16px; }
.sigad-dl-item dt {
    font-size: 0.75rem;
    color: var(--sigad-text-secondary);
    text-transform: uppercase;
    letter-spacing: 0.04em;
    margin-bottom: 2px;
}
.sigad-dl-item dd {
    font-size: 0.95rem;
    color: var(--sigad-graphite);
    font-weight: 500;
}
```

---

## SEZIONE 5 — TABELLE ENTERPRISE IDEALI

### 5.1 Configurazione Standard MudTable

```razor
<MudTable @ref="_table"
          T="OrganizzazioneDto"
          ServerData="LoadServerData"
          Dense="true"
          Hover="true"
          Striped="false"
          FixedHeader="true"
          FixedFooter="true"
          Height="@(_tableHeight)"
          MultiSelection="true"
          @bind-SelectedItems="_selectedItems"
          RowClass="sigad-table-row"
          RowClassFunc="GetRowClass"
          OnRowClick="OnRowClicked"
          Loading="@_isLoading"
          LoadingProgressColor="Color.Primary"
          Elevation="0"
          Class="sigad-table">

    <HeaderContent>
        <MudTh><MudTableSortLabel T="OrganizzazioneDto"
                SortLabel="denominazione">
            Denominazione
        </MudTableSortLabel></MudTh>
        <MudTh Style="width:140px">P.IVA</MudTh>
        <MudTh Style="width:100px">Stato</MudTh>
        <MudTh Style="width:60px"></MudTh> <!-- actions -->
    </HeaderContent>

    <RowTemplate>
        <MudTd DataLabel="Denominazione">
            <a href="/organizzazioni/@context.Id?returnUrl=@_returnUrl"
               class="sigad-table-link">
                @context.Denominazione
            </a>
        </MudTd>
        <MudTd DataLabel="P.IVA">
            <MudText Typo="Typo.body2" Class="sigad-mono">
                @context.PartitaIva
            </MudText>
        </MudTd>
        <MudTd DataLabel="Stato">
            <MudChip T="string" Size="Size.Small"
                     Color="@GetStatoColor(context.StatoId)"
                     Variant="Variant.Tonal">
                @context.StatoDescrizione
            </MudChip>
        </MudTd>
        <MudTd Style="text-align:right">
            <MudMenu Icon="@Icons.Material.Filled.MoreVert"
                     Size="Size.Small" Dense="true"
                     AnchorOrigin="Origin.BottomRight"
                     TransformOrigin="Origin.TopRight">
                <MudMenuItem Icon="@Icons.Material.Filled.Visibility"
                             OnClick="() => Preview(context)">
                    Anteprima
                </MudMenuItem>
                <MudMenuItem Icon="@Icons.Material.Filled.Edit"
                             Href="@($"/organizzazioni/{context.Id}/modifica")">
                    Modifica
                </MudMenuItem>
                <MudDivider />
                <MudMenuItem Icon="@Icons.Material.Filled.Delete"
                             IconColor="Color.Error"
                             OnClick="() => ConfirmDelete(context)">
                    Elimina
                </MudMenuItem>
            </MudMenu>
        </MudTd>
    </RowTemplate>

    <NoRecordsContent>
        <!-- Empty state component -->
    </NoRecordsContent>

    <PagerContent>
        <MudTablePager PageSizeOptions="@(new[] { 20, 50, 100 })"
                       RowsPerPageString="Righe per pagina"
                       InfoFormat="{first_item}-{last_item} di {all_items}" />
    </PagerContent>
</MudTable>
```

### 5.2 Regole Tabelle

| Aspetto | Regola | Motivo |
|---------|--------|--------|
| **Densità** | Sempre `Dense="true"` | Più righe visibili, meno scroll |
| **Hover** | Sempre `Hover="true"` | Feedback visivo riga corrente |
| **Striped** | Mai `Striped="true"` | Interferisce con hover e selezione |
| **FixedHeader** | Sempre `true` | Header sempre visibile durante scroll |
| **Elevation** | `0` — bordo sottile | Coerenza con il design system piatto |
| **Paginazione** | Server-side, `20/50/100` righe | Performance su dataset grandi |
| **Selezione** | `MultiSelection` quando servono azioni bulk | Checkbox prima colonna |
| **Link primario** | Prima colonna significativa come `<a>` link | Affordance navigazione |
| **Azioni** | Ultima colonna, `MudMenu` con `MoreVert` | Compatte, non affollano |
| **Sort** | `MudTableSortLabel` sulle colonne sortabili | Solo dove ha senso operativo |
| **Larghezze** | Fissare le colonne strette (Stato, Azioni) con `width` | Stabilità layout |

### 5.3 Stili Colonne Speciali

```css
/* Colonna link primario */
.sigad-table-link {
    color: var(--sigad-graphite);
    text-decoration: none;
    font-weight: 600;
    transition: color 150ms;
}
.sigad-table-link:hover {
    color: var(--sigad-ocra);
    text-decoration: underline;
}

/* Colonna monospace (P.IVA, CF, codici) */
.sigad-mono {
    font-family: 'Roboto Mono', monospace;
    font-size: 0.85rem;
    letter-spacing: 0.02em;
}

/* Riga soft-deleted */
.sigad-row-deleted {
    opacity: 0.5;
    text-decoration: line-through;
}
```

---

## SEZIONE 6 — NAVIGAZIONE IDEALE

### 6.1 Modello Mentale Navigazione

```
Dashboard
├── Anagrafiche
│   ├── Organizzazioni (lista)
│   │   ├── Nuova organizzazione (form)
│   │   └── Dettaglio organizzazione (tabs)
│   │       ├── Modifica (form)
│   │       └── Sub-entità (inline CRUD)
│   ├── Persone (lista)
│   │   └── Dettaglio persona (tabs)
│   ├── Incarichi (lista)
│   └── Dipendenti (lista → dettaglio)
├── GDPR
│   ├── Richieste
│   ├── Esercizio Diritti
│   ├── Registro Trattamenti
│   └── Data Breach
├── Configurazione
│   └── Tipologiche
└── Amministrazione
    └── Utenti / Ruoli / Permessi
```

### 6.2 Breadcrumb — Regole

**Struttura sempre uguale:**
```
Home > [Sezione] > [Pagina] > [Entità corrente]
```

**Esempi concreti:**
```
Home > Organizzazioni                              ← lista
Home > Organizzazioni > Acme S.r.l.               ← dettaglio
Home > Organizzazioni > Acme S.r.l. > Modifica    ← form edit
Home > Persone > Mario Rossi                       ← dettaglio persona
Home > Dipendenti > Mario Rossi                    ← dettaglio dipendente
```

**Regole:**
1. **Sempre clickable** tranne l'ultimo item (pagina corrente)
2. **Max 4 livelli** — se servono di più, collassare i livelli intermedi con "..."
3. **"Home"** come primo elemento punta sempre a `/`
4. **Ultimo elemento** mostra il nome dell'entità (non ID numerico)
5. **Durante loading** mostrare placeholder skeleton animato

### 6.3 ReturnUrl — Pattern

Il ritorno da dettaglio a lista deve preservare filtri e paginazione.

**Flusso:**
1. Lista costruisce `returnUrl` = URL corrente encodata (con filtri attivi)
2. Link al dettaglio include `?returnUrl={encoded}`
3. Dettaglio legge `[SupplyParameterFromQuery] ReturnUrl`
4. "Torna a [sezione]" naviga a `ReturnUrl` se presente, altrimenti fallback alla lista base

```csharp
// Nel codebehind della lista
private string BuildReturnUrl()
{
    var uri = Navigation.Uri;
    return Uri.EscapeDataString(new Uri(uri).PathAndQuery);
}

// Nella pagina dettaglio
[SupplyParameterFromQuery] public string? ReturnUrl { get; set; }

private string GetBackHref()
    => ReturnUrl != null
        ? Uri.UnescapeDataString(ReturnUrl)
        : "/organizzazioni";
```

### 6.4 Drawer Menu — Comportamento

| Stato | Comportamento |
|-------|---------------|
| **Active item** | Barra verticale ocra + sfondo highlight + testo bold |
| **Match rule** | `NavLinkMatch.Prefix` — `/organizzazioni/123` evidenzia "Organizzazioni" |
| **Sezioni** | Collassabili in modalità espansa, nascoste label in mini |
| **Hover** | Background sottile `rgba(255,255,255,0.06)` |
| **Tooltip** | Solo in modalità mini — nome voce menu |
| **Permessi** | Voci non autorizzate **completamente nascoste**, non disabilitate |

### 6.5 Flusso Lista → QuickDrawer → Dettaglio

```
1. Click riga tabella      → Apre QuickDrawer laterale (preview)
2. Click link denominazione → Naviga direttamente a Dettaglio
3. QuickDrawer "Apri scheda" → Naviga a Dettaglio (con returnUrl)
4. Dettaglio "Torna a..."   → Naviga a lista (con filtri preservati)
```

**QuickDrawer** = anteprima rapida (300px destra), non un sostituto della pagina dettaglio. Contiene solo: nome, campi chiave, azioni principali, link "Apri scheda completa".

---

## SEZIONE 7 — DESIGN SYSTEM SIGAD

### 7.1 Palette Colori

| Token | Hex | Uso |
|-------|-----|-----|
| `--sigad-graphite` | `#1a1a2e` | Testo primario, drawer background, titoli |
| `--sigad-ocra` | `#d4a574` | Accent primario, CTA, active state, focus |
| `--sigad-ecru` | `#f8f7f5` | Background pagina, aree neutre |
| `--sigad-white` | `#ffffff` | Surface card, tabelle, form |
| `--sigad-text-secondary` | `#666666` | Label, caption, placeholder |
| `--sigad-text-disabled` | `#bdbdbd` | Elementi disabilitati |
| `--sigad-line` | `rgba(26,26,46,0.12)` | Bordi, divider, separator |
| `--sigad-info` | `#0277bd` | Stato informativo |
| `--sigad-success` | `#2e7d32` | Conferma, stato attivo |
| `--sigad-warning` | `#f57c00` | Attenzione, scadenza |
| `--sigad-error` | `#c62828` | Errore, eliminazione |

**Regola:** l'ocra (`--sigad-ocra`) è riservato per **azioni primarie, active state e focus**. Mai usare come colore di sfondo per aree estese.

### 7.2 Tipografia

| Livello | Font | Peso | Dimensione | Uso |
|---------|------|------|------------|-----|
| **H4** | Montserrat | 800 | 2.125rem | Titolo pagina principale |
| **H5** | Montserrat | 800 | 1.5rem | Titolo pagina standard |
| **H6** | Montserrat | 800 | 1.25rem | Titolo sezione/card |
| **Subtitle1** | Open Sans | 600 | 1rem | Intestazione sezione interna |
| **Body1** | Open Sans | 400 | 0.95rem | Testo corpo principale |
| **Body2** | Open Sans | 400 | 0.875rem | Testo secondario, celle tabella |
| **Caption** | Open Sans | 400 | 0.75rem | Label, metadata, breadcrumb |
| **Code** | Roboto Mono | 400 | 0.85rem | P.IVA, CF, codici, ID |

**Regola line-height:** sempre ≥1.5 per body text, ≥1.2 per heading.

### 7.3 Spaziature (Spacing Scale)

Scala basata su **8px**:

| Token | Valore | Uso |
|-------|--------|-----|
| `spacing-1` | 4px | Margine interno chip, gap icona-testo |
| `spacing-2` | 8px | Gap tra elementi inline, padding minimo |
| `spacing-3` | 12px | Gap colonne filtri |
| `spacing-4` | 16px | Padding card interne, margin tra sezioni piccole |
| `spacing-5` | 20px | — |
| `spacing-6` | 24px | Padding card principale, margin PageHeader |
| `spacing-8` | 32px | Padding Content Area (desktop) |
| `spacing-10` | 40px | Separazione macro-sezioni |
| `spacing-12` | 48px | Padding empty state verticale |

**Regola MudBlazor:** usare `Spacing="3"` per `MudStack` tra elementi filtri, `Spacing="4"` per `MudGrid` tra card.

### 7.4 Elevazione e Bordi

| Livello | Uso | CSS |
|---------|-----|-----|
| **Elevation 0 + bordo** | Card, tabelle, sezioni (DEFAULT) | `border: 1px solid var(--sigad-line)` |
| **Elevation 1** | QuickDrawer, popover, dropdown | `box-shadow: 0 2px 8px rgba(0,0,0,0.08)` |
| **Elevation 4** | Dialog modali | `box-shadow: 0 8px 24px rgba(0,0,0,0.12)` |
| **Elevation 8** | Drawer laterale | `box-shadow: 4px 0 16px rgba(0,0,0,0.1)` |

**Regola:** preferire **bordi sottili** a ombre. L'ombra è riservata a elementi sovrapposti (overlay, popover, dialog). Le card nel contenuto hanno `Elevation="0"` con bordo.

### 7.5 Border Radius

| Contesto | Raggio | Motivo |
|----------|--------|--------|
| Card principali | 16px | Moderno, morbido |
| Chip, Badge | 16px (pill) | Coerenza con card |
| Button | 8px | Leggermente più squadrato dei card |
| Input field | 8px | Coerenza con button |
| Dialog | 16px | Coerenza con card |
| Table | 0px (dentro card) | Tabella fluida dentro container |
| Avatar | 50% (circolare) | Standard per persone/entità |

### 7.6 Stato Chip Colors

Pattern standard per stati entità:

```csharp
private Color GetStatoColor(string stato) => stato switch
{
    "Attivo" or "Attiva" => Color.Success,    // verde
    "Sospeso" or "Sospesa" => Color.Warning,  // arancio
    "Cessato" or "Cessata" or
    "Inattivo" or "Inattiva" => Color.Error,  // rosso
    "Bozza" => Color.Default,                  // grigio
    _ => Color.Info                            // blu
};
```

Usare sempre `Variant.Tonal` (sfondo leggero + testo colorato) per gli stati in tabella. `Variant.Filled` solo nell'hero card del dettaglio.

---

## SEZIONE 8 — PATTERN MUDBLAZOR CONSIGLIATI

### 8.1 Container e Layout

```razor
<!-- ✅ Pattern corretto: MaxWidth.False + max-width CSS -->
<MudContainer MaxWidth="MaxWidth.False" Class="sigad-content">
    <!-- max-width: 1440px via CSS -->
</MudContainer>

<!-- ❌ Evitare: MaxWidth fisso MudBlazor (non responsive) -->
<MudContainer MaxWidth="MaxWidth.Large">
```

### 8.2 Grid Responsivo

```razor
<!-- Pattern: 2 colonne desktop, 1 mobile -->
<MudGrid Spacing="4">
    <MudItem xs="12" md="6"><!-- colonna 1 --></MudItem>
    <MudItem xs="12" md="6"><!-- colonna 2 --></MudItem>
</MudGrid>

<!-- Pattern: KPI cards 4 colonne -->
<MudGrid Spacing="3">
    <MudItem xs="6" sm="6" md="3"><!-- KPI --></MudItem>
    <MudItem xs="6" sm="6" md="3"><!-- KPI --></MudItem>
    <MudItem xs="6" sm="6" md="3"><!-- KPI --></MudItem>
    <MudItem xs="6" sm="6" md="3"><!-- KPI --></MudItem>
</MudGrid>
```

### 8.3 MudStack — Uso Standard

```razor
<!-- Toolbar orizzontale (filtri, azioni) -->
<MudStack Row="true" AlignItems="AlignItems.Center" Spacing="3">
    <!-- elementi -->
</MudStack>

<!-- Layout verticale (sezioni pagina) -->
<MudStack Spacing="4">
    <HeroCard />
    <TabsContainer />
</MudStack>

<!-- Header sezione con azione a destra -->
<MudStack Row="true" AlignItems="AlignItems.Center">
    <MudText Typo="Typo.subtitle1">Titolo</MudText>
    <MudSpacer />
    <MudButton ...>Azione</MudButton>
</MudStack>
```

### 8.4 MudPaper — Standard

```razor
<!-- Card sezione (DEFAULT per tutto) -->
<MudPaper Elevation="0" Class="sigad-section-card">
    <!-- border: 1px solid var(--sigad-line), border-radius: 16px, padding: 24px -->
</MudPaper>

<!-- Card highlight (KPI, alert) -->
<MudPaper Elevation="0" Class="sigad-kpi-card">
    <!-- border-left: 3px solid var(--sigad-ocra) -->
</MudPaper>
```

### 8.5 MudTabs — Standard

```razor
<MudTabs @bind-ActivePanelIndex="_activeTab"
         Rounded="true"
         ApplyEffectsToContainer="true"
         PanelClass="pa-6"
         Border="true"
         Class="sigad-tabs">
    <MudTabPanel Text="@GetTabText("Nome", count)"
                 Icon="@Icons.Material.Outlined.X">
        @if (_dataLoaded)
        {
            <!-- contenuto -->
        }
        else
        {
            <MudProgressLinear Indeterminate="true" Color="Color.Primary" />
        }
    </MudTabPanel>
</MudTabs>
```

### 8.6 MudDialog — Standard

```razor
<!-- Conferma eliminazione (pattern riutilizzabile) -->
<MudDialog>
    <TitleContent>
        <MudStack Row="true" AlignItems="AlignItems.Center" Spacing="2">
            <MudIcon Icon="@Icons.Material.Filled.Warning" Color="Color.Error" />
            <MudText Typo="Typo.h6">Conferma eliminazione</MudText>
        </MudStack>
    </TitleContent>
    <DialogContent>
        <MudText>
            Sei sicuro di voler eliminare <strong>@itemName</strong>?
            Questa azione non può essere annullata.
        </MudText>
    </DialogContent>
    <DialogActions>
        <MudButton OnClick="Cancel" Variant="Variant.Text">Annulla</MudButton>
        <MudButton OnClick="Confirm" Variant="Variant.Filled" Color="Color.Error"
                   StartIcon="@Icons.Material.Filled.Delete">
            Elimina
        </MudButton>
    </DialogActions>
</MudDialog>
```

### 8.7 Form — Pattern Standard

```razor
<MudForm @ref="_form" @bind-IsValid="_isValid">
    <MudGrid Spacing="3">
        <MudItem xs="12" md="6">
            <MudTextField @bind-Value="_model.Nome"
                          Label="Nome *"
                          Required="true"
                          RequiredError="Campo obbligatorio"
                          Variant="Variant.Outlined"
                          Margin="Margin.Dense" />
        </MudItem>
        <MudItem xs="12" md="6">
            <MudSelect T="int?" @bind-Value="_model.TipoId"
                       Label="Tipo *"
                       Required="true"
                       Variant="Variant.Outlined"
                       Margin="Margin.Dense"
                       Dense="true">
                <!-- options -->
            </MudSelect>
        </MudItem>
    </MudGrid>

    <!-- Azioni form: SEMPRE in fondo a destra -->
    <MudStack Row="true" Justify="Justify.FlexEnd" Spacing="2" Class="mt-6">
        <MudButton Variant="Variant.Text" OnClick="Cancel">Annulla</MudButton>
        <MudButton Variant="Variant.Filled" Color="Color.Primary"
                   Disabled="@(!_isValid || _isSaving)"
                   StartIcon="@Icons.Material.Filled.Save"
                   OnClick="Save">
            @if (_isSaving) { <MudProgressCircular Size="Size.Small" Indeterminate="true" /> }
            else { <span>Salva</span> }
        </MudButton>
    </MudStack>
</MudForm>
```

**Regole Form:**
1. **Variant.Outlined** per tutti gli input — più leggibile di Filled
2. **Margin.Dense** — compattezza enterprise
3. **Label con asterisco** per campi obbligatori: `"Nome *"`
4. **Grid 2 colonne** (md="6") — massimizzare spazio senza scrollare
5. **Azioni a destra** — Annulla (Text) + Salva (Filled Primary)
6. **Loading state** sul bottone Save durante submit

### 8.8 Snackbar — Pattern Feedback

```csharp
// Successo
Snackbar.Add("Organizzazione salvata con successo", Severity.Success);

// Errore
Snackbar.Add("Errore durante il salvataggio. Riprova.", Severity.Error);

// Info
Snackbar.Add("3 elementi esportati", Severity.Info);
```

**Configurazione globale:**
```csharp
builder.Services.AddMudServices(config =>
{
    config.SnackbarConfiguration.PositionClass = Defaults.Classes.Position.BottomRight;
    config.SnackbarConfiguration.PreventDuplicates = true;
    config.SnackbarConfiguration.ShowCloseIcon = true;
    config.SnackbarConfiguration.VisibleStateDuration = 4000;
    config.SnackbarConfiguration.HideTransitionDuration = 200;
    config.SnackbarConfiguration.ShowTransitionDuration = 200;
    config.SnackbarConfiguration.SnackbarVariant = Variant.Filled;
});
```

---

## SEZIONE 9 — ANTI-PATTERN DA EVITARE

### 9.1 Layout

| ❌ Anti-Pattern | ✅ Pattern Corretto | Motivo |
|----------------|---------------------|--------|
| Elevation > 0 su card nel contenuto | `Elevation="0"` + bordo | Troppe ombre = rumore visivo |
| Padding inconsistente tra pagine | CSS class `sigad-content` uniforme | Consistenza |
| Scroll orizzontale su tabella | Colonne responsive o collassabili | Frustrante su desktop |
| Tabella senza FixedHeader | Sempre `FixedHeader="true"` | Header non visibile = disorientamento |
| Contenuto full-width su ultra-wide | `max-width: 1440px` centrato | Righe troppo lunghe illeggibili |

### 9.2 Componenti

| ❌ Anti-Pattern | ✅ Pattern Corretto | Motivo |
|----------------|---------------------|--------|
| `Variant.Filled` su tutti i bottoni | Solo primary action è Filled | Gerarchia azioni persa |
| `Color.Primary` ovunque | Primary solo su CTA principale | Diluisce il focus |
| Input `Variant.Filled` | Sempre `Variant.Outlined` | Più leggibile, bordi chiari |
| Dialog per ogni operazione CRUD | Inline CRUD dentro tab/sezione | Meno context-switch |
| Tab come menu navigazione | Tab per viste dello stesso contesto | Abuso semantico |
| Chip per ogni campo metadata | Chip solo per stati/categorie | Overload visivo |

### 9.3 Navigazione

| ❌ Anti-Pattern | ✅ Pattern Corretto | Motivo |
|----------------|---------------------|--------|
| Breadcrumb stringa non clickable | Sempre `BreadcrumbItems` strutturati | Navigazione rotta |
| ID numerico nel breadcrumb | Nome entità (con fallback skeleton) | Non significativo per utente |
| Browser back come unico ritorno | Bottone "Torna a..." esplicito | Fragile, perde contesto |
| Perdita filtri su navigazione | `returnUrl` con query string | Frustrazione operativa |
| Menu items disabilitati | Nascondere voci non autorizzate | Confusione su permessi |

### 9.4 Dati

| ❌ Anti-Pattern | ✅ Pattern Corretto | Motivo |
|----------------|---------------------|--------|
| Tabella vuota senza messaggio | Empty state con icona + testo + CTA | Silenzio = incertezza |
| Loading senza feedback | Skeleton / ProgressLinear sempre | Utente pensa sia bloccato |
| Errore generico "Si è verificato un errore" | Messaggio specifico + azione | Non actionable |
| Caricare tutti i tab al mount | Lazy loading per tab | Performance |
| Client-side pagination su >100 righe | Sempre ServerData | Performance |
| `Striped="true"` su tabelle | Solo `Hover="true"` | Interferisce con selezione/stato |

### 9.5 Form

| ❌ Anti-Pattern | ✅ Pattern Corretto | Motivo |
|----------------|---------------------|--------|
| Validazione solo al submit | Validazione inline real-time | Feedback tardivo |
| Campi obbligatori senza asterisco | Sempre `"Label *"` con RequiredError | Ambiguo |
| Bottone Save senza loading state | ProgressCircular durante submit | Doppio click |
| Form che perde dati su navigazione | Conferma "Hai modifiche non salvate" | Data loss |
| Tutti i campi in una colonna | Grid 2 colonne (md="6") | Spreco spazio orizzontale |

---

## IMPLEMENTAZIONE — FILE CRITICI DA MODIFICARE

| File | Azione | Priorità |
|------|--------|----------|
| `Components/Theme/SigadTheme.cs` | Verificare allineamento palette/typography con sezione 7 | P0 |
| `wwwroot/app.css` | Aggiungere/allineare CSS variables e utility classes mancanti | P0 |
| `Components/Shared/PageHeader.razor` | Standardizzare: BreadcrumbItems obbligatorio, BackLabel/BackHref | P1 |
| `Components/Layout/MainLayout.razor` | Verificare container max-width e padding | P1 |
| `Components/Layout/NavMenu.razor` | Verificare permessi-based hiding e active state | P1 |
| `Components/Pages/Persone.razor` | Migrare a BreadcrumbItems strutturati | P2 |
| `Components/Pages/Persone/Dettaglio.razor` | Hero card standard, tab con icone e conteggi | P2 |
| `Components/Pages/RisorseUmane/Dipendenti.razor` | Allineare a pattern lista standard (FilterBar) | P2 |
| `Components/Pages/RisorseUmane/DettaglioDipendente.razor` | Hero card + tab standard | P2 |
| `Components/Pages/Gdpr/*.razor` | Allineare a pattern lista/dettaglio standard | P3 |

---

## VERIFICA

Dopo l'implementazione del redesign, verificare:

1. **Consistenza visiva:** tutte le pagine lista seguono lo stesso pattern (header → filtri → tabella)
2. **Consistenza dettaglio:** tutte le pagine dettaglio seguono lo stesso pattern (header → hero → tabs)
3. **Breadcrumbs:** tutte le pagine usano `BreadcrumbItems` strutturati e clickable
4. **ReturnUrl:** navigazione lista→dettaglio→lista preserva filtri
5. **Empty states:** nessuna tabella vuota senza messaggio
6. **Loading states:** skeleton o progress su ogni caricamento
7. **Azioni:** gerarchia corretta (Filled/Outlined/Text)
8. **Mobile:** drawer mini, tabelle responsive, form single-column
9. **Accessibilità:** ARIA labels su breadcrumbs, focus-visible, keyboard navigation
10. **Build:** `dotnet build Accredia.SIGAD.sln` → 0 errori
