using Accredia.SIGAD.Anagrafiche.Api.Database;
using Microsoft.AspNetCore.Mvc;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/organizzazioni/{orgId:int}/sedi-link", "OrganizzazioniSediLinkList", async (
                int orgId,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new ListCommand(orgId);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var response = await Handler.ListAsync(command, connectionFactory, cancellationToken);
                return response is null ? Results.NotFound() : Results.Ok(response);
            },
            builder => builder
                .Produces<IReadOnlyList<OrganizzazioneSedeLinkDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedPost(app, "/organizzazioni/{orgId:int}/sedi-link", "OrganizzazioniSediLinkCreate", async (
                int orgId,
                LinkRequest request,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new LinkCommand(orgId, request, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var (result, item) = await Handler.LinkAsync(command, connectionFactory, cancellationToken);
                return result switch
                {
                    Handler.LinkResult.NotFoundOrganizzazione => Results.NotFound(),
                    Handler.LinkResult.InvalidTipoOrganizzazioneSede => Results.Conflict("TipoOrganizzazioneSede non valido."),
                    Handler.LinkResult.Created when item is not null => Results.Created($"/{ApiVersioning.DefaultVersion}/organizzazioni/{orgId}/sedi-link/{item.OrganizzazioneSedeId}", item),
                    _ => Results.Problem("Operazione non riuscita.")
                };
            },
            builder => builder
                .Produces<OrganizzazioneSedeLinkDto>(StatusCodes.Status201Created)
                .Produces(StatusCodes.Status404NotFound)
                .Produces(StatusCodes.Status409Conflict)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedDelete(app, "/organizzazioni/{orgId:int}/sedi-link/{organizzazioneSedeId:int}", "OrganizzazioniSediLinkDelete", async (
                int orgId,
                int organizzazioneSedeId,
                [FromHeader(Name = "X-Actor")] string? actor,
                IDbConnectionFactory connectionFactory,
                CancellationToken cancellationToken) =>
            {
                var command = new UnlinkCommand(orgId, organizzazioneSedeId, actor);
                var errors = Validator.Validate(command);
                if (errors is not null)
                {
                    return Results.ValidationProblem(errors);
                }

                var result = await Handler.UnlinkAsync(command, connectionFactory, cancellationToken);
                return result == Handler.UnlinkResult.NotFound ? Results.NotFound() : Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesValidationProblem());
    }
}

