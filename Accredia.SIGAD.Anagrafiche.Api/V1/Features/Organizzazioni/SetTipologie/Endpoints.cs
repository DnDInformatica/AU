using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetTipologie;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SetTipologie;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPut(app, "/organizzazioni/{id:int}/tipologie", "OrganizzazioniSetTipologie", async (
                int id,
                SetOrganizzazioneTipologiaRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new Command(id, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.Handle(command, connectionFactory, cancellationToken);
                return response switch
                {
                    Handler.Result.NotFound => Results.NotFound(),
                    Handler.Result.NotSupported => Results.Conflict("Funzionalita non disponibile sul data model corrente."),
                    Handler.Result.InvalidTipo => Results.Conflict("Tipologia non valida o non presente."),
                    Handler.Result.Updated => Results.Ok(await GetTipologie.Handler.Handle(new GetTipologie.Command(id), connectionFactory, cancellationToken) ?? Array.Empty<OrganizzazioneTipoDto>()),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<IReadOnlyList<OrganizzazioneTipoDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());
    }
}

