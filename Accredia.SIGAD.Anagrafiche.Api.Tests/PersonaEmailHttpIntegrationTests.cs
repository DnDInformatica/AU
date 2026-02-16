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

public sealed class PersonaEmailHttpIntegrationTests
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

        var tipoEmailId = await GetTipoEmailIdAsync(client);
        var personaId = 0;
        var personaEmailId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"EmailTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var createdEmail = await CreateAsync(client, personaId, new
            {
                tipoEmailId,
                email = $"t_{Guid.NewGuid():N}@example.test",
                principale = true,
                verificata = false,
                dataVerifica = (DateTime?)null
            });
            personaEmailId = createdEmail.PersonaEmailId;
            Assert.True(createdEmail.Principale);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaEmailId == personaEmailId);

            var updated = await UpdateAsync(client, personaId, personaEmailId, new
            {
                tipoEmailId,
                email = createdEmail.Email,
                principale = true,
                verificata = true,
                dataVerifica = (DateTime?)null
            });
            Assert.True(updated.Verificata);
            Assert.NotNull(updated.DataVerifica);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/email/{personaEmailId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaEmailId == personaEmailId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaEmailId == personaEmailId);
        }
        finally
        {
            if (personaEmailId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/email/{personaEmailId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetTipoEmailIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/email/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoEmail lookup found.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaEmailDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/email?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaEmailDto(
                item?["personaEmailId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["tipoEmailId"]?.GetValue<int>() ?? 0,
                item?["email"]?.GetValue<string>() ?? string.Empty,
                item?["principale"]?.GetValue<bool>() ?? false,
                item?["verificata"]?.GetValue<bool>() ?? false,
                item?["dataVerifica"]?.GetValue<DateTime?>(),
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<PersonaEmailDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/email", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaEmail(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaEmailDto> UpdateAsync(HttpClient client, int personaId, int personaEmailId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/email/{personaEmailId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaEmail(await response.Content.ReadAsStringAsync());
    }

    private static PersonaEmailDto ParsePersonaEmail(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona email payload.");

        return new PersonaEmailDto(
            json["personaEmailId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["tipoEmailId"]?.GetValue<int>() ?? 0,
            json["email"]?.GetValue<string>() ?? string.Empty,
            json["principale"]?.GetValue<bool>() ?? false,
            json["verificata"]?.GetValue<bool>() ?? false,
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

    private sealed record PersonaEmailDto(
        int PersonaEmailId,
        int PersonaId,
        int TipoEmailId,
        string Email,
        bool Principale,
        bool Verificata,
        DateTime? DataVerifica,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}

