# Accredia.SIGAD.Gateway

## Scopo
Reverse proxy (YARP) per i servizi SIGAD. Gestisce routing, logging, tracing e rate limiting. Non autentica e non autorizza (RF-059).

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

## Autenticazione e autorizzazione
Dal 5 novembre 2026 il gateway instrada soltanto: nessuna rotta ha
`AuthorizationPolicy` e il gateway non valida token.

- Ogni API valida il token Entra (`AddSigadAuthentication`): senza token
  risponde 401, tranne `/health`.
- Ogni API autorizza per permesso IAM (`RichiedePermesso`, codici `SIDAC.*` e
  `IAM.*`).
- Identity.Api (in dismissione) applica da sé le proprie regole.
- La ricerca globale (`/search/global`) interroga Anagrafiche propagando il
  token del chiamante (`PropagazioneIdentitaHandler`).

Decisione: repository Accredia.IAM, `docs/decisioni/20261105-applicazione-iam-dedicata.md`.

## Rate Limiting
- Login: 10 req/min per IP
- Refresh: 20 req/min per IP

## Configurazione
File principali:
- `Accredia.SIGAD.Gateway\appsettings.json`
- `Accredia.SIGAD.Gateway\appsettings.Development.json`

