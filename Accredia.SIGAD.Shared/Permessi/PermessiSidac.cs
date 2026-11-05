namespace Accredia.SIGAD.Shared.Permessi;

/// <summary>
/// Codici dei permessi IAM dell'applicazione SIDAC (database Accredia_SIDAC,
/// interfaccia SIGAD). Fonte: IAM.Permesso, applicazione 'SIDAC'
/// (migrazione IAM 20261105_02). I codici non si scrivono come testo libero:
/// un refuso negherebbe l'accesso senza errori di compilazione.
/// </summary>
public static class PermessiSidac
{
    public static class Organizzazioni
    {
        public const string Accesso = "SIDAC.MODULE.ORG.ACCESS";
        public const string Elenco = "SIDAC.ORG.LIST";
        public const string Lettura = "SIDAC.ORG.READ";
        public const string Creazione = "SIDAC.ORG.CREATE";
        public const string Modifica = "SIDAC.ORG.UPDATE";
        public const string Cancellazione = "SIDAC.ORG.DELETE";
    }

    public static class Persone
    {
        public const string Accesso = "SIDAC.MODULE.PERS.ACCESS";
        public const string Elenco = "SIDAC.PERS.LIST";
        public const string Lettura = "SIDAC.PERS.READ";
        public const string Creazione = "SIDAC.PERS.CREATE";
        public const string Modifica = "SIDAC.PERS.UPDATE";
        public const string Cancellazione = "SIDAC.PERS.DELETE";
    }

    /// <summary>Documenti della persona: dati personali (decisione 10 del 2026-11-05).</summary>
    public static class DocumentiPersona
    {
        public const string Lettura = "SIDAC.PERS.DOC.READ";
        public const string Caricamento = "SIDAC.PERS.DOC.CREATE";
        public const string Eliminazione = "SIDAC.PERS.DOC.DELETE";
    }

    public static class Incarichi
    {
        public const string Accesso = "SIDAC.MODULE.INC.ACCESS";
        public const string Elenco = "SIDAC.INC.LIST";
        public const string Lettura = "SIDAC.INC.READ";
        public const string Creazione = "SIDAC.INC.CREATE";
        public const string Modifica = "SIDAC.INC.UPDATE";
        public const string Cancellazione = "SIDAC.INC.DELETE";
    }

    public static class Certificazioni
    {
        public const string Accesso = "SIDAC.MODULE.CERT.ACCESS";
        public const string Elenco = "SIDAC.CERT.LIST";
        public const string Lettura = "SIDAC.CERT.READ";
        public const string Creazione = "SIDAC.CERT.CREATE";
        public const string Modifica = "SIDAC.CERT.UPDATE";
        public const string Cancellazione = "SIDAC.CERT.DELETE";
    }

    public static class Tipologiche
    {
        public const string Accesso = "SIDAC.MODULE.TIPO.ACCESS";
        public const string Elenco = "SIDAC.TIPO.LIST";
        public const string Lettura = "SIDAC.TIPO.READ";
        public const string Creazione = "SIDAC.TIPO.CREATE";
        public const string Modifica = "SIDAC.TIPO.UPDATE";
        public const string Cancellazione = "SIDAC.TIPO.DELETE";
    }

    public static class RisorseUmane
    {
        public const string LetturaPersona = "SIDAC.HR.PERSONA.READ";

        public static class Dipendenti
        {
            public const string Elenco = "SIDAC.HR.DIP.LIST";
            public const string Lettura = "SIDAC.HR.DIP.READ";
            public const string Creazione = "SIDAC.HR.DIP.CREATE";
            public const string Modifica = "SIDAC.HR.DIP.UPDATE";
            public const string Cancellazione = "SIDAC.HR.DIP.DELETE";
        }

        public static class Contratti
        {
            public const string Elenco = "SIDAC.HR.CONTRATTI.LIST";
            public const string Lettura = "SIDAC.HR.CONTRATTI.READ";
            public const string Creazione = "SIDAC.HR.CONTRATTI.CREATE";
            public const string Modifica = "SIDAC.HR.CONTRATTI.UPDATE";
            public const string Cancellazione = "SIDAC.HR.CONTRATTI.DELETE";
        }

        public static class Dotazioni
        {
            public const string Elenco = "SIDAC.HR.DOTAZIONI.LIST";
            public const string Lettura = "SIDAC.HR.DOTAZIONI.READ";
            public const string Creazione = "SIDAC.HR.DOTAZIONI.CREATE";
            public const string Modifica = "SIDAC.HR.DOTAZIONI.UPDATE";
            public const string Cancellazione = "SIDAC.HR.DOTAZIONI.DELETE";
        }

        public static class Formazione
        {
            public const string Elenco = "SIDAC.HR.FORM.LIST";
            public const string Lettura = "SIDAC.HR.FORM.READ";
            public const string Creazione = "SIDAC.HR.FORM.CREATE";
            public const string Modifica = "SIDAC.HR.FORM.UPDATE";
            public const string Cancellazione = "SIDAC.HR.FORM.DELETE";
        }
    }
}

/// <summary>
/// Permessi dell'applicazione IAM usati da SIGAD per le pagine provvisorie di
/// amministrazione (decisione 5: si tolgono con la console IAM in esercizio).
/// </summary>
public static class PermessiIam
{
    public const string AccessoConsole = "IAM.CONSOLE.ACCESS";
    public const string GestioneRuoli = "IAM.ROLES.MANAGE";
    public const string GestionePermessi = "IAM.PERMISSIONS.MANAGE";
    public const string GestioneUtenti = "IAM.USERS.MANAGE";
}
