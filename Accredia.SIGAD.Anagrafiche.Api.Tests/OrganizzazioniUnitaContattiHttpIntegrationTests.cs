using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniUnitaContattiHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_UnitaContatto_WorksEndToEnd()
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
        var tipoContattoId = await FindValidTipoContattoAsync(client, organizzazioneId, unitaOrganizzativaId);

        var suffix = Guid.NewGuid().ToString("N")[..8];
        var initialValue = $"test.{suffix}@example.org";
        var updatedValue = $"update.{suffix}@example.org";

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti",
            new
            {
                unitaOrganizzativaId,
                tipoContattoId,
                valore = initialValue,
                valoreSecondario = (string?)null,
                descrizione = "test create",
                note = "note create",
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = true,
                ordinePriorita = 1,
                isVerificato = false,
                dataVerifica = (DateTime?)null,
                isPubblico = true
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var contattoId = created!["contattoId"]?.GetValue<int>() ?? 0;
        Assert.True(contattoId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti/{contattoId}",
            new
            {
                unitaOrganizzativaId,
                tipoContattoId,
                valore = updatedValue,
                valoreSecondario = "secondario",
                descrizione = "test update",
                note = "note update",
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                principale = false,
                ordinePriorita = 2,
                isVerificato = true,
                dataVerifica = DateTime.UtcNow,
                isPubblico = false
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(contattoId, updated!["contattoId"]?.GetValue<int>());
        Assert.Equal(updatedValue, updated["valore"]?.GetValue<string>());
        Assert.False(updated["principale"]?.GetValue<bool>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["contattoId"]?.GetValue<int>() == contattoId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti/{contattoId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["contattoId"]?.GetValue<int>() == contattoId);
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

    private static async Task<int> FindValidTipoContattoAsync(HttpClient client, int organizzazioneId, int unitaOrganizzativaId)
    {
        for (var candidate = 1; candidate <= 100; candidate++)
        {
            var probeResponse = await client.PostAsJsonAsync(
                $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti",
                new
                {
                    unitaOrganizzativaId,
                    tipoContattoId = candidate,
                    valore = $"probe-{Guid.NewGuid():N}@example.org",
                    valoreSecondario = (string?)null,
                    descrizione = "probe",
                    note = "probe",
                    dataInizio = DateTime.UtcNow.Date,
                    dataFine = (DateTime?)null,
                    principale = false,
                    ordinePriorita = (int?)null,
                    isVerificato = false,
                    dataVerifica = (DateTime?)null,
                    isPubblico = true
                });

            if (probeResponse.StatusCode == HttpStatusCode.Created)
            {
                var created = JsonNode.Parse(await probeResponse.Content.ReadAsStringAsync())?.AsObject();
                var probeId = created?["contattoId"]?.GetValue<int>() ?? 0;
                if (probeId > 0)
                {
                    var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/unita-contatti/{probeId}");
                    Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);
                }

                return candidate;
            }

            if (probeResponse.StatusCode != HttpStatusCode.Conflict)
            {
                probeResponse.EnsureSuccessStatusCode();
            }
        }

        throw new InvalidOperationException("Nessun TipoContatto valido trovato nel range 1..100.");
    }
}
