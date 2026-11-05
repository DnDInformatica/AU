namespace Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

internal sealed class PersonaDocumentStorageOptions
{
    public const string SectionName = "DocumentStorage";

    public string Provider { get; set; } = "Local";
    public string BasePath { get; set; } = "App_Data/PersonaDocumenti";
    public WebDavOptions WebDav { get; set; } = new();

    internal sealed class WebDavOptions
    {
        public string? BaseUrl { get; set; }
        public string? Username { get; set; }
        public string? Password { get; set; }
        public string PasswordEnvVar { get; set; } = "DocumentStorage__WebDav__Password";
        public string RootPath { get; set; } = "PersonaDocumenti";
    }
}
