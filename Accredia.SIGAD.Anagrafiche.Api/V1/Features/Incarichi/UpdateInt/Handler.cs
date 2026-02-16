using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.UpdateInt;

internal static class Handler
{
    public static async Task<IncaricoDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string existsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[Incarico] i
WHERE i.IncaricoId = @IncaricoId
  AND i.DataCancellazione IS NULL
  AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
  AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());";

        const string personaExistsSql = @"
SELECT COUNT(1)
FROM [Persone].[Persona] p
WHERE p.PersonaId = @PersonaId
  AND p.DataCancellazione IS NULL
  AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
  AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());";

        const string orgExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId
  AND o.DataCancellazione IS NULL
  AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
  AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());";

        const string uoExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[UnitaOrganizzativa] u
WHERE u.UnitaOrganizzativaId = @UnitaOrganizzativaId
  AND u.OrganizzazioneId = @OrganizzazioneId
  AND u.DataCancellazione IS NULL
  AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
  AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());";

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var sets = new List<string>();
        var p = new DynamicParameters();
        p.Add("IncaricoId", command.IncaricoId);

        void Set(string col, string sql, object? value)
        {
            if (!columns.ContainsKey(col))
            {
                return;
            }

            sets.Add(sql);
            p.Add(col, value);
        }

        int? organizzazioneIdForPersistence = command.Request.UnitaOrganizzativaId.HasValue
            ? null
            : command.Request.OrganizzazioneId;

        Set("PersonaId", "[PersonaId] = @PersonaId", command.Request.PersonaId);
        Set("OrganizzazioneId", "[OrganizzazioneId] = @OrganizzazioneId", organizzazioneIdForPersistence);
        Set("TipoRuoloId", "[TipoRuoloId] = @TipoRuoloId", command.Request.TipoRuoloId);
        Set("StatoIncarico", "[StatoIncarico] = @StatoIncarico", command.Request.StatoIncarico.Trim());
        Set("DataInizio", "[DataInizio] = @DataInizio", command.Request.DataInizio);
        Set("DataFine", "[DataFine] = @DataFine", command.Request.DataFine);
        Set("UnitaOrganizzativaId", "[UnitaOrganizzativaId] = @UnitaOrganizzativaId", command.Request.UnitaOrganizzativaId);

        if (columns.ContainsKey("DataModifica"))
        {
            Set("DataModifica", "[DataModifica] = @DataModifica", now);
        }

        if (columns.ContainsKey("ModificatoDa"))
        {
            Set("ModificatoDa", "[ModificatoDa] = @ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));
        }

        if (sets.Count == 0)
        {
            return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.IncaricoId), connectionFactory, cancellationToken);
        }

        var sql = $"""
            UPDATE [Organizzazioni].[Incarico]
            SET {string.Join(", ", sets)}
            WHERE [IncaricoId] = @IncaricoId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(existsSql, new { command.IncaricoId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var personaExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(personaExistsSql, new { command.Request.PersonaId }, cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return null;
        }

        var orgExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.Request.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (orgExists == 0)
        {
            return null;
        }

        if (command.Request.UnitaOrganizzativaId.HasValue)
        {
            var uoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                uoExistsSql,
                new
                {
                    command.Request.UnitaOrganizzativaId,
                    command.Request.OrganizzazioneId
                },
                cancellationToken: cancellationToken));
            if (uoExists == 0)
            {
                return null;
            }
        }

        if (command.Request.TipoRuoloId.HasValue)
        {
            var hasRuolo = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                "SELECT COUNT(1) FROM [Tipologica].[TipoRuolo] WHERE [TipoRuoloId] = @Id;",
                new { Id = command.Request.TipoRuoloId.Value },
                cancellationToken: cancellationToken));
            if (hasRuolo == 0)
            {
                return null;
            }
        }

        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        if (rows == 0)
        {
            return null;
        }

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.IncaricoId), connectionFactory, cancellationToken);
    }
}
