namespace Accredia.SIGAD.Shared.Permessi;

/// <summary>
/// Codici dei permessi IAM dell'applicazione SIGAD (interfaccia web e API;
/// database Accredia_SIDAC). Fonte: IAM.Permesso, applicazione 'SIGAD'
/// (migrazioni IAM 20261105_02 e 20261105_09). I codici non si scrivono come testo libero:
/// un refuso negherebbe l'accesso senza errori di compilazione.
/// </summary>
public static class PermessiSigad
{
    public static class Organizzazioni
    {
        public const string Accesso = "SIGAD.MODULE.ORG.ACCESS";
        public const string Elenco = "SIGAD.ORG.LIST";
        public const string Lettura = "SIGAD.ORG.READ";
        public const string Creazione = "SIGAD.ORG.CREATE";
        public const string Modifica = "SIGAD.ORG.UPDATE";
        public const string Cancellazione = "SIGAD.ORG.DELETE";
    }

    public static class Persone
    {
        public const string Accesso = "SIGAD.MODULE.PERS.ACCESS";
        public const string Elenco = "SIGAD.PERS.LIST";
        public const string Lettura = "SIGAD.PERS.READ";
        public const string Creazione = "SIGAD.PERS.CREATE";
        public const string Modifica = "SIGAD.PERS.UPDATE";
        public const string Cancellazione = "SIGAD.PERS.DELETE";
    }

    /// <summary>Documenti della persona: dati personali (decisione 10 del 2026-11-05).</summary>
    public static class DocumentiPersona
    {
        public const string Lettura = "SIGAD.PERS.DOC.READ";
        public const string Caricamento = "SIGAD.PERS.DOC.CREATE";
        public const string Eliminazione = "SIGAD.PERS.DOC.DELETE";
    }

    public static class Incarichi
    {
        public const string Accesso = "SIGAD.MODULE.INC.ACCESS";
        public const string Elenco = "SIGAD.INC.LIST";
        public const string Lettura = "SIGAD.INC.READ";
        public const string Creazione = "SIGAD.INC.CREATE";
        public const string Modifica = "SIGAD.INC.UPDATE";
        public const string Cancellazione = "SIGAD.INC.DELETE";
    }

    public static class Certificazioni
    {
        public const string Accesso = "SIGAD.MODULE.CERT.ACCESS";
        public const string Elenco = "SIGAD.CERT.LIST";
        public const string Lettura = "SIGAD.CERT.READ";
        public const string Creazione = "SIGAD.CERT.CREATE";
        public const string Modifica = "SIGAD.CERT.UPDATE";
        public const string Cancellazione = "SIGAD.CERT.DELETE";
    }

    public static class Tipologiche
    {
        public const string Accesso = "SIGAD.MODULE.TIPO.ACCESS";
        public const string Elenco = "SIGAD.TIPO.LIST";
        public const string Lettura = "SIGAD.TIPO.READ";
        public const string Creazione = "SIGAD.TIPO.CREATE";
        public const string Modifica = "SIGAD.TIPO.UPDATE";
        public const string Cancellazione = "SIGAD.TIPO.DELETE";
    }

    public static class RisorseUmane
    {
        public const string LetturaPersona = "SIGAD.HR.PERSONA.READ";

        public static class Dipendenti
        {
            public const string Elenco = "SIGAD.HR.DIP.LIST";
            public const string Lettura = "SIGAD.HR.DIP.READ";
            public const string Creazione = "SIGAD.HR.DIP.CREATE";
            public const string Modifica = "SIGAD.HR.DIP.UPDATE";
            public const string Cancellazione = "SIGAD.HR.DIP.DELETE";
        }

        public static class Contratti
        {
            public const string Elenco = "SIGAD.HR.CONTRATTI.LIST";
            public const string Lettura = "SIGAD.HR.CONTRATTI.READ";
            public const string Creazione = "SIGAD.HR.CONTRATTI.CREATE";
            public const string Modifica = "SIGAD.HR.CONTRATTI.UPDATE";
            public const string Cancellazione = "SIGAD.HR.CONTRATTI.DELETE";
        }

        public static class Dotazioni
        {
            public const string Elenco = "SIGAD.HR.DOTAZIONI.LIST";
            public const string Lettura = "SIGAD.HR.DOTAZIONI.READ";
            public const string Creazione = "SIGAD.HR.DOTAZIONI.CREATE";
            public const string Modifica = "SIGAD.HR.DOTAZIONI.UPDATE";
            public const string Cancellazione = "SIGAD.HR.DOTAZIONI.DELETE";
        }

        public static class Formazione
        {
            public const string Elenco = "SIGAD.HR.FORM.LIST";
            public const string Lettura = "SIGAD.HR.FORM.READ";
            public const string Creazione = "SIGAD.HR.FORM.CREATE";
            public const string Modifica = "SIGAD.HR.FORM.UPDATE";
            public const string Cancellazione = "SIGAD.HR.FORM.DELETE";
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
