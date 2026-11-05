# Segreti e rotazioni (5 novembre 2026)

> Ricognizione fatta dallo sviluppo il 2026-11-05. Nessun valore segreto è
> riportato qui. Le rotazioni sono operazioni da far eseguire a chi gestisce
> l'ambiente (utente, DBA o funzione IT) e da verificare con il referente
> sicurezza.

## 1. Che cosa è esposto

| Segreto | Dove si trova | Esposizione | Azione |
|---|---|---|---|
| Password di `sa` del SQL Server locale (Docker, porta 1434; usata anche per la copia sulla 1435) | cronologia git di SIGAD (`appsettings*.json` fino al commit `7365a31`, `tmp_dapper_check.cs`) e del Portale (due commit del 2026); script locali | **Su GitHub**, in commit già pubblicati: chiunque abbia accesso ai repository la conosce | **Cambiare la password** dei container SQL locali e aggiornare `.env`, user-secrets e variabili d'ambiente. Non riscrivere la cronologia: costa più della rotazione |
| Chiave Data Protection di SIGAD.Web (anello di chiavi di sviluppo `.keys`) | cronologia git di SIGAD (`origin/main`, file `key-d7754f0d…xml`) | **Su GitHub** | **Rigenerare l'anello di sviluppo**: con l'applicazione ferma, svuotare `Accredia.SIGAD.Web/.keys`; al riavvio se ne crea uno nuovo (le sessioni aperte decadono). Verificare che nessun ambiente diverso dallo sviluppo usi quell'anello |
| Password della chiave master di Accredia_SIDAC | solo nello script locale `Database/src/Security/Chiave master.sql`, mai versionato | Nessuna fuori dalla postazione | Vedi sezione 3 |
| Password dell'utente di prova per la validazione staging | default nello script locale `scripts/m8_staging_validation.ps1`, mai versionato | Nessuna fuori dalla postazione | Rimossa dallo script (ora `SIGAD_STAGING_ADMIN_PASSWORD`); cambiarla se riusata altrove |

## 2. Che cosa è cambiato nel codice (branch `chore/segreti-fuori-dal-codice`)

- `scripts/clone-1434-to-1435.ps1`: la password della sorgente arriva da
  `SIGAD_SOURCE_SQL_PASSWORD` (o dal parametro); senza, lo script si ferma.
- `scripts/m8_staging_validation.ps1`: la password arriva da
  `SIGAD_STAGING_ADMIN_PASSWORD` (o dal parametro), salvo `-SkipLogin`.
- `scripts/m8_release_env_validation.ps1`: tolta dall'elenco dei valori deboli
  una password reale; l'elenco contiene solo segnaposto.
- `Database/src/Security/Chiave master.sql`: `CREATE MASTER KEY;` senza
  password. Il file è incluso nel progetto del database (SDK-style): con la
  password dentro sarebbe finita anche nel pacchetto compilato.
- `tmp_dapper_check.cs`: tolto dal repository (prova usa e getta con stringa
  di connessione); `.gitignore` esclude `tmp_*.cs`.

Ora i tre script e lo script della chiave master possono essere versionati.

## 3. Chiave master di Accredia_SIDAC

La chiave master del database (creata il 2026-06-12) protegge le tre
credenziali con ambito database delle origini esterne
(`CRED_StagingGIDAS_Reader`, `StagingSIACCredential`, `CRED_StagingSIA_Reader`).
Su Azure SQL è cifrata anche dalla chiave del servizio e si apre da sola: il
funzionamento non dipende dalla password.

**Attenzione:** riscrivendo lo script locale, il 2026-11-05 lo sviluppo ha
sovrascritto l'unica copia locale nota della password (il file non era
versionato). Se la password non è conservata altrove (gestore di password,
Key Vault), va sostituita. La sostituzione non richiede la password vecchia:

```sql
-- Su Accredia_SIDAC, in SSMS, da chi amministra il database.
-- La nuova password va generata e conservata in Key Vault prima di eseguire.
ALTER MASTER KEY REGENERATE WITH ENCRYPTION BY PASSWORD = '<nuova password da Key Vault>';
```

`REGENERATE` ricifra le credenziali protette; da eseguire in un momento in cui
le origini esterne non sono in uso e da verificare subito dopo con una lettura
da ciascuna (`ExtGIDAS`, `ExtSIA`, staging SIAC).

Le password degli utenti di lettura degli staging (`sidac_external_reader` e
gli altri) non sono nel repository: la loro rotazione segue la politica del
DBA (`ALTER LOGIN` sul server di staging, poi `ALTER DATABASE SCOPED
CREDENTIAL ... WITH SECRET` su Accredia_SIDAC).

## 4. Per l'esercizio

- Data Protection fuori dallo sviluppo: anello di chiavi condiviso e protetto
  (ad esempio Azure Blob Storage con protezione Key Vault), mai la cartella
  `.keys` del progetto.
- Nessuna password SQL nelle configurazioni: identità gestita o Entra
  (`Active Directory Default`), come per Portale e IAM.

## Da verificare

- Con il referente sicurezza: se la presenza della password di `sa` nella
  cronologia richiede, oltre alla rotazione, una segnalazione interna.
- Con la funzione IT: se l'anello Data Protection di sviluppo è stato copiato
  in qualche ambiente condiviso.
