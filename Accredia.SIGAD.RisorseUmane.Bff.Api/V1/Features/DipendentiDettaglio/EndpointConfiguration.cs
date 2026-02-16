using Accredia.SIGAD.RisorseUmane.Bff.Api;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.V1.Features.DipendentiDettaglio;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}

