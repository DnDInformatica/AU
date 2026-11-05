using System.Security.Cryptography;
using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFoundDocumento
    }

    private sealed record DocumentoStorageRow(
        int DocumentoId,
        int PersonaId,
        string NomeFile,
        string? ContentType,
        string StorageKey);

    public static async Task<IReadOnlyList<PersonaDocumentoDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        // 14/08/2026: rimossa la creazione automatica dello schema.
        // Lo schema e' governato dal progetto Database (DacFx), non dall'applicazione.

        var exists = await PersonaExistsAsync(connection, command.PersonaId, cancellationToken);
        if (!exists)
        {
            return null;
        }

        const string sql = """
            SELECT
                d.DocumentoId,
                d.PersonaId,
                d.NomeFile,
                d.ContentType,
                d.DimensioneBytes,
                d.HashSha256,
                d.Note,
                d.DataCreazione AS CreatedAtUtc,
                d.DataCancellazione AS DeletedAtUtc
            FROM [Persone].[PersonaDocumento] d
            WHERE d.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR d.DataCancellazione IS NULL)
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY d.DataCreazione DESC, d.DocumentoId DESC;
            """;

        return (await connection.QueryAsync<PersonaDocumentoDto>(new CommandDefinition(
            sql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<(WriteResult Result, PersonaDocumentoDto? Item)> UploadAsync(
        UploadCommand command,
        IDbConnectionFactory connectionFactory,
        IPersonaDocumentStorage documentStorage,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        // 14/08/2026: rimossa la creazione automatica dello schema.
        // Lo schema e' governato dal progetto Database (DacFx), non dall'applicazione.

        var personaExists = await PersonaExistsAsync(connection, command.PersonaId, cancellationToken);
        if (!personaExists)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        byte[] content;
        await using (var input = command.File.OpenReadStream())
        {
            using var memory = new MemoryStream();
            await input.CopyToAsync(memory, cancellationToken);
            content = memory.ToArray();
        }

        var now = DateTime.UtcNow;
        var actorInt = ResolveActor(command.Actor);
        var note = string.IsNullOrWhiteSpace(command.Note) ? null : command.Note.Trim();
        var contentType = string.IsNullOrWhiteSpace(command.File.ContentType) ? "application/octet-stream" : command.File.ContentType.Trim();
        var hash = Convert.ToHexString(SHA256.HashData(content)).ToLowerInvariant();
        var storageKey = BuildStorageKey(command.PersonaId, command.File.FileName);
        var fileName = Path.GetFileName(command.File.FileName);

        await documentStorage.SaveAsync(storageKey, content, cancellationToken);

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[PersonaDocumento]
                ([PersonaId], [NomeFile], [ContentType], [DimensioneBytes], [HashSha256], [Note], [StorageKey],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.DocumentoId INTO @newIds(Id)
            VALUES
                (@PersonaId, @NomeFile, @ContentType, @DimensioneBytes, @HashSha256, @Note, @StorageKey,
                 @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                d.DocumentoId,
                d.PersonaId,
                d.NomeFile,
                d.ContentType,
                d.DimensioneBytes,
                d.HashSha256,
                d.Note,
                d.DataCreazione AS CreatedAtUtc,
                d.DataCancellazione AS DeletedAtUtc
            FROM [Persone].[PersonaDocumento] d
            WHERE d.DocumentoId = @DocumentoId
              AND d.PersonaId = @PersonaId
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var documentoId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.PersonaId,
                NomeFile = fileName,
                ContentType = contentType,
                DimensioneBytes = content.LongLength,
                HashSha256 = hash,
                Note = note,
                StorageKey = storageKey,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleOrDefaultAsync<PersonaDocumentoDto>(new CommandDefinition(
            byIdSql,
            new { DocumentoId = documentoId, command.PersonaId },
            cancellationToken: cancellationToken));

        return item is null ? (WriteResult.NotFoundDocumento, null) : (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, DocumentoDownloadDto? Item)> DownloadAsync(
        DownloadCommand command,
        IDbConnectionFactory connectionFactory,
        IPersonaDocumentStorage documentStorage,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        // 14/08/2026: rimossa la creazione automatica dello schema.
        // Lo schema e' governato dal progetto Database (DacFx), non dall'applicazione.

        var personaExists = await PersonaExistsAsync(connection, command.PersonaId, cancellationToken);
        if (!personaExists)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        const string sql = """
            SELECT TOP (1)
                d.DocumentoId,
                d.PersonaId,
                d.NomeFile,
                d.ContentType,
                d.StorageKey
            FROM [Persone].[PersonaDocumento] d
            WHERE d.DocumentoId = @DocumentoId
              AND d.PersonaId = @PersonaId
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        var row = await connection.QuerySingleOrDefaultAsync<DocumentoStorageRow>(new CommandDefinition(
            sql,
            new { command.DocumentoId, command.PersonaId },
            cancellationToken: cancellationToken));

        if (row is null)
        {
            return (WriteResult.NotFoundDocumento, null);
        }

        var content = await documentStorage.TryReadAsync(row.StorageKey, cancellationToken);
        if (content is null)
        {
            return (WriteResult.NotFoundDocumento, null);
        }

        var contentType = string.IsNullOrWhiteSpace(row.ContentType) ? "application/octet-stream" : row.ContentType;
        return (WriteResult.Success, new DocumentoDownloadDto(row.NomeFile, contentType, content));
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        // 14/08/2026: rimossa la creazione automatica dello schema.
        // Lo schema e' governato dal progetto Database (DacFx), non dall'applicazione.

        var personaExists = await PersonaExistsAsync(connection, command.PersonaId, cancellationToken);
        if (!personaExists)
        {
            return WriteResult.NotFoundPersona;
        }

        const string sql = """
            UPDATE [Persone].[PersonaDocumento]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE DocumentoId = @DocumentoId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = ResolveActor(command.Actor);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.DocumentoId, command.PersonaId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFoundDocumento : WriteResult.Success;
    }

    private static async Task<bool> PersonaExistsAsync(
        System.Data.Common.DbConnection connection,
        int personaId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { PersonaId = personaId },
            cancellationToken: cancellationToken));

        return count > 0;
    }

    private static async Task EnsureSchemaAsync(System.Data.Common.DbConnection connection, CancellationToken cancellationToken)
    {
        const string sql = """
            IF SCHEMA_ID('Persone') IS NULL
            BEGIN
                EXEC('CREATE SCHEMA [Persone]');
            END;

            IF OBJECT_ID('[Persone].[PersonaDocumento]', 'U') IS NULL
            BEGIN
                CREATE TABLE [Persone].[PersonaDocumento]
                (
                    [DocumentoId] INT IDENTITY(1,1) NOT NULL,
                    [PersonaId] INT NOT NULL,
                    [NomeFile] NVARCHAR(260) NOT NULL,
                    [ContentType] NVARCHAR(200) NULL,
                    [DimensioneBytes] BIGINT NOT NULL,
                    [HashSha256] NVARCHAR(64) NULL,
                    [Note] NVARCHAR(1000) NULL,
                    [StorageKey] NVARCHAR(400) NOT NULL,
                    [DataCreazione] DATETIME2(7) NOT NULL,
                    [CreatoDa] INT NOT NULL,
                    [DataModifica] DATETIME2(7) NOT NULL,
                    [ModificatoDa] INT NOT NULL,
                    [DataCancellazione] DATETIME2(7) NULL,
                    [CancellatoDa] INT NULL,
                    [UniqueRowId] UNIQUEIDENTIFIER NOT NULL,
                    [DataInizioValidita] DATETIME2(7) NOT NULL,
                    [DataFineValidita] DATETIME2(7) NOT NULL,
                    CONSTRAINT [PK_Persone_PersonaDocumento] PRIMARY KEY CLUSTERED ([DocumentoId] ASC)
                );

                CREATE INDEX [IX_Persone_PersonaDocumento_PersonaId]
                    ON [Persone].[PersonaDocumento] ([PersonaId], [DataCancellazione], [DocumentoId]);
            END;
            """;

        await connection.ExecuteAsync(new CommandDefinition(sql, cancellationToken: cancellationToken));
    }

    private static string BuildStorageKey(int personaId, string originalFileName)
    {
        var fileName = Path.GetFileName(originalFileName);
        var extension = Path.GetExtension(fileName);
        return $"{personaId}/{DateTime.UtcNow:yyyy/MM}/{Guid.NewGuid():N}{extension}";
    }

    private static int ResolveActor(string? actor)
    {
        var actorRaw = string.IsNullOrWhiteSpace(actor) ? "system" : actor.Trim();
        return int.TryParse(actorRaw, out var actorInt) ? actorInt : 0;
    }
}
