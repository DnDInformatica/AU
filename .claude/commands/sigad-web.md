# Web - Blazor Server + MudBlazor

Implementa il frontend Web con MudBlazor.

## REGOLE HARD
- Web chiama SOLO Gateway (http://localhost:7100)
- VIETATO chiamare direttamente le API

## CONFIGURAZIONE MUDBLAZOR
1. Package: `dotnet add package MudBlazor`
2. Program.cs: `builder.Services.AddMudServices();`
3. Layout/App: MudThemeProvider, MudDialogProvider, MudSnackbarProvider

## HTTP CLIENT
```csharp
// Program.cs
builder.Services.AddHttpClient("GatewayClient", client =>
{
    client.BaseAddress = new Uri("http://localhost:7100/");
});

// DelegatingHandler per Authorization + CorrelationId
```

## AUTENTICAZIONE
- Token in ProtectedSessionStorage
- Custom AuthenticationStateProvider
- Login page → POST /identity/auth/login

## PAGINE
1. **/login** - Form MudBlazor login
2. **/tipologiche** - Lista con MudTable
3. **/organizzazioni** - Lista con MudTable

## STRUTTURA SUGGERITA
```
Pages/
├── Login.razor
├── Tipologiche/
│   └── Index.razor
└── Organizzazioni/
    └── Index.razor
Services/
├── AuthService.cs
├── TipologicheService.cs
└── AnagraficheService.cs
```

## MUDBLAZOR COMPONENTS
- MudTextField per input
- MudButton per azioni
- MudTable per liste
- MudDialog per conferme
- MudSnackbar per notifiche

## POST-CHECK
- dotnet build
- Avvio porta 7000
- Test manuale UI
