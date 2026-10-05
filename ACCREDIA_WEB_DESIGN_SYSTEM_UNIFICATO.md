# Design System Web Accredia Unificato
## Un'unica identità per SIGAD (gestionale) e AccrediaPortale (portale pubblico)

**Data:** 05-10-2026 · **Stato:** proposta da validare prima dell'implementazione
**Fonte autorevole:** manuale Accredia **IO-01-01 rev.00 "Istruzione operativa d'uso Corporate Identity"** (approvato 03-12-2024), come codificato nella skill `accredia-corporate-identity`.

---

## 1. Principio

**Un solo linguaggio visivo, due superfici.** Palette, tipografia, bottoni, tabelle, stati e regole di contrasto sono identici nei due progetti. Diverso può essere solo il *guscio* contestuale: il Portale pubblico può avere hero e superfici di vetrina, SIGAD densità da gestionale. Ciò che rende riconoscibile un prodotto Accredia — colori, font, chrome, pattern di tabella e feedback — non varia mai.

## 2. ⚠️ Discrepanza da sanare prima di iniziare

| Token | Skill Blazor (`brand-basics.md`) | **Manuale IO-01-01 (ufficiale)** |
|---|---|---|
| Grafite | `#2B2B26` | **`#2B2B21`** |
| Ocra | `#F39200` | **`#DE7E00`** |
| Ocra chiaro / 50% | `#F7BF57` | **`#EEBE80`** |
| Écru | `#EFEFEB` | **`#FCF2E5`** |

