namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.SetRoles;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
    {
        Endpoints.Map(app);
    }
}

