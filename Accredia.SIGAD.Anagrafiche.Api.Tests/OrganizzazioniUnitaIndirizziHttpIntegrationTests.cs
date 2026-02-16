using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniUnitaIndirizziHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_UnitaIndirizzo_WorksEndToEnd()
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
        var unitaOrganizzativaId = await EnsureUnitAsync(client, organizzazioneId);
        var tipoIndirizzoId = await FindValidTipoIndirizzoAsync(client, organizzazioneId, unitaOrganizzativaId);

        var suffix = Guid.NewGuid().ToString("N")[..6].ToUpperInvariant();

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi",
            new
            {
                unitaOrganizzativaId,
                tipoIndirizzoId,
                comuneId = (int?)null,
                indirizzo = $"Via Test {suffix}",
                numeroCivico = "10",
                cap = "00100",
                localita = "Roma",
                presso = (string?)null,
                latitudine = (decimal?)null,
                longitudine = (decimal?)null,
                piano = (string?)null,
                interno = (string?)null,
                edificio = (string?)null,
                zonaIndustriale = (string?)null,
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = true
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var indirizzoId = created!["indirizzoId"]?.GetValue<int>() ?? 0;
        Assert.True(indirizzoId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi/{indirizzoId}",
            new
            {
                unitaOrganizzativaId,
                tipoIndirizzoId,
                comuneId = (int?)null,
                indirizzo = $"Via Update {suffix}",
                numeroCivico = "11",
                cap = "00100",
                localita = "Roma",
                presso = "Scala A",
                latitudine = (decimal?)null,
                longitudine = (decimal?)null,
                piano = "2",
                interno = "B",
                edificio = (string?)null,
                zonaIndustriale = (string?)null,
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = false
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(indirizzoId, updated!["indirizzoId"]?.GetValue<int>());
        Assert.Equal($"Via Update {suffix}", updated["indirizzo"]?.GetValue<string>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["indirizzoId"]?.GetValue<int>() == indirizzoId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi/{indirizzoId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["indirizzoId"]?.GetValue<int>() == indirizzoId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<int> EnsureUnitAsync(HttpClient client, int organizzazioneId)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-organizzative");
        response.EnsureSuccessStatusCode();
        var units = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        var existingId = units?[0]?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
        if (existingId > 0)
        {
            return existingId;
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
        return created?["unitaOrganizzativaId"]?.GetValue<int>() ?? 0;
    }

    private static async Task<int> FindValidTipoIndirizzoAsync(HttpClient client, int organizzazioneId, int unitaOrganizzativaId)
    {
        for (var candidate = 1; candidate <= 100; candidate++)
        {
            var suffix = Guid.NewGuid().ToString("N")[..8];
            var probeResponse = await client.PostAsJsonAsync(
                $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi",
                new
                {
                    unitaOrganizzativaId,
                    tipoIndirizzoId = candidate,
                    comuneId = (int?)null,
                    indirizzo = $"Probe {suffix}",
                    numeroCivico = "1",
                    cap = "00100",
                    localita = "Roma",
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

            if (probeResponse.StatusCode == HttpStatusCode.Created)
            {
                var created = JsonNode.Parse(await probeResponse.Content.ReadAsStringAsync())?.AsObject();
                var probeId = created?["indirizzoId"]?.GetValue<int>() ?? 0;
                if (probeId > 0)
                {
                    var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-indirizzi/{probeId}");
                    Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);
                }

                return candidate;
            }

            if (probeResponse.StatusCode != HttpStatusCode.Conflict)
            {
                probeResponse.EnsureSuccessStatusCode();
            }
        }

        throw new InvalidOperationException("Nessun TipoIndirizzo valido trovato nel range 1..100.");
    }
}
