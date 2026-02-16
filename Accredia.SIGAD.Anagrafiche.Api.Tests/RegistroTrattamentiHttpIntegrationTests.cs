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

public sealed class RegistroTrattamentiHttpIntegrationTests
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

        var finalitaId = await GetFinalitaIdAsync(client);
        var id = 0;

        try
        {
            var created = await CreateAsync(client, new
            {
                codice = $"RT_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nomeTrattamento = "Trattamento test",
                descrizione = (string?)null,
                tipoFinalitaTrattamentoId = finalitaId,
                baseGiuridica = "ART6_1_A",
                categorieDati = "DATI_TEST",
                categorieInteressati = "INTERESSATI_TEST",
                datiParticolari = false,
                datiGiudiziari = false,
                categorieDestinatari = (string?)null,
                trasferimentoExtraUE = false,
                paesiExtraUE = (string?)null,
                garanzieExtraUE = (string?)null,
                termineConservazione = "30 giorni",
                termineConservazioneGiorni = 30,
                misureSicurezza = (string?)null,
                responsabileTrattamentoId = (int?)null,
                contitolareId = (int?)null,
                dpoNotificato = false,
                stato = "ATTIVO",
                dataInizioTrattamento = DateTime.UtcNow.Date,
                dataFineTrattamento = (DateTime?)null
            });
            id = created.RegistroTrattamentiId;

            var list = await ListAsync(client, includeDeleted: false);
            Assert.Contains(list, x => x.RegistroTrattamentiId == id);

            var updated = await UpdateAsync(client, id, new
            {
                codice = created.Codice,
                nomeTrattamento = "Trattamento test upd",
                descrizione = "updated",
                tipoFinalitaTrattamentoId = finalitaId,
                baseGiuridica = "ART6_1_A",
                categorieDati = "DATI_TEST",
                categorieInteressati = "INTERESSATI_TEST",
                datiParticolari = false,
                datiGiudiziari = false,
                categorieDestinatari = (string?)null,
                trasferimentoExtraUE = false,
                paesiExtraUE = (string?)null,
                garanzieExtraUE = (string?)null,
                termineConservazione = "60 giorni",
                termineConservazioneGiorni = 60,
                misureSicurezza = (string?)null,
                responsabileTrattamentoId = (int?)null,
                contitolareId = (int?)null,
                dpoNotificato = false,
                stato = "SOSPESO",
                dataInizioTrattamento = created.DataInizioTrattamento,
                dataFineTrattamento = (DateTime?)null
            });
            Assert.Equal("SOSPESO", updated.Stato);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/registro-trattamenti/{id}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var listAfter = await ListAsync(client, includeDeleted: false);
            Assert.DoesNotContain(listAfter, x => x.RegistroTrattamentiId == id);

            var listAfterIncl = await ListAsync(client, includeDeleted: true);
            Assert.Contains(listAfterIncl, x => x.RegistroTrattamentiId == id);
        }
        finally
        {
            if (id > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/registro-trattamenti/{id}");
            }
        }
    }

    private static async Task<int> GetFinalitaIdAsync(HttpClient client)
    {
        var response = await client.GetAsync("/anagrafiche/v1/persone/registro-trattamenti/lookups");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?[0]?["id"]?.GetValue<int>()
               ?? throw new InvalidOperationException("No TipoFinalitaTrattamento lookup found.");
    }

    private static async Task<IReadOnlyList<RegistroDto>> ListAsync(HttpClient client, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/registro-trattamenti?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();
        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new RegistroDto(
                item?["registroTrattamentiId"]?.GetValue<int>() ?? 0,
                item?["codice"]?.GetValue<string>() ?? string.Empty,
                item?["stato"]?.GetValue<string>() ?? string.Empty,
                item?["dataInizioTrattamento"]?.GetValue<DateTime>() ?? DateTime.MinValue,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<RegistroDto> CreateAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone/registro-trattamenti", request);
        response.EnsureSuccessStatusCode();
        return ParseRegistro(await response.Content.ReadAsStringAsync());
    }

    private static async Task<RegistroDto> UpdateAsync(HttpClient client, int id, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/registro-trattamenti/{id}", request);
        response.EnsureSuccessStatusCode();
        return ParseRegistro(await response.Content.ReadAsStringAsync());
    }

    private static RegistroDto ParseRegistro(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid registro payload.");

        return new RegistroDto(
            json["registroTrattamentiId"]?.GetValue<int>() ?? 0,
            json["codice"]?.GetValue<string>() ?? string.Empty,
            json["stato"]?.GetValue<string>() ?? string.Empty,
            json["dataInizioTrattamento"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            json["dataCancellazione"]?.GetValue<DateTime?>());
    }

    private sealed record RegistroDto(
        int RegistroTrattamentiId,
        string Codice,
        string Stato,
        DateTime DataInizioTrattamento,
        DateTime? DataCancellazione);
}

