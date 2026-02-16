using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.CreateInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SetTipologie;

internal static class Handler
{
    internal enum Result
    {
        Updated,
        NotFound,
        NotSupported,
        InvalidTipo
    }

    public static async Task<Result> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string orgExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId
  AND o.DataCancellazione IS NULL
  AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
  AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { OrganizzazioneId = command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return Result.NotFound;
        }

        var hasBridgeTable = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN OBJECT_ID('[Organizzazioni].[OrganizzazioneTipoOrganizzazione]') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken));

        var hasLegacyColumn = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[Organizzazione]', 'TipoOrganizzazioneId') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken));

        if (hasBridgeTable == 0 && hasLegacyColumn == 0)
        {
            return Result.NotSupported;
        }

        // Validate type if provided.
        if (command.Request.TipoOrganizzazioneId.HasValue)
        {
            var hasTipoTable = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                "SELECT CASE WHEN OBJECT_ID('[Tipologica].[TipoOrganizzazione]') IS NULL THEN 0 ELSE 1 END;",
                cancellationToken: cancellationToken));
            if (hasTipoTable == 0)
            {
                return Result.InvalidTipo;
            }

            var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                "SELECT COUNT(1) FROM [Tipologica].[TipoOrganizzazione] WHERE [TipoOrganizzazioneId] = @Id;",
                new { Id = command.Request.TipoOrganizzazioneId.Value },
                cancellationToken: cancellationToken));
            if (tipoExists == 0)
            {
                return Result.InvalidTipo;
            }
        }

        var orgColumns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var now = DateTime.UtcNow;
        var today = now.Date;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var hasBridgeModificatoDa = hasBridgeTable == 1 && (await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[OrganizzazioneTipoOrganizzazione]', 'ModificatoDa') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken)) == 1);
        var hasBridgeCancellatoDa = hasBridgeTable == 1 && (await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[OrganizzazioneTipoOrganizzazione]', 'CancellatoDa') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken)) == 1);
        var hasBridgeCreatoDa = hasBridgeTable == 1 && (await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[OrganizzazioneTipoOrganizzazione]', 'CreatoDa') IS NULL THEN 0 ELSE 1 END;",
            cancellationToken: cancellationToken)) == 1);

        var actorInt = int.TryParse(actor, out var parsedActor) ? parsedActor : 0;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);

        if (hasBridgeTable == 1)
        {
            var revokeSql = $"""
                UPDATE [Organizzazioni].[OrganizzazioneTipoOrganizzazione]
                SET [DataRevoca] = COALESCE([DataRevoca], @DataRevoca),
                    [MotivoRevoca] = COALESCE([MotivoRevoca], @MotivoRevoca),
                    [Principale] = CAST(0 AS bit),
                    [DataModifica] = @DataModifica,
                    {(hasBridgeModificatoDa ? "[ModificatoDa] = @BridgeModificatoDa," : string.Empty)}
                    [DataFineValidita] = @DataFineValidita,
                    [DataCancellazione] = @DataCancellazione
                    {(hasBridgeCancellatoDa ? ", [CancellatoDa] = @BridgeCancellatoDa" : string.Empty)}
                WHERE [OrganizzazioneId] = @OrganizzazioneId
                  AND [DataCancellazione] IS NULL
                  AND ([DataInizioValidita] IS NULL OR [DataInizioValidita] <= SYSUTCDATETIME())
                  AND ([DataFineValidita] IS NULL OR [DataFineValidita] >= SYSUTCDATETIME());
                """;

            var revokeParams = new DynamicParameters();
            revokeParams.Add("OrganizzazioneId", command.OrganizzazioneId);
            revokeParams.Add("DataRevoca", today);
            revokeParams.Add("MotivoRevoca", "Sostituita da nuova tipologia principale");
            revokeParams.Add("DataModifica", now);
            revokeParams.Add("DataFineValidita", now);
            revokeParams.Add("DataCancellazione", now);
            if (hasBridgeModificatoDa)
            {
                revokeParams.Add("BridgeModificatoDa", actorInt);
            }

            if (hasBridgeCancellatoDa)
            {
                revokeParams.Add("BridgeCancellatoDa", actorInt);
            }

            await connection.ExecuteAsync(new CommandDefinition(revokeSql, revokeParams, tx, cancellationToken: cancellationToken));

            var insertSql = $"""
                INSERT INTO [Organizzazioni].[OrganizzazioneTipoOrganizzazione]
                    ([OrganizzazioneId], [TipoOrganizzazioneId], [DataAssegnazione], [Principale], [DataCreazione], [DataModifica], [DataInizioValidita], [DataFineValidita]{(hasBridgeCreatoDa ? ", [CreatoDa]" : string.Empty)}{(hasBridgeModificatoDa ? ", [ModificatoDa]" : string.Empty)})
                VALUES
                    (@OrganizzazioneId, @TipoOrganizzazioneId, @DataAssegnazione, CAST(1 AS bit), @DataCreazione, @DataModifica, @DataInizioValidita, @DataFineValidita{(hasBridgeCreatoDa ? ", @BridgeCreatoDa" : string.Empty)}{(hasBridgeModificatoDa ? ", @BridgeModificatoDa" : string.Empty)});
                """;

            var insertParams = new DynamicParameters();
            insertParams.Add("OrganizzazioneId", command.OrganizzazioneId);
            insertParams.Add("TipoOrganizzazioneId", command.Request.TipoOrganizzazioneId);
            insertParams.Add("DataAssegnazione", today);
            insertParams.Add("DataCreazione", now);
            insertParams.Add("DataModifica", now);
            insertParams.Add("DataInizioValidita", now);
            insertParams.Add("DataFineValidita", fineValidita);
            if (hasBridgeCreatoDa)
            {
                insertParams.Add("BridgeCreatoDa", actorInt);
            }

            if (hasBridgeModificatoDa)
            {
                insertParams.Add("BridgeModificatoDa", actorInt);
            }

            await connection.ExecuteAsync(new CommandDefinition(insertSql, insertParams, tx, cancellationToken: cancellationToken));
        }

        var sets = new List<string>
        {
            "[TipoOrganizzazioneId] = @TipoOrganizzazioneId"
        };

        var p = new DynamicParameters();
        p.Add("OrganizzazioneId", command.OrganizzazioneId);
        p.Add("TipoOrganizzazioneId", command.Request.TipoOrganizzazioneId);

        if (orgColumns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @DataModifica");
            p.Add("DataModifica", now);
        }

        if (orgColumns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @ModificatoDa");
            p.Add("ModificatoDa", DbIntrospection.GetActorDbValue(orgColumns, "ModificatoDa", actor));
        }

        var sql = $"""
            UPDATE [Organizzazioni].[Organizzazione]
            SET {string.Join(", ", sets)}
            WHERE [OrganizzazioneId] = @OrganizzazioneId
              AND [DataCancellazione] IS NULL;
            """;

        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, tx, cancellationToken: cancellationToken));
        if (rows == 0)
        {
            await tx.RollbackAsync(cancellationToken);
            return Result.NotFound;
        }

        await tx.CommitAsync(cancellationToken);
        return Result.Updated;
    }
}
