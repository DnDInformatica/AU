using System;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class OrganizzazioniPoteriHttpIntegrationTests
{
    [Fact]
    public async Task CreateUpdateDelete_Potere_WorksEndToEnd()
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
        var incaricoId = await EnsureIncaricoAsync(client, organizzazioneId);
        var tipoPotereId = await FindValidTipoPotereAsync(client, organizzazioneId, incaricoId);

        var createResponse = await client.PostAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri",
            new
            {
                incaricoId,
                tipoPotereId,
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                limiteImportoSingolo = 1000m,
                limiteImportoGiornaliero = (decimal?)null,
                limiteImportoMensile = (decimal?)null,
                limiteImportoAnnuo = (decimal?)null,
                valuta = "EUR",
                modalitaFirma = "SINGOLA",
                ambitoTerritoriale = "NAZIONALE",
                ambitoMateriale = "TEST",
                puoDelegare = false,
                delegatoDa = (int?)null,
                statoPotere = "ATTIVO",
                dataRevoca = (DateTime?)null,
                motivoRevoca = (string?)null,
                note = "test create"
            });
        createResponse.EnsureSuccessStatusCode();

        var created = JsonNode.Parse(await createResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(created);
        var potereId = created!["potereId"]?.GetValue<int>() ?? 0;
        Assert.True(potereId > 0);

        var updateResponse = await client.PutAsJsonAsync(
            $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri/{potereId}",
            new
            {
                incaricoId,
                tipoPotereId,
                dataInizio = DateTime.UtcNow.Date,
                dataFine = (DateTime?)null,
                limiteImportoSingolo = 2000m,
                limiteImportoGiornaliero = (decimal?)null,
                limiteImportoMensile = (decimal?)null,
                limiteImportoAnnuo = (decimal?)null,
                valuta = "EUR",
                modalitaFirma = "CONGIUNTA",
                ambitoTerritoriale = "REGIONALE",
                ambitoMateriale = "TEST UPDATE",
                puoDelegare = true,
                delegatoDa = (int?)null,
                statoPotere = "ATTIVO",
                dataRevoca = (DateTime?)null,
                motivoRevoca = (string?)null,
                note = "test update"
            });
        updateResponse.EnsureSuccessStatusCode();

        var updated = JsonNode.Parse(await updateResponse.Content.ReadAsStringAsync())?.AsObject();
        Assert.NotNull(updated);
        Assert.Equal(potereId, updated!["potereId"]?.GetValue<int>());
        Assert.Equal("CONGIUNTA", updated["modalitaFirma"]?.GetValue<string>());

        var listResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri");
        listResponse.EnsureSuccessStatusCode();
        var list = JsonNode.Parse(await listResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(list);
        Assert.Contains(list!, x => x?["potereId"]?.GetValue<int>() == potereId);

        var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri/{potereId}");
        Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

        var listAfterDeleteResponse = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri");
        listAfterDeleteResponse.EnsureSuccessStatusCode();
        var listAfterDelete = JsonNode.Parse(await listAfterDeleteResponse.Content.ReadAsStringAsync())?.AsArray();
        Assert.NotNull(listAfterDelete);
        Assert.DoesNotContain(listAfterDelete!, x => x?["potereId"]?.GetValue<int>() == potereId);
    }

    private static int GetTestOrganizzazioneId()
    {
        var raw = Environment.GetEnvironmentVariable("SIGAD_TEST_ORGANIZZAZIONE_ID");
        return int.TryParse(raw, out var parsed) && parsed > 0 ? parsed : 19960;
    }

    private static async Task<int> EnsureIncaricoAsync(HttpClient client, int organizzazioneId)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/incarichi?includeDeleted=false");
        response.EnsureSuccessStatusCode();
        var incarichi = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        var existingId = incarichi?[0]?["incaricoId"]?.GetValue<int>() ?? 0;
        if (existingId > 0)
        {
            return existingId;
        }

        var personaId = await IntegrationTestSupport.GetPersonaIdAsync(client);
        var tipoRuoloId = await IntegrationTestSupport.GetTipoRuoloIdAsync(client);
        var createIncaricoResponse = await client.PostAsJsonAsync("/anagrafiche/v1/incarichi", new
        {
            personaId,
            organizzazioneId,
            tipoRuoloId,
            statoIncarico = "ATTIVO",
            dataInizio = DateTime.UtcNow.Date,
            dataFine = (DateTime?)null,
            unitaOrganizzativaId = (int?)null
        });
        createIncaricoResponse.EnsureSuccessStatusCode();
        var created = JsonNode.Parse(await createIncaricoResponse.Content.ReadAsStringAsync())?.AsObject();
        return created?["incaricoId"]?.GetValue<int>() ?? 0;
    }

    private static async Task<int> FindValidTipoPotereAsync(HttpClient client, int organizzazioneId, int incaricoId)
    {
        for (var candidate = 1; candidate <= 100; candidate++)
        {
            var probeResponse = await client.PostAsJsonAsync(
                $"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri",
                new
                {
                    incaricoId,
                    tipoPotereId = candidate,
                    dataInizio = DateTime.UtcNow.Date,
                    dataFine = (DateTime?)null,
                    limiteImportoSingolo = (decimal?)null,
                    limiteImportoGiornaliero = (decimal?)null,
                    limiteImportoMensile = (decimal?)null,
                    limiteImportoAnnuo = (decimal?)null,
                    valuta = "EUR",
                    modalitaFirma = "PROBE",
                    ambitoTerritoriale = (string?)null,
                    ambitoMateriale = (string?)null,
                    puoDelegare = false,
                    delegatoDa = (int?)null,
                    statoPotere = "ATTIVO",
                    dataRevoca = (DateTime?)null,
                    motivoRevoca = (string?)null,
                    note = "probe"
                });

            if (probeResponse.StatusCode == HttpStatusCode.Created)
            {
                var created = JsonNode.Parse(await probeResponse.Content.ReadAsStringAsync())?.AsObject();
                var probeId = created?["potereId"]?.GetValue<int>() ?? 0;
                if (probeId > 0)
                {
                    var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/organizzazioni/{organizzazioneId}/poteri/{probeId}");
                    Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);
                }

                return candidate;
            }

            if (probeResponse.StatusCode != HttpStatusCode.Conflict)
            {
                probeResponse.EnsureSuccessStatusCode();
            }
        }

        throw new InvalidOperationException("Nessun TipoPotere valido trovato nel range 1..100.");
    }
}
