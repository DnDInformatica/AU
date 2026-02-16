namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}

