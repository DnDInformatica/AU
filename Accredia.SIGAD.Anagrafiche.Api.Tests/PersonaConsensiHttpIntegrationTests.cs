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

public sealed class PersonaConsensiHttpIntegrationTests
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

        var finalitaId = await GetFinalitaIdAsync(client);
        var personaId = 0;
        var consensoId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"CnsTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var created = await CreateAsync(client, personaId, new
            {
                tipoFinalitaTrattamentoId = finalitaId,
                consenso = true,
                dataConsenso = DateTime.UtcNow,
                dataScadenza = (DateTime?)null,
                dataRevoca = (DateTime?)null,
                modalitaAcquisizione = "WEB",
                modalitaRevoca = (string?)null,
                riferimentoDocumento = (string?)null,
                ipAddress = (string?)null,
                userAgent = (string?)null,
                motivoRevoca = (string?)null,
                versioneInformativa = "1.0",
                dataInformativa = DateTime.UtcNow.Date,
                note = "test"
            });
            consensoId = created.ConsensoPersonaId;
            Assert.True(created.Consenso);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.ConsensoPersonaId == consensoId);

            var updated = await UpdateAsync(client, personaId, consensoId, new
            {
                tipoFinalitaTrattamentoId = finalitaId,
                consenso = false,
                dataConsenso = created.DataConsenso,
                dataScadenza = (DateTime?)null,
                dataRevoca = DateTime.UtcNow,
                modalitaAcquisizione = "WEB",
                modalitaRevoca = "EMAIL",
                riferimentoDocumento = (string?)null,
                ipAddress = (string?)null,
                userAgent = (string?)null,
                motivoRevoca = "revoca test",
                versioneInformativa = "1.0",
                dataInformativa = DateTime.UtcNow.Date,
                note = "updated"
            });
            Assert.False(updated.Consenso);
            Assert.NotNull(updated.DataRevoca);
            Assert.Equal("EMAIL", updated.ModalitaRevoca);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/consensi/{consensoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.ConsensoPersonaId == consensoId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.ConsensoPersonaId == consensoId);
        }
        finally
        {
            if (consensoId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/consensi/{consensoId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetFinalitaIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/consensi/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoFinalitaTrattamento lookup found.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<ConsensoDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/consensi?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new ConsensoDto(
                item?["consensoPersonaId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["tipoFinalitaTrattamentoId"]?.GetValue<int>() ?? 0,
                item?["consenso"]?.GetValue<bool>() ?? false,
                item?["dataConsenso"]?.GetValue<DateTime>() ?? DateTime.MinValue,
                item?["dataScadenza"]?.GetValue<DateTime?>(),
                item?["dataRevoca"]?.GetValue<DateTime?>(),
                item?["modalitaAcquisizione"]?.GetValue<string>() ?? string.Empty,
                item?["modalitaRevoca"]?.GetValue<string>(),
                item?["note"]?.GetValue<string>(),
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<ConsensoDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/consensi", request);
        response.EnsureSuccessStatusCode();
        return ParseConsenso(await response.Content.ReadAsStringAsync());
    }

    private static async Task<ConsensoDto> UpdateAsync(HttpClient client, int personaId, int consensoPersonaId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/consensi/{consensoPersonaId}", request);
        response.EnsureSuccessStatusCode();
        return ParseConsenso(await response.Content.ReadAsStringAsync());
    }

    private static ConsensoDto ParseConsenso(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid consenso payload.");

        return new ConsensoDto(
            json["consensoPersonaId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["tipoFinalitaTrattamentoId"]?.GetValue<int>() ?? 0,
            json["consenso"]?.GetValue<bool>() ?? false,
            json["dataConsenso"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            json["dataScadenza"]?.GetValue<DateTime?>(),
            json["dataRevoca"]?.GetValue<DateTime?>(),
            json["modalitaAcquisizione"]?.GetValue<string>() ?? string.Empty,
            json["modalitaRevoca"]?.GetValue<string>(),
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

    private sealed record ConsensoDto(
        int ConsensoPersonaId,
        int PersonaId,
        int TipoFinalitaTrattamentoId,
        bool Consenso,
        DateTime DataConsenso,
        DateTime? DataScadenza,
        DateTime? DataRevoca,
        string ModalitaAcquisizione,
        string? ModalitaRevoca,
        string? Note,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

