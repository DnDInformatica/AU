using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

internal interface IAnagraficheClient
{
    Task<(HttpStatusCode StatusCode, PersonaDetailDto? Value)> GetPersonaByIdAsync(int personaId, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaEmailItem>? Value)> GetPersonaEmailAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaTelefonoItem>? Value)> GetPersonaTelefoniAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaIndirizzoItem>? Value)> GetPersonaIndirizziAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaQualificaItem>? Value)> GetPersonaQualificheAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaRelazionePersonaleItem>? Value)> GetPersonaRelazioniPersonaliAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<ConsensoPersonaItem>? Value)> GetPersonaConsensiAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<RichiestaGdprItem>? Value)> GetRichiesteGdprAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyList<RichiestaEsercizioDirittiItem>? Value)> GetRichiesteEsercizioDirittiAsync(int personaId, bool includeDeleted, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, PagedResponse<PersonaSearchItem>? Value)> SearchPersoneAsync(string q, int? page, int? pageSize, CancellationToken cancellationToken);
}

internal sealed class AnagraficheClient(IHttpClientFactory httpClientFactory) : IAnagraficheClient
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);
    private const string BasePath = "/v1/persone";

    public async Task<(HttpStatusCode StatusCode, PersonaDetailDto? Value)> GetPersonaByIdAsync(
        int personaId,
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("Anagrafiche");
        using var response = await client.GetAsync($"{BasePath}/{personaId}", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<PersonaDetailDto>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaEmailItem>? Value)> GetPersonaEmailAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<PersonaEmailItem>($"{BasePath}/{personaId}/email?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaTelefonoItem>? Value)> GetPersonaTelefoniAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<PersonaTelefonoItem>($"{BasePath}/{personaId}/telefoni?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaIndirizzoItem>? Value)> GetPersonaIndirizziAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<PersonaIndirizzoItem>($"{BasePath}/{personaId}/indirizzi?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaQualificaItem>? Value)> GetPersonaQualificheAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<PersonaQualificaItem>($"{BasePath}/{personaId}/qualifiche?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<PersonaRelazionePersonaleItem>? Value)> GetPersonaRelazioniPersonaliAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<PersonaRelazionePersonaleItem>($"{BasePath}/{personaId}/relazioni-personali?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<ConsensoPersonaItem>? Value)> GetPersonaConsensiAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<ConsensoPersonaItem>($"{BasePath}/{personaId}/consensi?includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<RichiestaGdprItem>? Value)> GetRichiesteGdprAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<RichiestaGdprItem>($"{BasePath}/richieste-gdpr?personaId={personaId}&includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public Task<(HttpStatusCode StatusCode, IReadOnlyList<RichiestaEsercizioDirittiItem>? Value)> GetRichiesteEsercizioDirittiAsync(
        int personaId,
        bool includeDeleted,
        CancellationToken cancellationToken)
        => GetListAsync<RichiestaEsercizioDirittiItem>($"{BasePath}/richieste-esercizio-diritti?personaId={personaId}&includeDeleted={ToBool(includeDeleted)}", cancellationToken);

    public async Task<(HttpStatusCode StatusCode, PagedResponse<PersonaSearchItem>? Value)> SearchPersoneAsync(
        string q,
        int? page,
        int? pageSize,
        CancellationToken cancellationToken)
    {
        var query = new List<string> { $"q={Uri.EscapeDataString(q)}" };
        if (page is not null)
        {
            query.Add($"page={page.Value}");
        }

        if (pageSize is not null)
        {
            query.Add($"pageSize={pageSize.Value}");
        }

        var client = httpClientFactory.CreateClient("Anagrafiche");
        using var response = await client.GetAsync($"{BasePath}/search?{string.Join("&", query)}", cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<PagedResponse<PersonaSearchItem>>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }

    private async Task<(HttpStatusCode StatusCode, IReadOnlyList<T>? Value)> GetListAsync<T>(
        string path,
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("Anagrafiche");
        using var response = await client.GetAsync(path, cancellationToken);
        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<List<T>>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto is null ? Array.Empty<T>() : dto);
    }

    private static string ToBool(bool value) => value ? "true" : "false";
}

internal sealed record PersonaDetailDto(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita,
    DateTime? DataCancellazione);

internal sealed record PersonaEmailItem(
    int PersonaEmailId,
    int PersonaId,
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica,
    DateTime? DataCancellazione);

internal sealed record PersonaTelefonoItem(
    int PersonaTelefonoId,
    int PersonaId,
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica,
    DateTime? DataCancellazione);

internal sealed record PersonaIndirizzoItem(
    int PersonaIndirizzoId,
    int PersonaId,
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo,
    DateTime? DataCancellazione);

internal sealed record PersonaQualificaItem(
    int PersonaQualificaId,
    int PersonaId,
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note,
    DateTime? DataCancellazione);

internal sealed record PersonaRelazionePersonaleItem(
    int PersonaRelazionePersonaleId,
    int PersonaId,
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note,
    DateTime? DataCancellazione);

internal sealed record ConsensoPersonaItem(
    int ConsensoPersonaId,
    int PersonaId,
    int TipoFinalitaTrattamentoId,
    bool Consenso,
    DateTime DataConsenso,
    DateTime? DataScadenza,
    DateTime? DataRevoca,
    string ModalitaAcquisizione,
    string? ModalitaRevoca,
    string? RiferimentoDocumento,
    string? IPAddress,
    string? UserAgent,
    string? MotivoRevoca,
    string? VersioneInformativa,
    DateTime? DataInformativa,
    string? Note,
    DateTime? DataCancellazione);

internal sealed record RichiestaGdprItem(
    int RichiestaGdprId,
    int? PersonaId,
    string NomeRichiedente,
    string CognomeRichiedente,
    string? EmailRichiedente,
    string? TelefonoRichiedente,
    int TipoDirittoInteressatoId,
    string Codice,
    DateTime DataRichiesta,
    string CanaleRichiesta,
    string? DescrizioneRichiesta,
    string? DocumentoIdentita,
    DateTime DataScadenzaRisposta,
    string Stato,
    int? ResponsabileGestioneId,
    DateTime? DataPresaInCarico,
    DateTime? DataRisposta,
    string? EsitoRichiesta,
    string? MotivoRifiuto,
    string? DescrizioneRisposta,
    string? ModalitaRisposta,
    string? RiferimentoDocumentoRisposta,
    string? Note,
    DateTime? DataCancellazione);

internal sealed record RichiestaEsercizioDirittiItem(
    int RichiestaEsercizioDirittiId,
    int? PersonaId,
    string NomeRichiedente,
    string EmailRichiedente,
    string? TelefonoRichiedente,
    string Codice,
    int TipoDirittoGdprId,
    DateTime DataRichiesta,
    string ModalitaRichiesta,
    string? TestoRichiesta,
    string? DocumentoRichiesta,
    bool IdentitaVerificata,
    DateTime? DataVerificaIdentita,
    string? ModalitaVerifica,
    DateTime DataScadenza,
    DateTime? DataProrogaRichiesta,
    string? MotivoProrogaRichiesta,
    string Stato,
    int? ResponsabileGestioneId,
    string? Note,
    DateTime? DataRisposta,
    string? EsitoRisposta,
    string? MotivoRifiuto,
    string? TestoRisposta,
    string? DocumentoRisposta,
    DateTime? DataEsecuzione,
    string? DatiCancellati,
    DateTime? DataCancellazione);

internal sealed record PersonaSearchItem(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);
