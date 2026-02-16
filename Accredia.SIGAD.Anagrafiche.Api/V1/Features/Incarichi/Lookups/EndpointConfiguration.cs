namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.Lookups;

internal sealed class EndpointConfiguration : IEndpointConfiguration
{
    public void MapEndpoints(IEndpointRouteBuilder app)
        => Endpoints.Map(app);
}

