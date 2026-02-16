using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaGetById;

internal static class Handler
{
    public static async Task<UnitaOrganizzativaDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
SELECT
    u.UnitaOrganizzativaId,
    u.Nome,
    u.Codice,
    u.Principale,
    u.TipoUnitaOrganizzativaId,
    u.TipoSedeId
FROM [Organizzazioni].[UnitaOrganizzativa] u
WHERE u.OrganizzazioneId = @OrganizzazioneId
  AND u.UnitaOrganizzativaId = @UnitaOrganizzativaId
  AND u.DataCancellazione IS NULL
  AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
  AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<UnitaOrganizzativaDto>(
            new CommandDefinition(sql, new { command.OrganizzazioneId, command.UnitaOrganizzativaId }, cancellationToken: cancellationToken));
    }
}

