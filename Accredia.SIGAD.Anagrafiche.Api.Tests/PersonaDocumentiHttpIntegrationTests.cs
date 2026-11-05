using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json.Nodes;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class PersonaDocumentiHttpIntegrationTests
{
    [Fact]
    public async Task UploadListDownloadDelete_Works()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();
        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        var personaId = 0;
        var documentoId = 0;
        var payload = $"sigad-doc-test-{Guid.NewGuid():N}";

        try
        {
            var createdPersona = await CreatePersonaAsync(client, new
            {
                cognome = $"DocTest_{DateTime.UtcNow:yyyyMMddHHmmss}",
                nome = "Upload",
                codiceFiscale = NewFiscalCode(),
                dataNascita = new DateTime(1988, 7, 14, 0, 0, 0, DateTimeKind.Utc)
            });
            personaId = createdPersona.PersonaId;

            var listBefore = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Empty(listBefore);

            var created = await UploadAsync(client, personaId, "test-doc.txt", "text/plain", payload, "note integrazione");
            documentoId = created.DocumentoId;

            var listAfterCreate = await ListAsync(client, personaId, includeDeleted: false);
            Assert.Contains(listAfterCreate, x => x.DocumentoId == documentoId);

            var downloadResponse = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/documenti/{documentoId}/download");
            Assert.Equal(HttpStatusCode.OK, downloadResponse.StatusCode);
            var downloadedContent = await downloadResponse.Content.ReadAsStringAsync();
            Assert.Equal(payload, downloadedContent);

            var deleteResponse = await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/documenti/{documentoId}");
            Assert.Equal(HttpStatusCode.NoContent, deleteResponse.StatusCode);

            var listAfterDelete = await ListAsync(client, personaId, includeDeleted: false);
            Assert.DoesNotContain(listAfterDelete, x => x.DocumentoId == documentoId);

            var listAfterDeleteIncl = await ListAsync(client, personaId, includeDeleted: true);
            Assert.Contains(listAfterDeleteIncl, x => x.DocumentoId == documentoId && x.DeletedAtUtc is not null);
        }
        finally
        {
            if (documentoId > 0 && personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}/documenti/{documentoId}");
            }

            if (personaId > 0)
            {
                await client.DeleteAsync($"/anagrafiche/v1/persone/{personaId}");
            }
        }
    }

    private static async Task<PersonaDetailDto> CreatePersonaAsync(HttpClient client, object request)
    {
        var response = await client.PostAsJsonAsync("/anagrafiche/v1/persone", request);
        response.EnsureSuccessStatusCode();
        return ParsePersona(await response.Content.ReadAsStringAsync());
    }

    private static async Task<PersonaDocumentoDto> UploadAsync(HttpClient client, int personaId, string fileName, string contentType, string content, string? note)
    {
        using var form = new MultipartFormDataContent();
        var bytes = Encoding.UTF8.GetBytes(content);
        using var fileContent = new ByteArrayContent(bytes);
        fileContent.Headers.ContentType = new MediaTypeHeaderValue(contentType);
        form.Add(fileContent, "file", fileName);
        if (!string.IsNullOrWhiteSpace(note))
        {
            form.Add(new StringContent(note), "note");
        }

        var response = await client.PostAsync($"/anagrafiche/v1/persone/{personaId}/documenti", form);
        response.EnsureSuccessStatusCode();
        return ParseDocumento(await response.Content.ReadAsStringAsync());
    }

    private static async Task<IReadOnlyList<PersonaDocumentoDto>> ListAsync(HttpClient client, int personaId, bool includeDeleted)
    {
        var response = await client.GetAsync($"/anagrafiche/v1/persone/{personaId}/documenti?includeDeleted={(includeDeleted ? "true" : "false")}");
        response.EnsureSuccessStatusCode();

        var json = JsonNode.Parse(await response.Content.ReadAsStringAsync())?.AsArray();
        return json?
            .Select(item => new PersonaDocumentoDto(
                item?["documentoId"]?.GetValue<int>() ?? 0,
                item?["personaId"]?.GetValue<int>() ?? 0,
                item?["nomeFile"]?.GetValue<string>() ?? string.Empty,
                item?["contentType"]?.GetValue<string>(),
                item?["dimensioneBytes"]?.GetValue<long>() ?? 0,
                item?["hashSha256"]?.GetValue<string>(),
                item?["note"]?.GetValue<string>(),
                item?["createdAtUtc"]?.GetValue<DateTime>() ?? DateTime.MinValue,
                item?["deletedAtUtc"]?.GetValue<DateTime?>()))
            .ToList()
            ?? [];
    }

    private static PersonaDocumentoDto ParseDocumento(string payload)
    {
        var json = JsonNode.Parse(payload)?.AsObject()
                   ?? throw new InvalidOperationException("Invalid documento payload.");

        return new PersonaDocumentoDto(
            json["documentoId"]?.GetValue<int>() ?? 0,
            json["personaId"]?.GetValue<int>() ?? 0,
            json["nomeFile"]?.GetValue<string>() ?? string.Empty,
            json["contentType"]?.GetValue<string>(),
            json["dimensioneBytes"]?.GetValue<long>() ?? 0,
            json["hashSha256"]?.GetValue<string>(),
            json["note"]?.GetValue<string>(),
            json["createdAtUtc"]?.GetValue<DateTime>() ?? DateTime.MinValue,
            json["deletedAtUtc"]?.GetValue<DateTime?>());
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
        => $"TD{Guid.NewGuid():N}".Substring(0, 16).ToUpperInvariant();

    private sealed record PersonaDocumentoDto(
        int DocumentoId,
        int PersonaId,
        string NomeFile,
        string? ContentType,
        long DimensioneBytes,
        string? HashSha256,
        string? Note,
        DateTime CreatedAtUtc,
        DateTime? DeletedAtUtc);

    private sealed record PersonaDetailDto(
        int PersonaId,
        string Cognome,
        string Nome);
}
