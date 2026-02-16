# Accredia.SIGAD.Gateway

## Scopo
Reverse proxy (YARP) per i servizi SIGAD. Gestisce routing, logging, tracing, rate limiting e policy di autorizzazione a livello gateway.

## Routing Principale
Tutte le chiamate verso Identity passano dal prefisso `/identity`.

Esempi:
- `/identity/v1/auth/login`
- `/identity/v1/auth/refresh`
- `/identity/v1/auth/logout`
- `/identity/v1/auth/logout/all`
- `/identity/v1/auth/logout/user/{userId}`
- `/identity/v1/auth/logout/users`
- `/identity/v1/me`
- `/identity/v1/roles` / `/identity/v1/roles/{roleId}/permissions`
- `/identity/v1/permissions`

## Policy e Autorizzazione
Il gateway valida i JWT e applica policy:
- `Authenticated`: richiede token valido
- `Admin`: richiede ruolo `SIGAD_ADMIN` o `SIGAD_SUPERADMIN`

Regole applicate:
- `/identity/v1/auth/login` e `/identity/v1/auth/refresh`: anonimi (no auth)
- `/identity/v1/auth/logout`: anonimo (no auth)
- `/identity/v1/auth/logout/user/**` e `/identity/v1/auth/logout/users`: `Admin`
- `/identity/v1/roles/**` e `/identity/v1/permissions**`: `Admin`
- tutto il resto sotto `/identity/**`: `Authenticated`

## Rate Limiting
- Login: 10 req/min per IP
- Refresh: 20 req/min per IP

## Configurazione
File principali:
- `Accredia.SIGAD.Gateway\appsettings.json`
- `Accredia.SIGAD.Gateway\appsettings.Development.json`

La sezione `Jwt` deve usare gli stessi valori di Identity Api.

