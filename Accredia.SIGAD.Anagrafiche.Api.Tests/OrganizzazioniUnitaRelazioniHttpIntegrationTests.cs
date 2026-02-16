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

public sealed class OrganizzazioniUnitaRelazioniHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_UnitaRelazione_WorksEndToEnd()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
        client.DefaultRequestHeaders.Add("X-Actor", "1");

        var organizzazioneId = GetTestOrganizzazioneId();
        var unitIds = await EnsureTwoUnitsAsync(client, organizzazioneId);
        var padreId = unitIds[0];
        var figliaId = unitIds[1];

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-relazioni",
            new
            {
                unitaPadreId = padreId,
                unitaFigliaId = figliaId,
                tipoRelazioneId = 1
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var relazioneId = created!["unitaRelazioneId"]?.GetValue<int>() ?? 0;
        Assert.True(relazioneId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-relazioni/{relazioneId}",
            new
            {
                unitaPadreId = padreId,
                unitaFigliaId = figliaId,
                tipoRelazioneId = 2
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(2, updated!["tipoRelazioneId"]?.GetValue<int>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-relazioni");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["unitaRelazioneId"]?.GetValue<int>() == relazioneId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-relazioni/{relazioneId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-relazioni");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["unitaRelazioneId"]?.GetValue<int>() == relazioneId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<List<int>> EnsureTwoUnitsAsync(HttpClient client, int organizzazioneId)
    {
        var units = await GetUnitsAsync(client, organizzazioneId);
        if (units.Count >= 2)
        {
            return units.Take(2).ToList();
        }

        var lookupsResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/unita-organizzative/lookups");
        lookupsResponse.EnsureSuccessStatusCode();
        var lookupsJson = JsonNode.Parse(await lookupsResponse.Content.ReadAsStringAsync())?.AsObject();
        var tipoUnitaId = lookupsJson?["tipiUnitaOrganizzativa"]?[0]?["id"]?.GetValue<int>() ?? 1;

        while (units.Count < 2)
        {
            var suffix = Guid.NewGuid().ToString("N")[..8];
            var createResponse = await client.PostAsJsonAsync(
                $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative",
                new
                {
                    nome = $"UO TEST {suffix}",
                    codice = $"UT{suffix[..4]}",
                    principale = false,
                    tipoUnitaOrganizzativaId = tipoUnitaId,
                    tipoSedeId = (int?)null
                });
            createResponse.EnsureSuccessStatusCode();

            var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
            var createdId = created?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
            if (createdId > 0)
            {
                units.Add(createdId);
            }
        }

        return units.Take(2).ToList();
    }

    private static async Task<List<int>> GetUnitsAsync(HttpClient client, int organizzazioneId)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        if (json is null)
        {
            return new List<int>();
        }

        var list = new List<int>();
        foreach (var row in json)
        {
            var id = row?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
            if (id > 0)
            {
                list.Add(id);
            }
        }

        return list;
    }
}

