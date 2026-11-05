using Microsoft.Extensions.Hosting;

namespace Accredia.SIGAD.Shared.Auth;

/// <summary>
/// Nomi degli schemi di autenticazione. Due emittenti Entra distinti:
/// il tenant istituzionale per il personale ACCREDIA, il tenant esterno
/// (External ID) per referenti dei CAB e ispettori. L'emittente stabilisce
/// CHI e' il soggetto; ruoli, permessi e ambito provengono sempre da IAM.
/// Riferimento: AF-31 cap. 2.
/// </summary>
public static class AuthSchemes
{
    /// <summary>Schema selettore: instrada allo schema corretto per richiesta.</summary>
    public const string Selector  = "Sigad";
    public const string Workforce = "EntraWorkforce";
    public const string External  = "EntraExternal";
}

/// <summary>
/// PROFILO DI AUTENTICAZIONE PER LO SVILUPPO - RF-064.
///
/// Sostituisce la sola verifica dell'emittente: la risoluzione su IAM,
/// i permessi e l'ambito restano identici al percorso di esercizio.
///
/// Quattro protezioni sovrapposte (AF-31 cap. 4.3):
///   1. Il gestore e' racchiuso in #if DEBUG: assente dai binari di rilascio.
///   2. Richiede ASPNETCORE_ENVIRONMENT=Development.
///   3. Richiede la variabile d'ambiente SIGAD_DEV_AUTH=1, che non risiede
///      in alcun file di configurazione versionabile.
///   4. Emette un avviso in log a ogni richiesta autenticata.
/// </summary>
public static class DevAuth
{
    public const string Schema = "DevAuth";
    public const string HeaderOid = "X-Dev-Oid";

    private const string VariabileAbilitazione = "SIGAD_DEV_AUTH";
    private const string VariabileOid = "SIGAD_DEV_OID";

    public static bool IsEnabled(IHostEnvironment env) =>
        env.IsDevelopment() &&
        Environment.GetEnvironmentVariable(VariabileAbilitazione) == "1";

    public static string? OidPredefinito =>
        Environment.GetEnvironmentVariable(VariabileOid);
}
