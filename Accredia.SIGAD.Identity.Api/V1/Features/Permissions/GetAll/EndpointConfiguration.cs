namespace Accredia.SIGAD.Identity.Api.V1.Features.Permissions.GetAll;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
    {
        Endpoints.Map(app);
    }
}
