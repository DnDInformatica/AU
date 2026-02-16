namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
    {
        Endpoints.Map(app);
    }
}
