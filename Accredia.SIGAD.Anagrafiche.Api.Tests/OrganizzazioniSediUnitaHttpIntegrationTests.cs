using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniSediUnitaHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_SedeUnita_WorksEndToEnd()
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
        var sedeId = await EnsureSedeAsync(client, organizzazioneId);

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-unita",
            new
            {
                sedeId,
                unitaOrganizzativaId,
                ruoloOperativo = "Operativa",
                descrizioneRuolo = "Test create",
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = true,
                isTemporanea = false,
                percentualeAttivita = 100m,
                note = "note create"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var sedeUnitaOrganizzativaId = created!["sedeUnitaOrganizzativaId"]?.GetValue<int>() ?? 0;
        Assert.True(sedeUnitaOrganizzativaId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-unita/{sedeUnitaOrganizzativaId}",
            new
            {
                sedeId,
                unitaOrganizzativaId,
                ruoloOperativo = "Supporto",
                descrizioneRuolo = "Test update",
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = false,
                isTemporanea = true,
                percentualeAttivita = 50m,
                note = "note update"
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(sedeUnitaOrganizzativaId, updated!["sedeUnitaOrganizzativaId"]?.GetValue<int>());
        Assert.Equal("Supporto", updated["ruoloOperativo"]?.GetValue<string>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-unita");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["sedeUnitaOrganizzativaId"]?.GetValue<int>() == sedeUnitaOrganizzativaId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-unita/{sedeUnitaOrganizzativaId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi-unita");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["sedeUnitaOrganizzativaId"]?.GetValue<int>() == sedeUnitaOrganizzativaId);
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

    private static async Task<int> EnsureSedeAsync(HttpClient client, int organizzazioneId)
    {
        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi");
        listResponse.EnsureSuccessStatusCode();
        var sedi = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        var existingId = sedi?[0]?["sedeId"]?.GetValue<int>() ?? 0;
        if (existingId > 0)
        {
            return existingId;
        }

        var suffix = Guid.NewGuid().ToString("N")[..8];
        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/sedi",
            new
            {
                denominazione = $"Sede Test {suffix}",
                indirizzo = $"Via Test {suffix[..4]}",
                numeroCivico = "1",
                cap = "00100",
                localita = "Roma",
                provincia = "RM",
                nazione = "Italia",
                statoSede = "ATTIVA",
                isSedePrincipale = false,
                isSedeOperativa = true,
                dataApertura = DateTime.UtcNow.Date,
                dataCessazione = (DateTime?)null,
                tipoSedeId = (int?)null
            });
        createResponse.EnsureSuccessStatusCode();
        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        return created?["sedeId"]?.GetValue<int>() ?? 0;
    }
}
