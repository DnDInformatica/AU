# PROMPT 2 — Database, Schema Ownership e Connection String
Reasoning Level: MEDIUM

REGOLE OPERATIVE (MANDATORY)
- Esegui in Windows, directory di lavoro: C:\Accredia\Sviluppo\AU
- È consentito scrivere file ed eseguire comandi solo nel workspace.
- Prima di modificare qualsiasi cosa fai PRE-CHECK e mostra tabella stato.
- Non inventare file o output: se non puoi verificare, dichiara “non verificato”.
- Tutto deve essere idempotente: se esiste, verifica e correggi; non duplicare.
- Rispetta porte fisse e profili DEV solo HTTP.
- Dapper è obbligatorio per accesso dati (niente EF runtime).
- Alla fine di ogni prompt esegui POST-CHECK (dotnet clean/build + test /health).
- Se manca un’informazione che impedisce una decisione certa: fermati e chiedi.

---

## Obiettivo
DB centrale con schema per servizio e connection string separate.

## Connection string
- Identity.Api → ConnectionStrings:IdentityDb
- Tipologiche.Api → ConnectionStrings:TipologicheDb
- Anagrafiche.Api → ConnectionStrings:AnagraficheDb

Le chiavi devono restare separate anche se puntano allo stesso DB in DEV.

## Schema ownership
- Identity → schema Identity
- Tipologiche → schema Tipologica
- Anagrafiche → schema Anagrafiche

Vietato creare oggetti in dbo.

## Accesso dati (HARD RULE)
- **Dapper obbligatorio** per l’accesso ai dati in tutti i servizi.
- **EF Core NON è consentito a runtime**.
- EF Core (se presente) può essere mantenuto solo per design-time/migrations **se richiesto esplicitamente in un prompt successivo**.

## Dapper (se usato)
- IDbConnectionFactory per servizio
- Vietato DefaultConnection
