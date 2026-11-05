using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

internal static class Handler
{
    public static async Task<CertificazioneDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
SELECT
    e.EnteAccreditamentoId AS CertificazioneId,
    e.Denominazione,
    e.Sigla,
    e.Note,
    e.DataFondazione,
    e.DataCancellazione
FROM [Accreditamento].[EnteAccreditamento] e
WHERE e.EnteAccreditamentoId = @CertificazioneId
  AND (e.DataInizioValidita IS NULL OR e.DataInizioValidita <= SYSUTCDATETIME())
  AND (e.DataFineValidita IS NULL OR e.DataFineValidita >= SYSUTCDATETIME());";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<CertificazioneDetailDto>(
            new CommandDefinition(sql, new { command.CertificazioneId }, cancellationToken: cancellationToken));
    }
}
