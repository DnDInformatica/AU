# PROMPT 11 — Gateway: routing + headers + DEV swagger passthrough
Reasoning Level: MEDIUM

## Obiettivo
Migliorare Gateway YARP:
- Correlation Id end-to-end
- Forward Authorization header
- Timeouts
- (DEV-only) swagger passthrough per comodità

## Implementazione
1) Correlation middleware (X-Correlation-Id)
2) Timeouts cluster (30s)
3) Aggiungere `GET /health` se manca
4) DEV-only swagger routes:
- /identity/swagger/{**catch-all} -> http://localhost:7001/swagger/{**catch-all}
- /tipologiche/swagger/{**catch-all} -> http://localhost:7002/swagger/{**catch-all}
- /anagrafiche/swagger/{**catch-all} -> http://localhost:7003/swagger/{**catch-all}

## POST-CHECK
- Build OK
- Gateway run, smoke proxy health
