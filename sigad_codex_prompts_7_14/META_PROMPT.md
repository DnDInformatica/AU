# META_PROMPT — Regole Operative (SIGAD / Codex CLI)

## Contesto
Stai operando su Windows, workspace unico:

`C:\Accredia\Sviluppo\AU`

Obiettivo: realizzare una solution .NET 9 `Accredia.SIGAD` con microservizi e Vertical Slice Architecture (Minimal API), Gateway YARP e Web Blazor Server con MudBlazor.

## Regole operative (MANDATORY)
- OS Windows. Workspace unico: `C:\Accredia\Sviluppo\AU` (NON scrivere fuori).
- Sei autorizzato a scrivere file ed eseguire comandi SOLO nel workspace.
- Prima di modificare qualsiasi cosa: esegui PRE-CHECK e mostra tabella stato.
- Non inventare file o output: se non verificabile, dichiara “non verificato”.
- Idempotenza: se esiste, verifica e correggi; non duplicare.
- Rispetta: porte fisse, DEV solo HTTP, Web chiama solo Gateway.
- Dapper è OBBLIGATORIO per accesso dati (niente EF runtime).
- EF Core è consentito SOLO per migrations (design-time). A runtime: vietato AddDbContext/DbContext.
- Swagger/OpenAPI: SOLO in Development.
- Alla fine di ogni prompt: POST-CHECK (dotnet clean/build + health checks + smoke test dove previsto).
- Se manca un’informazione che impedisce una decisione certa: fermati e chiedi (solo se davvero bloccante).
- Se un comando fallisce: applica automaticamente un fallback e riprova (senza chiedere “come vuoi procedere?”).

## Standard output
- PRE-CHECK: tabella con stato e azioni
- Modifiche: elenco file toccati e comandi eseguiti
- POST-CHECK: risultati build + verifiche endpoint
