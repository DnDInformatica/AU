using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Update;

internal static class Handler
{
    public static async Task<OrganizzazioneDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string updateSql = @"
UPDATE [Anagrafiche].[Organizzazioni]
SET [Codice] = @Codice,
    [Denominazione] = @Denominazione,
    [IsActive] = @IsActive
WHERE [OrganizzazioneId] = @OrganizzazioneId;";

        const string selectSql = @"
SELECT
    [OrganizzazioneId],
    [Codice],
    [Denominazione],
    [IsActive],
    [CreatedUtc]
FROM [Anagrafiche].[Organizzazioni]
WHERE [OrganizzazioneId] = @OrganizzazioneId;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                OrganizzazioneId = command.OrganizzazioneId,
                Codice = command.Request.Codice,
                Denominazione = command.Request.Denominazione,
                IsActive = command.Request.IsActive
            },
            cancellationToken: cancellationToken));

        if (rows == 0)
        {
            return null;
        }

        return await connection.QuerySingleAsync<OrganizzazioneDto>(new CommandDefinition(
            selectSql,
            new { command.OrganizzazioneId },
            cancellationToken: cancellationToken));
    }
}
