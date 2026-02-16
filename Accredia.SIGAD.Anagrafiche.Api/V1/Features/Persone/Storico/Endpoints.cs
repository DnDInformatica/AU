using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Storico;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/persona", "PersoneStoricoPersona", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetPersonaAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/email", "PersoneStoricoEmail", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetEmailAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaEmailStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/telefoni", "PersoneStoricoTelefoni", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetTelefoniAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaTelefonoStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/indirizzi", "PersoneStoricoIndirizzi", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetIndirizziAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaIndirizzoStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/qualifiche", "PersoneStoricoQualifiche", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetQualificheAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaQualificaStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/titoli-studio", "PersoneStoricoTitoliStudio", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetTitoliStudioAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaTitoloStudioStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/relazioni-personali", "PersoneStoricoRelazioniPersonali", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetRelazioniPersonaliAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaRelazionePersonaleStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/utente", "PersoneStoricoUtente", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetUtenteAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<PersonaUtenteStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/{id:int}/storico/consensi", "PersoneStoricoConsensi", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new PersonaCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetConsensiAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<ConsensoPersonaStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/registro-trattamenti/{id:int}/storico", "PersoneStoricoRegistroTrattamenti", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new RegistroTrattamentiCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetRegistroTrattamentiAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<RegistroTrattamentiStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/richieste-gdpr/{id:int}/storico", "PersoneStoricoRichiestaGdpr", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new RichiestaGdprCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetRichiestaGdprAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<RichiestaGdprStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/richieste-esercizio-diritti/{id:int}/storico", "PersoneStoricoRichiestaEsercizioDiritti", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new RichiestaEsercizioDirittiCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetRichiestaEsercizioDirittiAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<RichiestaEsercizioDirittiStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/persone/data-breach/{id:int}/storico", "PersoneStoricoDataBreach", async (
                int id,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new DataBreachCommand(id);
                var errors = Validator.Validate(command);
                if (errors is not null) return Results.ValidationProblem(errors);

                var response = await Handler.GetDataBreachAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<DataBreachStoricoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

