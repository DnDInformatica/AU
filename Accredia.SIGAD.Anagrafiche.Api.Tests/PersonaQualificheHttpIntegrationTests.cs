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

public sealed class PersonaQualificheHttpIntegrationTests
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

        var (tipoQualificaId, enteId) = await GetLookupsAsync(client);

        var personaId = 0;
        var personaQualificaId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"QualTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var created = await CreateAsync(client, personaId, new
            {
                tipoQualificaId,
                enteRilascioQualificaId = enteId,
                codiceAttestato = "ATTEST-001",
                dataRilascio = DateTime.UtcNow.Date,
                dataScadenza = (DateTime?)null,
                valida = true,
                note = "test"
            });
            personaQualificaId = created.PersonaQualificaId;
            Assert.True(created.Valida);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaQualificaId == personaQualificaId);

            var updated = await UpdateAsync(client, personaId, personaQualificaId, new
            {
                tipoQualificaId,
                enteRilascioQualificaId = enteId,
                codiceAttestato = "ATTEST-002",
                dataRilascio = DateTime.UtcNow.Date,
                dataScadenza = DateTime.UtcNow.Date.AddDays(30),
                valida = false,
                note = "updated"
            });
            Assert.False(updated.Valida);
            Assert.Equal("ATTEST-002", updated.CodiceAttestato);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/qualifiche/{personaQualificaId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaQualificaId == personaQualificaId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaQualificaId == personaQualificaId);
        }
        finally
        {
            if (personaQualificaId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/qualifiche/{personaQualificaId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<(int TipoQualificaId, int? EnteRilascioQualificaId)> GetLookupsAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/qualifiche/lookups");
        response.EnsureSuccessStatusCode();
        var root = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        var tipi = root?["tipi"]?.AsArray();
        var enti = root?["enti"]?.AsArray();

        var tipoId = tipi?[0]?["id"]?.GetValue<int>()
                     ?? throw new InvalidOperationException("No TipoQualifica lookup found.");
        var enteId = enti?.Count > 0 ? enti[0]?["id"]?.GetValue<int?>() : null;
        return (tipoId, enteId);
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaQualificaDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/qualifiche?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaQualificaDto(
                item?["personaQualificaId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["tipoQualificaId"]?.GetValue<int>() ?? 0,
                item?["enteRilascioQualificaId"]?.GetValue<int?>(),
                item?["codiceAttestato"]?.GetValue<string>(),
                item?["dataRilascio"]?.GetValue<DateTime?>(),
                item?["dataScadenza"]?.GetValue<DateTime?>(),
                item?["valida"]?.GetValue<bool>() ?? false,
                item?["note"]?.GetValue<string>(),
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<PersonaQualificaDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/qualifiche", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaQualifica(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaQualificaDto> UpdateAsync(HttpClient client, int personaId, int personaQualificaId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/qualifiche/{personaQualificaId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaQualifica(await response.Content.ReadAsStringAsync());
    }

    private static PersonaQualificaDto ParsePersonaQualifica(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona qualifica payload.");

        return new PersonaQualificaDto(
            json["personaQualificaId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["tipoQualificaId"]?.GetValue<int>() ?? 0,
            json["enteRilascioQualificaId"]?.GetValue<int?>(),
            json["codiceAttestato"]?.GetValue<string>(),
            json["dataRilascio"]?.GetValue<DateTime?>(),
            json["dataScadenza"]?.GetValue<DateTime?>(),
            json["valida"]?.GetValue<bool>() ?? false,
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

    private sealed record PersonaQualificaDto(
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

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

