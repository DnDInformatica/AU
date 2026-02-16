using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetByIdInt;

internal static class Handler
{
    public static async Task<PersonaDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = """
            SELECT
                p.PersonaId,
                p.Cognome,
                p.Nome,
                p.CodiceFiscale,
                p.DataNascita,
                p.DataCancellazione
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<PersonaDetailDto>(
            new CommandDefinition(sql, new { command.PersonaId }, cancellationToken: cancellationToken));
    }
}

