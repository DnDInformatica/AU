using Accredia.SIGAD.RisorseUmane.Api;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Reports;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}
