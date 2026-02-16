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

public sealed class OrganizzazioniUnitaFunzioniHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_UnitaFunzione_WorksEndToEnd()
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
        var unitIds = await EnsureUnitAsync(client, organizzazioneId);
        var unitaOrganizzativaId = unitIds[0];
        var tipoFunzioneId = await FindValidTipoFunzioneAsync(client, organizzazioneId, unitaOrganizzativaId);

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni",
            new
            {
                unitaOrganizzativaId,
                tipoFunzioneUnitaLocaleId = tipoFunzioneId,
                principale = true,
                note = "test create"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var unitaOrganizzativaFunzioneId = created!["unitaOrganizzativaFunzioneId"]?.GetValue<int>() ?? 0;
        Assert.True(unitaOrganizzativaFunzioneId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni/{unitaOrganizzativaFunzioneId}",
            new
            {
                unitaOrganizzativaId,
                tipoFunzioneUnitaLocaleId = tipoFunzioneId,
                principale = false,
                note = "test update"
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(unitaOrganizzativaFunzioneId, updated!["unitaOrganizzativaFunzioneId"]?.GetValue<int>());
        Assert.False(updated["principale"]?.GetValue<bool>());
        Assert.Equal("test update", updated["note"]?.GetValue<string>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["unitaOrganizzativaFunzioneId"]?.GetValue<int>() == unitaOrganizzativaFunzioneId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni/{unitaOrganizzativaFunzioneId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["unitaOrganizzativaFunzioneId"]?.GetValue<int>() == unitaOrganizzativaFunzioneId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<List<int>> EnsureUnitAsync(HttpClient client, int organizzazioneId)
    {
        var units = await GetUnitsAsync(client, organizzazioneId);
        if (units.Count > 0)
        {
            return [units[0]];
        }

        var lookupsResponse = await client.GetAsync("/anagrafiche/v1/organizzazioni/unita-organizzative/lookups");
        lookupsResponse.EnsureSuccessStatusCode();
        var lookupsJson = JsonNode.Parse(await lookupsResponse.Content.ReadAsStringAsync())?.AsObject();
        var tipoUnitaId = lookupsJson?["tipiUnitaOrganizzativa"]?[0]?["id"]?.GetValue<int>() ?? 1;

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
        Assert.True(createdId > 0);
        return [createdId];
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

    private static async Task<int> FindValidTipoFunzioneAsync(HttpClient client, int organizzazioneId, int unitaOrganizzativaId)
    {
        for (var candidate = 1; candidate <= 100; candidate++)
        {
            var response = await client.PostAsJsonAsync(
                $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni",
                new
                {
                    unitaOrganizzativaId,
                    tipoFunzioneUnitaLocaleId = candidate,
                    principale = false,
                    note = "probe"
                });

            if (response.StatusCode == HttpStatusCode.Created)
            {
                var created = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsObject();
                var id = created?["unitaOrganizzativaFunzioneId"]?.GetValue<int>() ?? 0;
                if (id > 0)
                {
                    var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-funzioni/{id}");
                    Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);
                }

                return candidate;
            }

            if (response.StatusCode != HttpStatusCode.Conflict)
            {
                response.EnsureSuccessStatusCode();
            }
        }

        throw new InvalidOperationException("Nessun TipoFunzioneUnitaLocale valido trovato nel range 1..100.");
    }
}
