using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Storico;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/organizzazione", "OrganizzazioniGetStoricoOrganizzazione", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetOrganizzazioneAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<IReadOnlyList<OrganizzazioneStoricoDto>>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/unita-organizzative", "OrganizzazioniGetStoricoUnita", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetUnitaAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<IReadOnlyList<UnitaOrganizzativaStoricoDto>>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/sedi", "OrganizzazioniGetStoricoSedi", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetSediAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<IReadOnlyList<SedeStoricoDto>>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/incarichi", "OrganizzazioniGetStoricoIncarichi", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetIncarichiAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<IReadOnlyList<IncaricoStoricoDto>>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/relazioni", "OrganizzazioniGetStoricoRelazioni", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetRelazioniAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<RelazioniStoricoResponse>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{id:int}/storico/attributi", "OrganizzazioniGetStoricoAttributi", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);
                var response = await Handler.GetAttributiAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder.Produces<AttributiStoricoResponse>(StatusCodes.Status200OK).Produces(StatusCodes.Status404NotFound).ProducesValidationProblem());
    }
}
