using Accredia.SIGAD.Identity.Api;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Health;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
    {
        Endpoints.Map(app);
    }
}
