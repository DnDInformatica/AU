# PROMPT 15 — Verifica Log e Stato Applicazione Accredia.SIGAD.Web
Reasoning Level: MEDIUM

## REGOLE OPERATIVE (MANDATORY)
- OS Windows.
- Workspace unico consentito: `C:\Accredia\Sviluppo\AU`.
- Operazione READ-ONLY: vietato modificare file, configurazioni o processi.
- Non inventare output: analizza esclusivamente ciò che è verificabile.
- Se un’informazione non è verificabile, dichiarare esplicitamente “non verificato”.
- Se vengono rilevati errori critici, NON correggere: solo analizzare e riportare.
- Usare esclusivamente comandi PowerShell di lettura (Get-*, Test-*, Select-*).
- Non generare codice applicativo.
- Nessuna modifica allo stato del sistema.

## OBIETTIVO
Eseguire una **verifica combinata** su:
1. File di log dell’applicazione **Accredia.SIGAD.Web**
2. Stato dell’applicazione Web (processo, porta, raggiungibilità)

al fine di determinare:
- se l’applicazione è correttamente avviata
- se presenta errori o warning significativi
- se comunica correttamente con il Gateway
- se esistono anomalie Blazor Server / MudBlazor

## FILE TARGET (LOG)
Percorso log:


## APPLICAZIONE TARGET
- Nome: Accredia.SIGAD.Web
- Tipo: Blazor Server
- Porta attesa (DEV): **7000**
- Comunicazione consentita: **solo verso Gateway (7100)**

---

## PRE-CHECK (OBBLIGATORIO)

### A) File di log
Verificare e riportare:

| Voce | Valore |
|-----|--------|
| File esiste | |
| Dimensione | |
| Ultima modifica | |
| Numero righe | |

### B) Stato applicazione Web
Verificare (READ-ONLY):

| Voce | Valore |
|-----|--------|
| Processo .NET attivo | |
| Porta 7000 in ascolto | |
| URL http://localhost:7000 raggiungibile | |
| Stato complessivo applicazione | OK / WARNING / ERROR |

> Se una verifica non è possibile, indicare “non verificato”.

---

## ANALISI LOG (READ-ONLY)

### 1) Errori critici
Individuare e riportare:
- Exception non gestite
- `fail`, `fatal`, `UnhandledException`
- Errori di startup Blazor Server
- Errori Kestrel / hosting
- Crash, restart o stop improvvisi

### 2) Warning rilevanti
Individuare:
- Warning MudBlazor
- Warning di rendering Blazor
- Warning SignalR / circuiti Blazor
- Timeout o retry verso Gateway
- Errori di autorizzazione (401 / 403)

### 3) Chiamate HTTP
Verificare dai log:
- Chiamate verso `http://localhost:7100` (CORRETTO)
- Evidenziare eventuali chiamate dirette a:
  - `http://localhost:7001`
  - `http://localhost:7002`
  - `http://localhost:7003`

(violazione architetturale: Web deve chiamare solo Gateway)

### 4) Correlation & logging
Verificare:
- Presenza di `X-Correlation-Id`
- Coerenza tra richieste e risposte
- Eventuali richieste senza correlation id

---

## OUTPUT ATTESO

### A) Sintesi esecutiva
- Stato applicazione Web: **OK / WARNING / ERROR**
- Stato log: **OK / WARNING / ERROR**
- Numero totale errori
- Numero totale warning

### B) Tabella eventi significativi
| Timestamp | Livello | Componente | Messaggio sintetico |
|----------|--------|------------|---------------------|

### C) Stato applicazione
- Processo: attivo / non attivo
- Porta: aperta / non in ascolto
- Raggiungibilità Web: sì / no / non verificato

### D) Anomalie architetturali (se presenti)
- Chiamate dirette API
- Errori Gateway
- Problemi MudBlazor / UI
- Errori Blazor Server

### E) Raccomandazioni (NO codice)
- Solo indicazioni diagnostiche
- Nessuna modifica suggerita
- Nessun refactoring automatico
