\# Istruzioni per gli Agent del Progetto



Questo repository contiene un sistema backend basato su .NET per la gestione

dell’Identity, dell’Autenticazione e dell’Autorizzazione.



\## Linee Guida Generali



\- Preferire modifiche minime, mirate e controllate.

\- Evitare modifiche distruttive o incompatibili senza motivazione esplicita.

\- Preservare l’architettura esistente e i pattern adottati.

\- Applicare i principi SOLID e di Clean Architecture.



\## Stack Tecnologico



\- Piattaforma: .NET (ASP.NET Core, Minimal API)

\- Autenticazione: ASP.NET Identity + JWT Bearer

\- Autorizzazione: Policy-based con PermissionHandler personalizzato

\- Database: SQL Server con Entity Framework Core

\- Architettura: Modulare / Vertical Slice



\## Standard di Codifica



\- Utilizzare le funzionalità più recenti del linguaggio C# compatibili con il framework target.

\- Seguire le convenzioni Microsoft.

\- Utilizzare async/await per tutte le operazioni I/O.

\- Evitare chiamate sincrone a database o servizi remoti.

\- Blazor Server: quando un’operazione async aggiorna stato condiviso usato dalla UI (es. `UserContext`, menu, badge, ecc.), forzare un re-render al termine (`await InvokeAsync(StateHasChanged)` o equivalente). Non affidarsi a re-render “casuali” (es. toggle drawer) per far comparire/aggiornare contenuti.



\## Sviluppo delle API



\- Tutti gli endpoint devono:

&nbsp; - Restituire codici HTTP corretti

&nbsp; - Utilizzare DTO per le risposte

&nbsp; - Validare gli input

&nbsp; - Gestire correttamente gli errori



\- Gli endpoint API non devono restituire pagine HTML o redirect.

\- I fallimenti di autenticazione devono restituire solo 401/403.



\## Sicurezza



\- Non registrare mai token, password o segreti.

\- Verificare attentamente la configurazione JWT.

\- Applicare in modo coerente le policy di autorizzazione.

\- Evitare credenziali o chiavi hardcoded.



\## Database



\- Utilizzare le migrazioni per le modifiche allo schema.

\- Non modificare manualmente dati in ambienti di produzione.

\- Preferire LINQ al SQL raw, salvo casi motivati.



\## Test



\- Per ogni nuova funzionalità, prevedere test unitari o di integrazione.

\- Verificare che i test esistenti continuino a funzionare.



\## Documentazione



\- Aggiornare la documentazione in caso di modifiche alle API pubbliche.

\- Commentare il codice complesso quando necessario.



\## Checklist di Revisione



Prima di validare le modifiche, verificare che:



\- \[ ] Il progetto compili correttamente

\- \[ ] Non siano presenti warning

\- \[ ] Le autorizzazioni siano correttamente applicate

\- \[ ] Non vi siano regressioni di sicurezza

\- \[ ] Non vi siano refactoring non necessari



---



Fine delle istruzioni.



