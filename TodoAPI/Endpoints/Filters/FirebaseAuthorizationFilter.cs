using FirebaseAdmin.Auth;
using Microsoft.Extensions.Primitives;

namespace TodoAPI.Endpoints.Filters;

public class FirebaseAuthorizationFilter : IEndpointFilter
{
    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        string? headerToken = ExtractRequestToken(context.HttpContext);
        FirebaseToken? idToken = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(headerToken);

        if (idToken is null)
            return Results.Unauthorized();

        return await next(context);
    }

    public static string? ExtractRequestToken(HttpContext context)
    {
        bool hasToken = context.Request.Headers
            .TryGetValue(HeadersKeys.FIREBASE_AUTH_HEADER_KEY, out StringValues tokens);
        
        string? headerToken = hasToken ? tokens.FirstOrDefault() : null;

        return headerToken;
    }
}