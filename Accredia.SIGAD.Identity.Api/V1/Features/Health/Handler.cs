namespace Accredia.SIGAD.Identity.Api.V1.Features.Health;

internal static class Handler
{
    public static IResult Handle(Command command)
    {
        return Results.Ok(new HealthResponse("ok"));
    }
}
