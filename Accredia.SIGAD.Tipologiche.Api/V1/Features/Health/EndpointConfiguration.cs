using Accredia.SIGAD.Tipologiche.Api;

namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Health;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
    {
        Endpoints.Map(app);
    }
}
