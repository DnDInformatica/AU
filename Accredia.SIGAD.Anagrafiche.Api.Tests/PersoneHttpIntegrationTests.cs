using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class PersoneHttpIntegrationTests
{
    [Fact]
    public async Task CreateGetUpdateSoftDelete_SearchExcludesDeleted()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var codiceFiscale = NewFiscalCode();
        var cognomeBase = $"TestPersona_{DateTime.UtcNow:yyyyMMddHHmmss}";
        var personaId = 0;

        try
        {
            var created = await CreatePersonaAsync(client, new
            {
                cognome = cognomeBase,
                nome = "Mario",
                codiceFiscale,
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });

            personaId = created.PersonaId;
            Assert.Equal(cognomeBase, created.Cognome);
            Assert.Equal("Mario", created.Nome);
            Assert.Equal(codiceFiscale, created.CodiceFiscale);
            Assert.Null(created.DataCancellazione);

            var fetched = await GetPersonaAsync(client, personaId);
            Assert.Equal(personaId, fetched.PersonaId);
            Assert.Equal(cognomeBase, fetched.Cognome);

            var updated = await UpdatePersonaAsync(client, personaId, new
            {
                cognome = $"{cognomeBase}_UPD",
                nome = "Luigi",
                codiceFiscale,
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });

            Assert.Equal($"{cognomeBase}_UPD", updated.Cognome);
            Assert.Equal("Luigi", updated.Nome);

            var beforeDelete = await SearchPersoneAsync(client, $"{cognomeBase}_UPD");
            Assert.Contains(beforeDelete, item => item.PersonaId == personaId);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await GetPersonaAsync(client, personaId);
            Assert.NotNull(afterDelete.DataCancellazione);

            var afterSearch = await SearchPersoneAsync(client, $"{cognomeBase}_UPD");
            Assert.DoesNotContain(afterSearch, item => item.PersonaId == personaId);
        }
        finally
        {
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    [Fact]
    public async Task Create_DuplicateCodiceFiscale_ReturnsConflict()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var codiceFiscale = NewFiscalCode();
        var personaId = 0;

        try
        {
            var created = await CreatePersonaAsync(client, new
            {
                cognome = "DupCf",
                nome = "Primo",
                codiceFiscale,
                dataNascita = new DateTime(1985, 10, 20, 0, 0, 0, DateTimeKind.Utc)
            });

            personaId = created.PersonaId;

            var duplicateResponse = await client.PostAsJsonAsync("/anagrafiche/v1/persone", new
            {
                cognome = "DupCf2",
                nome = "Secondo",
                codiceFiscale,
                dataNascita = new DateTime(1987, 10, 20, 0, 0, 0, DateTimeKind.Utc)
            });

            Assert.Equal(HttpStatusCode.Conflict, duplicateResponse.StatusCode);
        }
        finally
        {
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    [Fact]
    public async Task SoftDelete_NotFound_WhenPersonaMissing()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var response = await client.DeleteAsync("/anagrafiche/v1/persone/2147483647");
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }

    private static string NewFiscalCode()
        => $"TS{Guid.NewGuid():N}".Substring(0, 16).ToUpperInvariant();

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaDetailDto> GetPersonaAsync(HttpClient client, int personaId)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}");
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaDetailDto> UpdatePersonaAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaListItemDto>> SearchPersoneAsync(HttpClient client, string query)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/search?q={Uri.EscapeDataString(query)}&page=1&pageSize=50");
        response.EnsureSuccessStatusCode();

        var root = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        var items = root?["items"]?.AsArray();
        return items?
            .Select(item => new PersonaListItemDto(
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["cognome"]?.GetValue<string>() ?? string.Empty,
                item?["nome"]?.GetValue<string>() ?? string.Empty))
            .ToList()
            ?? [];
    }

    private static PersonaDetailDto ParsePersona(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona payload.");

        return new PersonaDetailDto(
            json["personaId"]?.GetValue<int>() ?? 0,
            json["cognome"]?.GetValue<string>() ?? string.Empty,
            json["nome"]?.GetValue<string>() ?? string.Empty,
            json["codiceFiscale"]?.GetValue<string>(),
            json["dataNascita"]?.GetValue<DateTime>() ?? default,
            json["dataCancellazione"]?.GetValue<DateTime?>());
    }

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome,
        string? CodiceFiscale,
        DateTime DataNascita,
        DateTime? DataCancellazione);

    private sealed record PersonaListItemDto(
        int PersonaId,
        string Cognome,
        string Nome);
}
