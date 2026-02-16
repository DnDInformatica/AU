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

public sealed class PersonaTelefonoHttpIntegrationTests
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

        var tipoTelefonoId = await GetTipoTelefonoIdAsync(client);
        var personaId = 0;
        var personaTelefonoId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"TelTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var createdTel = await CreateAsync(client, personaId, new
            {
                tipoTelefonoId,
                prefissoInternazionale = "+39",
                numero = "3331234567",
                estensione = (string?)null,
                principale = true,
                verificato = false,
                dataVerifica = (DateTime?)null
            });
            personaTelefonoId = createdTel.PersonaTelefonoId;
            Assert.True(createdTel.Principale);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaTelefonoId == personaTelefonoId);

            var updated = await UpdateAsync(client, personaId, personaTelefonoId, new
            {
                tipoTelefonoId,
                prefissoInternazionale = "+39",
                numero = "3331234567",
                estensione = "12",
                principale = true,
                verificato = true,
                dataVerifica = (DateTime?)null
            });
            Assert.True(updated.Verificato);
            Assert.NotNull(updated.DataVerifica);
            Assert.Equal("12", updated.Estensione);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/telefoni/{personaTelefonoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaTelefonoId == personaTelefonoId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaTelefonoId == personaTelefonoId);
        }
        finally
        {
            if (personaTelefonoId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/telefoni/{personaTelefonoId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetTipoTelefonoIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/telefono/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoTelefono lookup found.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaTelefonoDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/telefoni?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaTelefonoDto(
                item?["personaTelefonoId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["tipoTelefonoId"]?.GetValue<int>() ?? 0,
                item?["prefissoInternazionale"]?.GetValue<string>(),
                item?["numero"]?.GetValue<string>() ?? string.Empty,
                item?["estensione"]?.GetValue<string>(),
                item?["principale"]?.GetValue<bool>() ?? false,
                item?["verificato"]?.GetValue<bool>() ?? false,
                item?["dataVerifica"]?.GetValue<DateTime?>(),
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<PersonaTelefonoDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/telefoni", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaTelefono(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaTelefonoDto> UpdateAsync(HttpClient client, int personaId, int personaTelefonoId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/telefoni/{personaTelefonoId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaTelefono(await response.Content.ReadAsStringAsync());
    }

    private static PersonaTelefonoDto ParsePersonaTelefono(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona telefono payload.");

        return new PersonaTelefonoDto(
            json["personaTelefonoId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["tipoTelefonoId"]?.GetValue<int>() ?? 0,
            json["prefissoInternazionale"]?.GetValue<string>(),
            json["numero"]?.GetValue<string>() ?? string.Empty,
            json["estensione"]?.GetValue<string>(),
            json["principale"]?.GetValue<bool>() ?? false,
            json["verificato"]?.GetValue<bool>() ?? false,
            json["dataVerifica"]?.GetValue<DateTime?>(),
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

    private sealed record PersonaTelefonoDto(
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

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

