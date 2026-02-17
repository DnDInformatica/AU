using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

internal interface IRisorseUmaneClient
{
    Task<(HttpStatusCode StatusCode, DipendenteDto? Value)> GetDipendenteAsync(int dipendenteId, CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, PagedResponse<DipendenteDto>? Value)> ListDipendentiAsync(
        int? personaId,
        string? matricola,
        string? q,
        int? statoDipendenteId,
        bool? includeDeleted,
        int? page,
        int? pageSize,
        CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyCollection<FormazioneInScadenzaDto>? Value)> GetFormazioneInScadenzaAsync(
        int days,
        CancellationToken cancellationToken);
    Task<(HttpStatusCode StatusCode, IReadOnlyCollection<DotazioneNonRestituitaCessatoDto>? Value)> GetDotazioniNonRestituiteCessatiAsync(
        CancellationToken cancellationToken);
}

internal sealed class RisorseUmaneClient(IHttpClientFactory httpClientFactory) : IRisorseUmaneClient
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    public async Task<(HttpStatusCode StatusCode, DipendenteDto? Value)> GetDipendenteAsync(
        int dipendenteId,
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("RisorseUmane");
        using var response = await client.GetAsync($"/v1/dipendenti/{dipendenteId}", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<DipendenteDto>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }

    public async Task<(HttpStatusCode StatusCode, PagedResponse<DipendenteDto>? Value)> ListDipendentiAsync(
        int? personaId,
        string? matricola,
        string? q,
        int? statoDipendenteId,
        bool? includeDeleted,
        int? page,
        int? pageSize,
        CancellationToken cancellationToken)
    {
        var query = new List<string>();
        if (personaId is not null)
        {
            query.Add($"personaId={personaId.Value}");
        }

        if (!string.IsNullOrWhiteSpace(matricola))
        {
            query.Add($"matricola={Uri.EscapeDataString(matricola)}");
        }

        if (!string.IsNullOrWhiteSpace(q))
        {
            query.Add($"q={Uri.EscapeDataString(q)}");
        }

        if (statoDipendenteId is not null && statoDipendenteId > 0)
        {
            query.Add($"statoDipendenteId={statoDipendenteId.Value}");
        }

        if (includeDeleted is not null)
        {
            query.Add($"includeDeleted={(includeDeleted.Value ? "true" : "false")}");
        }

        if (page is not null)
        {
            query.Add($"page={page.Value}");
        }

        if (pageSize is not null)
        {
            query.Add($"pageSize={pageSize.Value}");
        }

        var suffix = query.Count == 0 ? string.Empty : $"?{string.Join("&", query)}";

        var client = httpClientFactory.CreateClient("RisorseUmane");
        using var response = await client.GetAsync($"/v1/dipendenti{suffix}", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<PagedResponse<DipendenteDto>>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }

    public async Task<(HttpStatusCode StatusCode, IReadOnlyCollection<FormazioneInScadenzaDto>? Value)> GetFormazioneInScadenzaAsync(
        int days,
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("RisorseUmane");
        using var response = await client.GetAsync($"/v1/report/formazione-in-scadenza?days={days}", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<FormazioneInScadenzaDto[]>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }

    public async Task<(HttpStatusCode StatusCode, IReadOnlyCollection<DotazioneNonRestituitaCessatoDto>? Value)> GetDotazioniNonRestituiteCessatiAsync(
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("RisorseUmane");
        using var response = await client.GetAsync("/v1/report/dotazioni-non-restituite-cessati", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<DotazioneNonRestituitaCessatoDto[]>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }
}

internal sealed record DipendenteDto(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);

internal sealed record FormazioneInScadenzaDto(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly DataScadenza,
    int GiorniAllaScadenza);

internal sealed record DotazioneNonRestituitaCessatoDto(
    int DipendenteId,
    DateOnly DataCessazione,
    int DotazioneId,
    int TipoDotazioneId,
    string Descrizione,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool IsRestituito);
