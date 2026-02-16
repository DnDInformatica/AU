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

public sealed class PersonaRelazioniPersonaliHttpIntegrationTests
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

        var tipoRelazioneId = await GetTipoRelazioneIdAsync(client);
        var personaId = 0;
        var personaCollegataId = 0;
        var relazioneId = 0;

        try
        {
            var p1 = await CreatePersonaAsync(client, new
            {
                cognome = $"RelTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = p1.PersonaId;

            var p2 = await CreatePersonaAsync(client, new
            {
                cognome = $"RelTest2_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1991, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaCollegataId = p2.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var created = await CreateAsync(client, personaId, new
            {
                personaCollegataId,
                tipoRelazionePersonaleId = tipoRelazioneId,
                note = "test"
            });
            relazioneId = created.PersonaRelazionePersonaleId;

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaRelazionePersonaleId == relazioneId);

            var updated = await UpdateAsync(client, personaId, relazioneId, new
            {
                personaCollegataId,
                tipoRelazionePersonaleId = tipoRelazioneId,
                note = "updated"
            });
            Assert.Equal("updated", updated.Note);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali/{relazioneId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaRelazionePersonaleId == relazioneId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaRelazionePersonaleId == relazioneId);
        }
        finally
        {
            if (relazioneId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali/{relazioneId}");
            }
            if (personaCollegataId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaCollegataId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetTipoRelazioneIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/relazioni-personali/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoRelazionePersonale lookup found.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<RelazioneDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new RelazioneDto(
                item?["personaRelazionePersonaleId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["personaCollegataId"]?.GetValue<int>() ?? 0,
                item?["tipoRelazionePersonaleId"]?.GetValue<int>() ?? 0,
                item?["note"]?.GetValue<string>(),
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<RelazioneDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali", request);
        response.EnsureSuccessStatusCode();
        return ParseRelazione(await response.Content.ReadAsStringAsync());
    }

    private static async Task<RelazioneDto> UpdateAsync(HttpClient client, int personaId, int relazioneId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/relazioni-personali/{relazioneId}", request);
        response.EnsureSuccessStatusCode();
        return ParseRelazione(await response.Content.ReadAsStringAsync());
    }

    private static RelazioneDto ParseRelazione(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid relazione payload.");

        return new RelazioneDto(
            json["personaRelazionePersonaleId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["personaCollegataId"]?.GetValue<int>() ?? 0,
            json["tipoRelazionePersonaleId"]?.GetValue<int>() ?? 0,
            json["note"]?.GetValue<string>(),
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

    private sealed record RelazioneDto(
        int PersonaRelazionePersonaleId,
        int PersonaId,
        int PersonaCollegataId,
        int TipoRelazionePersonaleId,
        string? Note,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

