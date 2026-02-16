using System.Net;
using System.Net.Http.Json;
using System.Text.Json;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

internal interface IAnagraficheClient
{
    Task<(HttpStatusCode StatusCode, PersonaDetailDto? Value)> GetPersonaByIdAsync(int personaId, CancellationToken cancellationToken);
}

internal sealed class AnagraficheClient(IHttpClientFactory httpClientFactory) : IAnagraficheClient
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    public async Task<(HttpStatusCode StatusCode, PersonaDetailDto? Value)> GetPersonaByIdAsync(
        int personaId,
        CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("Anagrafiche");
        using var response = await client.GetAsync($"/v1/persone/{personaId}", cancellationToken);

        if (!response.IsSuccessStatusCode)
        {
            return (response.StatusCode, null);
        }

        var dto = await response.Content.ReadFromJsonAsync<PersonaDetailDto>(JsonOptions, cancellationToken);
        return (response.StatusCode, dto);
    }
}

internal sealed record PersonaDetailDto(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita,
    DateTime? DataCancellazione);

