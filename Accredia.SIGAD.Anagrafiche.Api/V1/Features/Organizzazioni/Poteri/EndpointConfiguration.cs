using Accredia.SIGAD.Anagrafiche.Api;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Poteri;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}
