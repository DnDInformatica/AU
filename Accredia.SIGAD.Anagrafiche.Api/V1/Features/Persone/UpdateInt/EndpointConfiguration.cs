namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.UpdateInt;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}

