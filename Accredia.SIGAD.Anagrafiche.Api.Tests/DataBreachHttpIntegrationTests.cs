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

public sealed class DataBreachHttpIntegrationTests
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

        var id = 0;

        try
        {
            var created = await CreateAsync(client, new
            {
                codice = $"DB_{DateTime.UtcNow:yyyyMMddHHmmss}",
                titolo = "Data breach test",
                descrizione = "descr",
                dataScoperta = DateTime.UtcNow,
                dataInizioViolazione = (DateTime?)null,
                dataFineViolazione = (DateTime?)null,
                tipoViolazione = "RISERVATEZZA",
                causaViolazione = "errore",
                categorieDatiCoinvolti = "DATI_TEST",
                datiParticolariCoinvolti = false,
                numeroInteressatiStimato = (int?)null,
                categorieInteressati = "INTERESSATI_TEST",
                rischioPerInteressati = "BASSO",
                descrizioneRischio = (string?)null,
                notificaGaranteRichiesta = false,
                dataNotificaGarante = (DateTime?)null,
                protocolloGarante = (string?)null,
                termineNotificaGarante = (DateTime?)null,
                comunicazioneInteressatiRichiesta = false,
                dataComunicazioneInteressati = (DateTime?)null,
                modalitaComunicazione = (string?)null,
                misureContenimento = (string?)null,
                misurePrevenzione = (string?)null,
                responsabileGestioneId = (int?)null,
                dpoCoinvolto = false,
                stato = "APERTO",
                dataChiusura = (DateTime?)null
            });
            id = created.DataBreachId;

            var list = await ListAsync(client, includeDeleted: false);
            Assert.Contains(list, x => x.DataBreachId == id);

            var updated = await UpdateAsync(client, id, new
            {
                codice = created.Codice,
                titolo = created.Titolo,
                descrizione = "descr upd",
                dataScoperta = created.DataScoperta,
                dataInizioViolazione = (DateTime?)null,
                dataFineViolazione = (DateTime?)null,
                tipoViolazione = created.TipoViolazione,
                causaViolazione = created.CausaViolazione,
                categorieDatiCoinvolti = created.CategorieDatiCoinvolti,
                datiParticolariCoinvolti = created.DatiParticolariCoinvolti,
                numeroInteressatiStimato = created.NumeroInteressatiStimato,
                categorieInteressati = created.CategorieInteressati,
                rischioPerInteressati = created.RischioPerInteressati,
                descrizioneRischio = created.DescrizioneRischio,
                notificaGaranteRichiesta = created.NotificaGaranteRichiesta,
                dataNotificaGarante = created.DataNotificaGarante,
                protocolloGarante = created.ProtocolloGarante,
                termineNotificaGarante = created.TermineNotificaGarante,
                comunicazioneInteressatiRichiesta = created.ComunicazioneInteressatiRichiesta,
                dataComunicazioneInteressati = created.DataComunicazioneInteressati,
                modalitaComunicazione = created.ModalitaComunicazione,
                misureContenimento = created.MisureContenimento,
                misurePrevenzione = created.MisurePrevenzione,
                responsabileGestioneId = created.ResponsabileGestioneId,
                dpoCoinvolto = created.DPOCoinvolto,
                stato = "IN_GESTIONE",
                dataChiusura = (DateTime?)null
            });
            Assert.Equal("IN_GESTIONE", updated.Stato);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/data-breach/{id}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var listAfter = await ListAsync(client, includeDeleted: false);
            Assert.DoesNotContain(listAfter, x => x.DataBreachId == id);

            var listAfterIncl = await ListAsync(client, includeDeleted: true);
            Assert.Contains(listAfterIncl, x => x.DataBreachId == id);
        }
        finally
        {
            if (id > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/data-breach/{id}");
            }
        }
    }

    private static async Task<IReadOnlyList<RowDto>> ListAsync(HttpClient client, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/data-breach?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new RowDto(
                item?["dataBreachId"]?.GetValue<int>() ?? 0,
                item?["codice"]?.GetValue<string>() ?? string.Empty,
                item?["stato"]?.GetValue<string>() ?? string.Empty,
                item?["dataCancellazione"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static async Task<ItemDto> CreateAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone/data-breach", request);
        response.EnsureSuccessStatusCode();
        return ParseItem(await response.Content.ReadAsStringAsync());
    }

    private static async Task<ItemDto> UpdateAsync(HttpClient client, int id, object request)
    {
        var response = await client.PutAsJsonAsync($"/anagrafiche/v1/persone/data-breach/{id}", request);
        response.EnsureSuccessStatusCode();
        return ParseItem(await response.Content.ReadAsStringAsync());
    }

    private static ItemDto ParseItem(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid data breach payload.");

        return new ItemDto(
            json["dataBreachId"]?.GetValue<int>() ?? 0,
            json["codice"]?.GetValue<string>() ?? string.Empty,
            json["titolo"]?.GetValue<string>() ?? string.Empty,
            json["descrizione"]?.GetValue<string>() ?? string.Empty,
            json["dataScoperta"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            json["tipoViolazione"]?.GetValue<string>() ?? string.Empty,
            json["causaViolazione"]?.GetValue<string>() ?? string.Empty,
            json["categorieDatiCoinvolti"]?.GetValue<string>() ?? string.Empty,
            json["datiParticolariCoinvolti"]?.GetValue<bool>() ?? false,
            json["numeroInteressatiStimato"]?.GetValue<int?>(),
            json["categorieInteressati"]?.GetValue<string>() ?? string.Empty,
            json["rischioPerInteressati"]?.GetValue<string>() ?? string.Empty,
            json["descrizioneRischio"]?.GetValue<string>(),
            json["notificaGaranteRichiesta"]?.GetValue<bool>() ?? false,
            json["dataNotificaGarante"]?.GetValue<DateTime?>(),
            json["protocolloGarante"]?.GetValue<string>(),
            json["termineNotificaGarante"]?.GetValue<DateTime?>(),
            json["comunicazioneInteressatiRichiesta"]?.GetValue<bool>() ?? false,
            json["dataComunicazioneInteressati"]?.GetValue<DateTime?>(),
            json["modalitaComunicazione"]?.GetValue<string>(),
            json["misureContenimento"]?.GetValue<string>(),
            json["misurePrevenzione"]?.GetValue<string>(),
            json["responsabileGestioneId"]?.GetValue<int?>(),
            json["dpoCoinvolto"]?.GetValue<bool>() ?? false,
            json["stato"]?.GetValue<string>() ?? string.Empty,
            json["dataChiusura"]?.GetValue<DateTime?>(),
            json["dataCancellazione"]?.GetValue<DateTime?>());
    }

    private sealed record RowDto(
        int DataBreachId,
        string Codice,
        string Stato,
        DateTime? DataCancellazione);

    private sealed record ItemDto(
        int DataBreachId,
        string Codice,
        string Titolo,
        string Descrizione,
        DateTime DataScoperta,
        string TipoViolazione,
        string CausaViolazione,
        string CategorieDatiCoinvolti,
        bool DatiParticolariCoinvolti,
        int? NumeroInteressatiStimato,
        string CategorieInteressati,
        string RischioPerInteressati,
        string? DescrizioneRischio,
        bool NotificaGaranteRichiesta,
        DateTime? DataNotificaGarante,
        string? ProtocolloGarante,
        DateTime? TermineNotificaGarante,
        bool ComunicazioneInteressatiRichiesta,
        DateTime? DataComunicazioneInteressati,
        string? ModalitaComunicazione,
        string? MisureContenimento,
        string? MisurePrevenzione,
        int? ResponsabileGestioneId,
        bool DPOCoinvolto,
        string Stato,
        DateTime? DataChiusura,
        DateTime? DataCancellazione);
}