Facciamo riferimento al **manuale** (è il documento approvato dall'Ente) e aggiorniamo `brand-basics.md` della skill Blazor. In più il manuale porta due regole che decidono la questione colore:

> *"L'ocra va usato come filetto di accento, non come fondo"* — e l'unico ocra ammesso è `#DE7E00`.
> *"Il grafite sostituisce il nero quando è disponibile."*

Il manuale definisce anche i **colori secondari di comunicazione**, che diventano i nostri semantici: Blu Indaco `#004C97`, Verde Smeraldo `#008264`, Rosso Cardinale `#BA0C2F`.

## 3. Palette unificata — mappatura ruoli MudBlazor (identica nei due progetti)

### Tema chiaro

| Ruolo | Valore | Origine | Contrast (verificato) |
|---|---|---|---|
| Primary (azioni, bottoni, selezioni) | Grafite `#2B2B21` | manuale | ~14:1 su bianco ✅ |
| PrimaryContrastText | `#FFFFFF` | — | ✅ |
| Secondary (accenti, chip, badge) | Ocra `#DE7E00` | manuale | testo grafite sopra: ~4.9:1 ✅ |
| SecondaryContrastText | `#2B2B21` | — | ✅ |
| Tertiary / link / Info | Blu Indaco `#004C97` | manuale | ~8.5:1 su bianco ✅ |
| Background | `#FFFFFF` | — | — |
| Surface | `#FFFFFF` | — | — |
| Superfici strutturate (intestazioni tabelle, pannelli filtri, chip attivi) | Écru `#FCF2E5` | manuale | testo grafite: ~13:1 ✅ |
| AppbarBackground / AppbarText | `#FFFFFF` / `#2B2B21` | — | logo a colori su chiaro ✅ |
| DrawerBackground / DrawerText | Grafite `#2B2B21` / Écru `#FCF2E5` | — | logo negativo sul drawer ✅ |
| TextPrimary / TextSecondary / Disabled | `#2B2B21` / `#5F5E5A` / `#BDBDBD` | manuale (grigio etichette) | ✅ |
| Success | Verde Smeraldo `#008264` | manuale | ~4.8:1 ✅ |
| Warning (testo leggibile) | Ocra scuro `#8A5A00` | manuale (etichette categorie) | ~5.9:1 ✅ |
| Error | Rosso Cardinale `#BA0C2F` | manuale (criticità) | ~6.6:1 ✅ |
| Info | Blu Indaco `#004C97` | manuale | ~8.5:1 ✅ |

### Tema scuro (opzionale, stesso sistema)

| Ruolo | Valore |
|---|---|
| Primary | Ocra 50% `#EEBE80` (~8.5:1 su grafite scuro ✅), contrast text grafite |
| Secondary | Ocra `#DE7E00` (~4.9:1 ✅) |
| Background / Surface | `#1E1E1A` / `#26261F` (grafite scurita, non blu navy) |
| Testo | Écru `#FCF2E5` (~13:1 ✅) / `#EEBE80` accenti |
| Info / Success / Error | varianti schiarite `#7EB1EB` / `#5FAE82` / `#D96D6D` |

**L'ocra chiaro `#EEBE80` è il "colore d'acqua alta" del tema scuro**: il manuale lo definisce accento secondario, noi lo usiamo come primary su fondo grafite — è l'unico modo brand-corretto di avere accenza calda ad alto contrasto.

### Regole d'uso dell'ocra (le tre che evitano gli errori passati)

1. **Mai fondo ocra saturo su grandi superfici** (bottoni primari, header, banner): è ciò che il manuale vieta esplicitamente. I bottoni primari sono **grafite**.
2. **L'ocra è un filetto e un accento**: bordo inferiore intestazioni tabelle (2px, come da manuale), indicatori attivi, badge con testo grafite, chip selezionati, dettagli decorativi.
3. **L'ocra come testo esiste in un solo modo**: ocra scuro `#8A5A00` su fondo chiaro. Mai `#DE7E00` come testo/link su bianco (~3:1, fallisce WCAG).

## 4. Tipografia (identica nei due progetti)

- **Testate:** Montserrat 700/800. **Corpo:** Open Sans 400/600/700. **Dati tecnici/ID:** Roboto Mono.
- Da recuperare **una volta sola, per entrambi i progetti** (stesso gap in SIGAD e Portale): `OpenSans-SemiBold.woff2` (600), `OpenSans-Bold.woff2` (700), `Montserrat-ExtraBold.woff2` (800). Oggi entrambi mappano i pesi mancanti sul file 400/700 — la gerarchia "bold" attualmente non esiste visivamente.
- I nomi famiglia restano namespaced (`"Open Sans Accredia"`, pattern già adottato nel Portale) per evitare collisioni con font di sistema.
- Nota: il manuale prescrive Arial per i documenti Office; per il web i due progetti hanno già standardizzato su Montserrat/Open Sans (asset nel brand package) — si mantiene, dichiarandolo nella pagina "Brand" del design system.

## 5. Chrome condiviso

| Elemento | Specifica unica |
|---|---|
| Topbar | Bianca, logo Accredia **a colori** a sinistra (min 60px, senza cornici/card), ricerca al centro (dove esiste), profilo a destra |
| Drawer/sidebar | **Grafite `#2B2B21`**, logo **negativo** in alto, testo écru, selezione voce con accento ocra (filetto o fondo `rgba(222,126,0,0.12)`) |
| Focus | Outline 2-3px grafite con offset; su fondi scuri outline ocra `#EEBE80`. **Mai** modificare `border-radius` nell'elemento focusato (bug attuale in SIGAD) |
| Skip-link | Primo elemento focusable, stile condiviso, target con `tabindex="-1"` |
| Radius | Scala condivisa `4/8/12/16/24`; default gestionale 8px, card vetrina 16-24px |
| Logo dark/light | Colori su sfondo chiaro, negativo su scuro — mai il negativo su bianco o il colori su grafite |

## 6. Tabelle dense — il pattern già definito dal manuale (da applicare a entrambi)

Il manuale IO-01-01 descrive esattamente come devono essere le tabelle tecniche dense; lo traduciamo in CSS condiviso:

| Elemento | Specifica (dal manuale) |
|---|---|
| Intestazione | fondo **Écru `#FCF2E5`**, testo grafite, **bordo inferiore ocra 2px** |
| Righe alternate | `#FDFCF9` (zebratura tenue, mai grigio pieno) |
| Separatori | riga 1px `#E8E5DA`, **nessun bordo verticale** |
| ID tecnici / chiavi | Roboto Mono, mai sottolineati |
| Etichette categoria | colore del testo (non pill), ocra scuro `#8A5A00` per le categorie principali |
| Criticità/anomalie | Rosso Cardinale `#BA0C2F`, riservato a ciò che richiede azione |
| Densità | token condivisi del Portale (`--row-height`, `--row-height-compact`, `--cell-padding-x/y`) |

Questo risolve in un colpo solo le incoerenze di densità e stile tabellare rilevate in SIGAD (4 pattern di loading, `Dense` misto, date e zebre diverse per sezione).

## 7. Stati e feedback

- Loading: **un solo pattern** per lista (`MudProgressLinear` sottile sotto l'header + skeleton solo al primo caricamento), definito nel design system, per entrambe le app.
- Errori utente: sempre frase di cortesia + azione ("Riprova", "Verifica stato servizi" in SIGAD); severità colorate con i semantici del §3, **mai colore da solo** (icona sempre presente).
- Snackbar: fondo superficie, icona colorata col semantico, testo grafite/écru.

## 8. Differenze ammesse tra i due prodotti (e non di più)

| | SIGAD (gestionale interno) | AccrediaPortale (pubblico) |
|---|---|---|
| Struttura shell | Topbar + drawer grafite collassabile | Header di vetrina (`portal-header`), navigazione propria |
| Superfici | Dense, bianche, radius 8px | Hero, radius 16-24px, respiro maggiore |
| Accenti per area | Non necessari | Token `--area-*` (plantati sulla palette unificata) |
| Tutto il resto | **Identico**: palette, font, bottoni, tabelle, stati, focus, dark mode |

## 9. Implementazione tecnica della condivisione

1. **Un file token, identico in entrambi i progetti:** `wwwroot/styles/accredia-tokens.css` con intestazione di versione (`/* Accredia Design Tokens v1.0 — fonte: IO-01-01 rev.00 */`). Nessuna sovrascrittura `--mud-palette-*` via CSS: il tema passa solo dal `MudTheme`.
2. **Una classe C# tema, identica in entrambi:** `AccrediaTheme.cs` (PaletteLight + PaletteDark + Typography) — copia conforme nei due progetti, con path di origine nel commento. Il Portale mantiene `@bind-IsDarkMode`; SIGAD eredita il dark mode "gratis" dallo stesso tema.
3. **Medium term (opzionale):** progetti Razor Class Library o pacchetto static-assets `Accredia.Portal.Design` per non duplicare; fino ad allora, file duplicati ma **bit-identici** e versionati.
4. **Pulizia conseguente:**
   - SIGAD: ritirare blu `#00519E` (override `!important` in `accredia-custom.css:16-19`), ocra mockup `#d4a574`, e i residui Bootstrap; unificare i 4 pattern di loading.
   - Portale: ritirare navy `#17355d` e oro `#c99a3a` (titolare il passaggio a grafite/ocra mantenendo la struttura token esistente, che è già buona); eliminare il deprecato `theme-dark.css`; ridurre i 60 `!important` di `portal-header.css`.
   - Entrambi: integrare i 3 file font mancanti; aggiornare `brand-basics.md` della skill Blazor ai valori del manuale.

## 10. Piano di adozione

| Passo | Contenuto | Impatto |
|---|---|---|
| 1 | Validare la palette (questo documento) → decisione colori definitiva | decisione |
| 2 | `accredia-tokens.css` v1 + `AccrediaTheme.cs` in entrambi i progetti | basso (nessuna pagina cambia se non i colori) |
| 3 | Chrome: topbar/drawer/focus/logo secondo §5 | medio |
| 4 | Pattern tabelle §6 nei moduli principali | medio |
| 5 | Pattern stati/feedback §7 + pulizia `!important` | medio |
| 6 | Dark mode (Portale già ce l'ha; SIGAD lo attiva) | basso |
| 7 | Verifica visiva congiunta 375/960/1920px su entrambe le app | QA |

---

*Verifica contrasti: valori WCAG calcolati sui HEX del manuale; tutti gli abbinamenti testo/fondo in tabella sono ≥ 4.5:1 salvo dove indicato come uso non-testuale.*
