# Accredia.SIDAC.Database — schema come codice

Progetto SQL (DacFx / Microsoft.Build.Sql) che rende lo schema di
`Accredia_SIDAC` un artefatto versionato accanto al codice applicativo.

## A che cosa serve

Prima di questo progetto, il legame fra applicazione e schema era implicito:
le query sono stringhe SQL letterali nei file `Handler.cs`, quindi una colonna
rinominata nel database non produceva alcun errore di compilazione — produceva
un `SqlException` a runtime, sulla funzionalità meno usata, il giorno che
qualcuno la apriva.

Con lo schema versionato si ottengono tre cose:

1. **Rilevamento del drift** fra schema atteso e database reale, in pipeline.
2. **Blocco delle modifiche distruttive** (`BlockOnPossibleDataLoss=True`).
3. **Schema riproducibile** per i test di integrazione.

## Procedura iniziale (una volta)

    dotnet tool install --global microsoft.sqlpackage   # già installato
    .\scripts\extract-schema.ps1

L'autenticazione è Entra ID interattiva: nessuna credenziale nei file di
configurazione o negli script.

Se l'esplosione automatica in file `.sql` non produce risultato, usare
Azure Data Studio o Visual Studio → *Create Project from Database* puntando al
`.dacpac` prodotto nella cartella temporanea (il percorso è stampato a video).

## Verifica del drift

    .\scripts\build.ps1              # o: dotnet build Accredia.SIDAC.Database.sqlproj
    .\scripts\verify-drift.ps1

Il report elenca gli oggetti divergenti e genera lo script di allineamento
**senza applicarlo**. In pipeline usare `-FailOnDrift` per bloccare il rilascio.

## Regole

- **L'applicazione non esegue DDL.** Le feature `Database/EnsureTables` e
  `Database/EnsureSchema` presenti nei servizi SIGAD vanno rimosse: creavano
  tabelle e vincoli a runtime, cosa incompatibile con un database dove il
  versionamento temporale, le tipologiche e i vincoli normativi sono governati
  centralmente.
- **Lo schema si modifica qui**, poi si applica al database dalla pipeline.
- **Le viste sono il contratto** verso l'applicazione: i `Handler` leggono viste,
  non tabelle, così le tabelle restano rifattorizzabili senza rompere il codice.

## Schema IAM

Lo schema `IAM` non è definito qui: la fonte è il repository `Accredia.IAM`
(`database/src/IAM`, migrazioni in `database/migrations`), decisione del
5 novembre 2026. Il progetto lo esclude dalla compilazione (`src\IAM\**`) e
il confronto usa `DropObjectsNotInSource=False`, quindi non ne propone la
rimozione. Dopo una nuova estrazione eliminare la cartella `src/IAM`.

## Riferimenti

- Ipotesi architetturale: AF-30
- Vincolo presidiato: TA-04 (attributi non storicizzati), R-17 (debito tecnico)
