namespace Accredia.SIGAD.Web.Sviluppo;

/// <summary>
/// Valori delle annotazioni data-dev-component e data-dev-source usate dal Dev
/// Inspector. In Debug restituisce il valore; in Release null, e Blazor non
/// scrive l'attributo: l'HTML di esercizio non contiene nomi di componenti né
/// percorsi dei sorgenti (decisione del 2026-11-05: strumento solo per sviluppo
/// e collaudo).
/// </summary>
public static class DevInspector
{
#if DEBUG
    public static string? Annota(string valore) => valore;
#else
    public static string? Annota(string valore) => null;
#endif
}
