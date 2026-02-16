using System.Net;
using System.Net.Http.Json;
using System.Text.Json.Nodes;

namespace Accredia.SIGAD.RisorseUmane.Api.Services;

internal interface IPersonaClient
{
    Task<bool> ExistsAsync(int personaId, CancellationToken cancellationToken);
}

internal sealed class PersonaClient(IHttpClientFactory httpClientFactory) : IPersonaClient
{
    public async Task<bool> ExistsAsync(int personaId, CancellationToken cancellationToken)
    {
        var client = httpClientFactory.CreateClient("Anagrafiche");

        using var response = await client.GetAsync($"/v1/persone/{personaId}", cancellationToken);
        if (response.StatusCode == HttpStatusCode.NotFound)
        {
            return false;
        }

        if (response.IsSuccessStatusCode)
        {
            // The endpoint returns a DTO; we don't need the body, just that it exists.
            return true;
        }

        // Try to preserve some context, without leaking secrets.
        var content = await response.Content.ReadAsStringAsync(cancellationToken);
        var json = JsonNode.Parse(content);
        var message = json?["title"]?.GetValue<string>()
                      ?? json?["error"]?.GetValue<string>()
                      ?? $"Unexpected response from Anagrafiche (StatusCode={(int)response.StatusCode}).";

        throw new HttpRequestException(message, null, response.StatusCode);
    }
}

