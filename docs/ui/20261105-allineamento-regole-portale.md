# Interfaccia SIGAD: allineamento alle regole del Portale Accredia

> Analisi del 5 novembre 2026 (confronto tra Accredia.SIGAD.Web e le regole
> d'interfaccia del Portale: AGENTS.md, CLAUDE.md, docs/ui del Portale, tema e
> token condivisi). Le regole di stile vengono dalla decisione «schermate
> operative piatte» del Portale, **da validare** con il responsabile della
> Corporate Identity: valgono anche per SIGAD solo dopo quella conferma.

## Decisioni dell'utente (2026-11-05)

1. **Nomi:** la banca dati è Accredia_SIDAC; il portale per le anagrafiche è
   **SIGAD**. Nei testi dell'interfaccia si scrive «SIGAD». I codici dei
   permessi restano con il prefisso `SIDAC.` (applicazione IAM `SIDAC`).
2. **Stile:** un foglio di stile comune, copiato identico nei due progetti
   come `accredia-tokens.css` e `AccrediaTheme.cs`.
3. **Dev Inspector:** strumento solo per sviluppo e collaudo; nelle
   compilazioni di rilascio non deve esserci.

## Già allineato

- Tema e token identici al Portale (cambiano solo namespace e fine riga).
- Il Web non accede al database: solo HTTP verso il Gateway.
- Permessi da IAM (`/v1/me`), prefissati `SIDAC.`/`IAM.`; lingua italiana;
  skip link.

## Piano

| Fase | Contenuto | Stato |
|---|---|---|
| 1. Correttezza | costanti `PermessiSidac`/`PermessiIam` al posto dei codici scritti come testo; niente capacità dal nome del ruolo (`IsAdmin`); profili demo solo interni; controllo dei permessi nelle pagine scoperte (`RichiedePermesso`); messaggi d'errore comprensibili (`MessaggioErroreApi`); niente codici tecnici nei messaggi; Home senza KPI e attività inventati | fatta (questo branch) |
| 2. Lingua e accessibilità | localizzazione italiana di MudBlazor (paginatori), testi inglesi e pagina d'errore, testi autoreferenziali, un `h1` per pagina (anche per il focus alla navigazione), etichette dei pulsanti con sola icona, `PageTitle` su tutte le pagine | da fare |
| 3. Stile | foglio di stile operativo condiviso (copia identica), via ombre, gradiente, maiuscolo spaziato, hero; Bootstrap e stili inline da togliere gradualmente; registro delle icone condiviso | dopo la validazione della Corporate Identity |
| 4. Strumenti | `data-dev-component`/`data-dev-source` sulle 63 componenti, controllo in build; Dev Inspector caricato solo in Development e assente in Release | da fare |

## Fase 1: dettagli

- `Accredia.SIGAD.Shared/Permessi/PermessiSidac.cs`: 58 codici del catalogo
  IAM; nel Web 196 testi sostituiti, nessun codice sconosciuto.
- `NavMenu`: la sezione Amministrazione dipende da `IAM.CONSOLE.ACCESS`, non
  più dai ruoli `SIGAD_ADMIN`/`SIGAD_SUPERADMIN`; tolti `IsAdmin` e
  `HasRole` da `UserContext`.
- Profili demo: amministratore (tutti i permessi, letti dalle costanti),
  consultazione (sola lettura, senza dati del personale né documenti della
  persona), gestore risorse umane. Tolti i profili di organismo e ispettore.
- `RichiedePermesso` su 10 pagine: Organizzazioni (elenco, dettaglio,
  creazione, modifica, sedi e unità organizzative con il permesso di
  modifica, come nelle API), Persone, Tipologiche. Documenti è protetta dal
  suo pannello; Stato servizi resta aperta (diagnostica).
- `MessaggioErroreApi` (copia del Portale) in 18 pagine e nei due client
  verso le API, al posto di `ex.Message`.
- 36 messaggi riscritti senza codici: «Il tuo profilo non consente di
  modificare i contratti.»
- `AccessDenied`: contorno invece del fondo ocra pieno (testo secondario
  illeggibile), «Accesso negato».

Resta da valutare: i pulsanti di creazione e modifica dentro le pagine si
vedono anche senza permesso (la pagina di destinazione ora lo nega).
