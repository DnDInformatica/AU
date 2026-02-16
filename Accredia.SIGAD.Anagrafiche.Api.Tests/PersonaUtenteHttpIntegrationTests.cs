using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class PersonaUtenteHttpIntegrationTests
{
    [Fact]
    public async Task GetCreateUpdateDelete_Works()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = 0;
        var personaUtenteId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"UsrTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var getBefore = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/utente");
            Assert.Equal(HttpStatusCode.NotFound, getBefore.StatusCode);

            var created = await CreateAsync(client, personaId, new { userId = $"user_{Guid.NewGuid():N}" });
            personaUtenteId = created.PersonaUtenteId;

            var got = await GetAsync(client, personaId, includeDeleted: false);
            Assert.Equal(personaUtenteId, got.PersonaUtenteId);

            var updated = await UpdateAsync(client, personaId, personaUtenteId, new { userId = $"user_{Guid.NewGuid():N}" });
            Assert.NotEqual(created.UserId, updated.UserId);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var getAfter = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/utente");
            Assert.Equal(HttpStatusCode.NotFound, getAfter.StatusCode);

            var gotDeleted = await GetAsync(client, personaId, includeDeleted: true);
            Assert.Equal(personaUtenteId, gotDeleted.PersonaUtenteId);
            Assert.NotNull(gotDeleted.DataCancellazione);
        }
        finally
        {
            if (personaUtenteId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaUtenteDto> GetAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/utente?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        return ParsePersonaUtente(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaUtenteDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/utente", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaUtente(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaUtenteDto> UpdateAsync(HttpClient client, int personaId, int personaUtenteId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/utente/{personaUtenteId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaUtente(await response.Content.ReadAsStringAsync());
    }

    private static PersonaUtenteDto ParsePersonaUtente(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona utente payload.");

        return new PersonaUtenteDto(
            json["personaUtenteId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["userId"]?.GetValue<string>() ?? string.Empty,
            json["dataCancellazione"]?.GetValue<DateTime?>());
    }

    private static PersonaDetailDto ParsePersona(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona payload.");

        return new PersonaDetailDto(
            json["personaId"]?.GetValue<int>() ?? 0,
            json["cognome"]?.GetValue<string>() ?? string.Empty,
            json["nome"]?.GetValue<string>() ?? string.Empty);
    }

    private static string NewFiscalCode()
        => $"TS{Guid.NewGuid():N}".Substring(0, 16).ToUpperInvariant();

    private sealed record PersonaUtenteDto(
        int PersonaUtenteId,
        int PersonaId,
        string UserId,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

