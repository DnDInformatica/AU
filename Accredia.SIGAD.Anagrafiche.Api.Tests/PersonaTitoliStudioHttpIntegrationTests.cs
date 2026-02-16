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

public sealed class PersonaTitoliStudioHttpIntegrationTests
{
    [Fact]
    public async Task ListCreateUpdateDelete_Works()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var tipoTitoloStudioId = await GetTipoTitoloStudioIdAsync(client);

        var personaId = 0;
        var personaTitoloStudioId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"TitTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var created = await CreateAsync(client, personaId, new
            {
                tipoTitoloStudioId,
                istituzione = "Universita Test",
                corso = "Informatica",
                dataConseguimento = DateTime.UtcNow.Date.AddDays(-1),
                voto = "110",
                lode = true,
                paese = "IT",
                note = "test",
                principale = true
            });
            personaTitoloStudioId = created.PersonaTitoloStudioId;
            Assert.True(created.Principale);
            Assert.True(created.Lode);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaTitoloStudioId == personaTitoloStudioId);

            var updated = await UpdateAsync(client, personaId, personaTitoloStudioId, new
            {
                tipoTitoloStudioId,
                istituzione = "Universita Test",
                corso = "Informatica",
                dataConseguimento = DateTime.UtcNow.Date.AddDays(-1),
                voto = "100",
                lode = false,
                paese = "IT",
                note = "updated",
                principale = true
            });
            Assert.Equal("100", updated.Voto);
            Assert.False(updated.Lode);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/titoli-studio/{personaTitoloStudioId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaTitoloStudioId == personaTitoloStudioId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaTitoloStudioId == personaTitoloStudioId);
        }
        finally
        {
            if (personaTitoloStudioId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/titoli-studio/{personaTitoloStudioId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetTipoTitoloStudioIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/titoli-studio/lookups");
        response.EnsureSuccessStatusCode();
        var root = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        var tipi = root?["tipi"]?.AsArray();
        return tipi?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoTitoloStudio lookup found.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaTitoloStudioDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/titoli-studio?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaTitoloStudioDto(
                item?["personaTitoloStudioId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["tipoTitoloStudioId"]?.GetValue<int>() ?? 0,
                item?["voto"]?.GetValue<string>(),
                item?["lode"]?.GetValue<bool>() ?? false,
                item?["principale"]?.GetValue<bool>() ?? false,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<PersonaTitoloStudioDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/titoli-studio", request);
        response.EnsureSuccessStatusCode();
        return ParseTitoloStudio(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaTitoloStudioDto> UpdateAsync(HttpClient client, int personaId, int personaTitoloStudioId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/titoli-studio/{personaTitoloStudioId}", request);
        response.EnsureSuccessStatusCode();
        return ParseTitoloStudio(await response.Content.ReadAsStringAsync());
    }

    private static PersonaTitoloStudioDto ParseTitoloStudio(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona titolo studio payload.");

        return new PersonaTitoloStudioDto(
            json["personaTitoloStudioId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["tipoTitoloStudioId"]?.GetValue<int>() ?? 0,
            json["voto"]?.GetValue<string>(),
            json["lode"]?.GetValue<bool>() ?? false,
            json["principale"]?.GetValue<bool>() ?? false,
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

    private sealed record PersonaTitoloStudioDto(
        int PersonaTitoloStudioId,
        int PersonaId,
        int TipoTitoloStudioId,
        string? Voto,
        bool Lode,
        bool Principale,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

