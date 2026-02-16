# SIGAD Web E2E (Playwright)

## Prerequisiti
- Avviare `Accredia.SIGAD.Web` localmente.
- Impostare la base URL (opzionale):
  - `SIGAD_WEB_BASE_URL=http://localhost:5000`

## Installazione browser Playwright
```powershell
dotnet tool update --global Microsoft.Playwright.CLI
playwright install
```

## Esecuzione test
```powershell
dotnet test .\Accredia.SIGAD.Web.E2E
```

## Test coperti
- Presenza topbar, sottotitolo e ricerca globale
- Pagina login caricata
- Empty state ricerca globale con messaggio guida
- Sidebar con evidenza della voce attiva
