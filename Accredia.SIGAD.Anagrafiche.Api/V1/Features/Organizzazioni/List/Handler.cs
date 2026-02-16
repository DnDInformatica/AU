using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.List;

internal static class Handler
{
    public static async Task<PagedResponse<OrganizzazioneDto>> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string countSql = "SELECT COUNT(1) FROM [Anagrafiche].[Organizzazioni];";
        const string listSql = @"
SELECT
    [OrganizzazioneId],
    [Codice],
    [Denominazione],
    [IsActive],
    [CreatedUtc]
FROM [Anagrafiche].[Organizzazioni]
ORDER BY [Denominazione]
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;";

        var offset = (command.Page - 1) * command.PageSize;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var totalCount = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(countSql, cancellationToken: cancellationToken));

        var items = (await connection.QueryAsync<OrganizzazioneDto>(
            new CommandDefinition(
                listSql,
                new { Offset = offset, PageSize = command.PageSize },
                cancellationToken: cancellationToken)))
            .ToList();

        return new PagedResponse<OrganizzazioneDto>(items, command.Page, command.PageSize, totalCount);
    }
}
