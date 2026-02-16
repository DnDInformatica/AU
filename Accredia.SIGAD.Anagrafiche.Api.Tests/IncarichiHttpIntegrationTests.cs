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

public sealed class IncarichiHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateGetList_WithAndWithoutUo_Works()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var createdIds = new List<int>();
        try
        {
            var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
            var tipoRuoloId = await IntegrationTestSupport.GetTipoRuoloIdAsync(client);
            var utcNow = DateTime.UtcNow;

            var createNoUo = await CreateIncaricoAsync(client, new
            {
                personaId,
                organizzazioneId = 19960,
                tipoRuoloId,
                statoIncarico = "ATTIVO",
                dataInizio = utcNow,
                dataFine = (DateTime?)null,
                unitaOrganizzativaId = (int?)null
            });
            createdIds.Add(createNoUo.IncaricoId);

            Assert.Equal(19960, createNoUo.OrganizzazioneId);
            Assert.Null(createNoUo.UnitaOrganizzativaId);

            var updateNoUo = await UpdateIncaricoAsync(client, createNoUo.IncaricoId, new
            {
                personaId,
                organizzazioneId = 19960,
                tipoRuoloId,
                statoIncarico = "SOSPESO",
                dataInizio = utcNow,
                dataFine = (DateTime?)null,
                unitaOrganizzativaId = (int?)null
            });
            Assert.Equal("SOSPESO", updateNoUo.StatoIncarico);

            var listNoUo = await GetOrganizzazioneIncarichiAsync(client, 19960, includeDeleted: false);
            Assert.Contains(listNoUo, item => item.IncaricoId == createNoUo.IncaricoId);

            var createWithUo = await CreateIncaricoAsync(client, new
            {
                personaId,
                organizzazioneId = 3984,
                tipoRuoloId,
                statoIncarico = "ATTIVO",
                dataInizio = utcNow,
                dataFine = (DateTime?)null,
                unitaOrganizzativaId = 14524
            });
            createdIds.Add(createWithUo.IncaricoId);

            Assert.Equal(3984, createWithUo.OrganizzazioneId);
            Assert.Equal(14524, createWithUo.UnitaOrganizzativaId);

            var getWithUo = await GetIncaricoAsync(client, createWithUo.IncaricoId);
            Assert.Equal(3984, getWithUo.OrganizzazioneId);
            Assert.Equal(14524, getWithUo.UnitaOrganizzativaId);

            var listWithUo = await GetOrganizzazioneIncarichiAsync(client, 3984, includeDeleted: false);
            Assert.Contains(listWithUo, item => item.IncaricoId == createWithUo.IncaricoId);
        }
        finally
        {
            foreach (var id in createdIds)
            {
                await client.DeleteAsync($"/anagrafiche/v1/incarichi/{id}");
            }
        }
    }

    [Fact]
    public async Task Create_WithNullTipoRuoloId_ReturnsBadRequest()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var utcNow = DateTime.UtcNow;
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/incarichi", new
        {
            personaId,
            organizzazioneId = 19960,
            tipoRuoloId = (int?)null,
            statoIncarico = "ATTIVO",
            dataInizio = utcNow,
            dataFine = (DateTime?)null,
            unitaOrganizzativaId = (int?)null
        });

        Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode);
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        var errors = json?["errors"]?.AsObject();
        Assert.True(errors?.ContainsKey("tipoRuoloId") == true);
    }

    [Fact]
    public async Task SoftDelete_TogglesVisibility_ByIncludeDeletedFlag()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var tipoRuoloId = await IntegrationTestSupport.GetTipoRuoloIdAsync(client);
        var utcNow = DateTime.UtcNow;

        var created = await CreateIncaricoAsync(client, new
        {
            personaId,
            organizzazioneId = 19960,
            tipoRuoloId,
            statoIncarico = "ATTIVO",
            dataInizio = utcNow,
            dataFine = (DateTime?)null,
            unitaOrganizzativaId = (int?)null
        });

        try
        {
            var beforeFalse = await GetOrganizzazioneIncarichiAsync(client, 19960, includeDeleted: false);
            Assert.Contains(beforeFalse, item => item.IncaricoId == created.IncaricoId);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/incarichi/{created.IncaricoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterFalse = await GetOrganizzazioneIncarichiAsync(client, 19960, includeDeleted: false);
            var afterTrue = await GetOrganizzazioneIncarichiAsync(client, 19960, includeDeleted: true);

            Assert.DoesNotContain(afterFalse, item => item.IncaricoId == created.IncaricoId);
            Assert.Contains(afterTrue, item => item.IncaricoId == created.IncaricoId);
        }
        finally
        {
            // Best effort cleanup in case the delete assertion failed before deleting.
            await client.DeleteAsync($"/anagrafiche/v1/incarichi/{created.IncaricoId}");
        }
    }

    [Fact]
    public async Task PersonaIncarichi_RespectsIncludeDeletedFlag()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var tipoRuoloId = await IntegrationTestSupport.GetTipoRuoloIdAsync(client);
        var utcNow = DateTime.UtcNow;

        var created = await CreateIncaricoAsync(client, new
        {
            personaId,
            organizzazioneId = 19960,
            tipoRuoloId,
            statoIncarico = "ATTIVO",
            dataInizio = utcNow,
            dataFine = (DateTime?)null,
            unitaOrganizzativaId = (int?)null
        });

        try
        {
            var beforeFalse = await GetPersonaIncarichiAsync(client, personaId, includeDeleted: false);
            Assert.Contains(beforeFalse, item => item.IncaricoId == created.IncaricoId);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/incarichi/{created.IncaricoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var afterFalse = await GetPersonaIncarichiAsync(client, personaId, includeDeleted: false);
            var afterTrue = await GetPersonaIncarichiAsync(client, personaId, includeDeleted: true);
            Assert.DoesNotContain(afterFalse, item => item.IncaricoId == created.IncaricoId);
            Assert.Contains(afterTrue, item => item.IncaricoId == created.IncaricoId);
        }
        finally
        {
            await client.DeleteAsync($"/anagrafiche/v1/incarichi/{created.IncaricoId}");
        }
    }

    [Fact]
    public async Task IncarichiSearch_FindsCreatedIncarico_ByRoleText()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var tipoRuoloId = await IntegrationTestSupport.GetTipoRuoloIdAsync(client);
        var utcNow = DateTime.UtcNow;

        var created = await CreateIncaricoAsync(client, new
        {
            personaId,
            organizzazioneId = 19960,
            tipoRuoloId,
            statoIncarico = "ATTIVO",
            dataInizio = utcNow,
            dataFine = (DateTime?)null,
            unitaOrganizzativaId = (int?)null
        });

        try
        {
            var search = await SearchIncarichiAsync(client, "ATTIVO");
            Assert.Contains(search, item => item.IncaricoId == created.IncaricoId);
        }
        finally
        {
            await client.DeleteAsync($"/anagrafiche/v1/incarichi/{created.IncaricoId}");
        }
    }

    private static async Task<IncaricoDto> CreateIncaricoAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/incarichi", request);
        response.EnsureSuccessStatusCode();
        return ParseIncarico(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IncaricoDto> UpdateIncaricoAsync(HttpClient client, int id, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/incarichi/{id}", request);
        response.EnsureSuccessStatusCode();
        return ParseIncarico(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IncaricoDto> GetIncaricoAsync(HttpClient client, int id)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/incarichi/{id}");
        response.EnsureSuccessStatusCode();
        return ParseIncarico(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<IncaricoListItemDto>> GetOrganizzazioneIncarichiAsync(HttpClient client, int organizzazioneId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/incarichi?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new IncaricoListItemDto(
                item?["incaricoId"]?.GetValue<int>() ?? 0))
            .ToList()
            ?? [];
    }

    private static async Task<IReadOnlyList<IncaricoListItemDto>> GetPersonaIncarichiAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/incarichi?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new IncaricoListItemDto(
                item?["incaricoId"]?.GetValue<int>() ?? 0))
            .ToList()
            ?? [];
    }

    private static async Task<IReadOnlyList<IncaricoListItemDto>> SearchIncarichiAsync(HttpClient client, string query)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/incarichi/search?q={Uri.EscapeDataString(query)}&page=1&pageSize=50");
        response.EnsureSuccessStatusCode();
        var root = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
        var items = root?["items"]?.AsArray();
        return items?
            .Select(item => new IncaricoListItemDto(
                item?["incaricoId"]?.GetValue<int>() ?? 0))
            .ToList()
            ?? [];
    }

    private static IncaricoDto ParseIncarico(string jsonText)
    {
        var json = JsonNode.Parse(jsonText)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid incarico payload.");

        return new IncaricoDto(
            json["incaricoId"]?.GetValue<int>() ?? 0,
            json["organizzazioneId"]?.GetValue<int>() ?? 0,
            json["unitaOrganizzativaId"]?.GetValue<int?>(),
            json["statoIncarico"]?.GetValue<string>() ?? string.Empty);
    }

    private sealed record IncaricoDto(
        int IncaricoId,
        int OrganizzazioneId,
        int? UnitaOrganizzativaId,
        string StatoIncarico);

    private sealed record IncaricoListItemDto(int IncaricoId);
}
