# META PROMPT — Regole Operative Globali (SIGAD)

Questo META_PROMPT definisce **regole operative obbligatorie** valide per **tutti i prompt successivi**.
Le regole NON sono opzionali e prevalgono su qualsiasi istruzione ambigua o incompleta nei singoli prompt.

---

## AMBIENTE DI ESECUZIONE
- Sistema operativo: **Windows**
- Directory di lavoro (workspace unico e vincolante): **C:\Accredia\Sviluppo\AU**
- È consentito **scrivere file ed eseguire comandi esclusivamente** all’interno del workspace.
- È vietato scrivere o modificare qualsiasi cosa fuori dal workspace.

---

## PRINCIPI OPERATIVI OBBLIGATORI

### 1) PRE-CHECK
- **Prima di modificare qualsiasi cosa** devi eseguire un PRE-CHECK.
- Il PRE-CHECK deve produrre **una tabella di stato esplicita**, con almeno:
  - esistenza
  - conformità ai vincoli
  - azione prevista

Esempio minimo di tabella:
```
| Elemento | Esiste | Conforme | Azione |
```

### 2) VERIFICA E ONESTÀ DELL’OUTPUT
- **È vietato inventare file, configurazioni o risultati**.
- Se qualcosa non è verificabile tramite filesystem o comandi reali, devi dichiararlo esplicitamente come: **“non verificato”**.

### 3) IDEMPOTENZA
- Tutte le operazioni devono essere **idempotenti**:
  - se una risorsa **non esiste** → creala
  - se **esiste** → verifica e correggi
  - **non duplicare mai**
- Non lasciare mai il sistema in uno stato parziale o incoerente.

### 4) VINCOLI DI CONFIGURAZIONE
- Rispettare **sempre**:
  - porte fisse definite nei prompt
  - **un solo profilo DEV**
  - **solo HTTP in DEV**
- Vietato introdurre HTTPS, profili multipli o porte arbitrarie.

### 5) ACCESSO AI DATI
- **Dapper è OBBLIGATORIO** per l’accesso ai dati.
- **EF Core NON è consentito a runtime**.
- EF può essere utilizzato **solo** per design-time / migrations **se e solo se richiesto esplicitamente** in un prompt successivo.

### 6) POST-CHECK
- Alla fine di **ogni prompt** devi eseguire un POST-CHECK.
- Il POST-CHECK deve includere:
  - `dotnet clean`
  - `dotnet build`
  - verifica degli endpoint `/health` (curl o equivalente)

Se un POST-CHECK fallisce:
- correggi l’errore
- ripeti il POST-CHECK
- **non procedere** al prompt successivo.

### 7) GESTIONE DELL’INCERTEZZA
- Se manca un’informazione che **impedisce una decisione certa**:
  - **FERMATI**
  - spiega cosa manca
  - **chiedi esplicitamente** l’informazione necessaria
- È vietato fare assunzioni implicite.

---

## COMPORTAMENTO ATTESO
- Output conciso, tecnico, verificabile.
- Nessuna spiegazione superflua.
- Nessuna deviazione dall’obiettivo del prompt.
- Ogni azione deve essere giustificata da PRE-CHECK o POST-CHECK.

---

**Queste regole restano attive per tutta la sessione SIGAD.**
