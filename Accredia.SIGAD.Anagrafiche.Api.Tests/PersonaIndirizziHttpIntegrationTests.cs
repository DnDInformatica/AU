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

public sealed class PersonaIndirizziHttpIntegrationTests
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

        var tipoIndirizzoId = await GetTipoIndirizzoIdAsync(client);

        var personaId = 0;
        var personaIndirizzoId = 0;
        var indirizzoId = 0;

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"IndTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Test",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1990, 1, 1, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            // PersonaIndirizzo.IndirizzoId has no FK: we create a real IndirizzoId via existing UO address endpoint.
            indirizzoId = await CreateUnitaIndirizzoAndGetIdAsync(client, tipoIndirizzoId);

            var before = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(before);

            var created = await CreateAsync(client, personaId, new
            {
                indirizzoId,
                tipoIndirizzoId,
                principale = true,
                attivo = true
            });
            personaIndirizzoId = created.PersonaIndirizzoId;
            Assert.True(created.Principale);
            Assert.True(created.Attivo);

            var afterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(afterCreate, x => x.PersonaIndirizzoId == personaIndirizzoId);

            var updated = await UpdateAsync(client, personaId, personaIndirizzoId, new
            {
                indirizzoId,
                tipoIndirizzoId,
                principale = true,
                attivo = false
            });
            Assert.False(updated.Attivo);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/indirizzi/{personaIndirizzoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(afterDelete, x => x.PersonaIndirizzoId == personaIndirizzoId);

            var afterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(afterDeleteIncl, x => x.PersonaIndirizzoId == personaIndirizzoId);
        }
        finally
        {
            if (personaIndirizzoId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/indirizzi/{personaIndirizzoId}");
            }
            if (indirizzoId > 0)
            {
                // Best-effort cleanup: delete the generated UO indirizzo.
                await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/19960/unita-indirizzi/{indirizzoId}");
            }
            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<int> GetTipoIndirizzoIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/indirizzi/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoIndirizzo lookup found.");
    }

    private static async Task<int> CreateUnitaIndirizzoAndGetIdAsync(HttpClient client, int tipoIndirizzoId)
    {
        // Uses known seeded ids already used by other integration tests.
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/organizzazioni/19960/unita-indirizzi", new
        {
            unitaOrganizzativaId = 14524,
            tipoIndirizzoId,
            comuneId = (int?)null,
            indirizzo = $"Via Test {DateTime.UtcNow:yyyyMMddHHmmss}",
            numeroCivico = "1",
            cap = "00100",
            localita = (string?)null,
            presso = (string?)null,
            latitudine = (decimal?)null,
            longitudine = (decimal?)null,
            piano = (string?)null,
            interno = (string?)null,
            edificio = (string?)null,
            zonaIndustriale = (string?)null,
            dataInizio = DateTime.UtcNow.Date,
            dataFine = (DateTime?)null,
            principale = false
        });

        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        return json?["indirizzoId"]?.GetValue<int>()
               ?? throw new InvalidOperationException("IndirizzoId missing from UO create response.");
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaIndirizzoDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/indirizzi?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaIndirizzoDto(
                item?["personaIndirizzoId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["indirizzoId"]?.GetValue<int>() ?? 0,
                item?["tipoIndirizzoId"]?.GetValue<int>() ?? 0,
                item?["principale"]?.GetValue<bool>() ?? false,
                item?["attivo"]?.GetValue<bool>() ?? false,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<PersonaIndirizzoDto> CreateAsync(HttpClient client, int personaId, object request)
    {
        var response = await client.PostAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/indirizzi", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaIndirizzo(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaIndirizzoDto> UpdateAsync(HttpClient client, int personaId, int personaIndirizzoId, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/{personaId}/indirizzi/{personaIndirizzoId}", request);
        response.EnsureSuccessStatusCode();
        return ParsePersonaIndirizzo(await response.Content.ReadAsStringAsync());
    }

    private static PersonaIndirizzoDto ParsePersonaIndirizzo(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid persona indirizzo payload.");

        return new PersonaIndirizzoDto(
            json["personaIndirizzoId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["indirizzoId"]?.GetValue<int>() ?? 0,
            json["tipoIndirizzoId"]?.GetValue<int>() ?? 0,
            json["principale"]?.GetValue<bool>() ?? false,
            json["attivo"]?.GetValue<bool>() ?? false,
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

    private sealed record PersonaIndirizzoDto(
        int PersonaIndirizzoId,
        int PersonaId,
        int IndirizzoId,
        int TipoIndirizzoId,
        bool Principale,
        bool Attivo,
        DateTime? DataCancellazione);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}
