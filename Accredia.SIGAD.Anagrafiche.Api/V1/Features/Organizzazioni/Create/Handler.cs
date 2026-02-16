using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Create;

internal static class Handler
{
    public static async Task<OrganizzazioneDto> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var organizzazioneId = Guid.NewGuid();
        var createdUtc = DateTime.UtcNow;
        var request = command.Request;

        const string sql = @"
INSERT INTO [Anagrafiche].[Organizzazioni]
    ([OrganizzazioneId], [Codice], [Denominazione], [IsActive], [CreatedUtc])
VALUES
    (@OrganizzazioneId, @Codice, @Denominazione, @IsActive, @CreatedUtc);";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new
            {
                OrganizzazioneId = organizzazioneId,
                Codice = request.Codice,
                Denominazione = request.Denominazione,
                IsActive = request.IsActive,
                CreatedUtc = createdUtc
            },
            cancellationToken: cancellationToken));

        return new OrganizzazioneDto(
            organizzazioneId,
            request.Codice,
            request.Denominazione,
            request.IsActive,
            createdUtc);
    }
}
