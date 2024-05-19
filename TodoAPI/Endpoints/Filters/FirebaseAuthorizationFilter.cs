using FirebaseAdmin.Auth;
using Microsoft.Extensions.Primitives;

namespace TodoAPI.Endpoints.Filters;

public class FirebaseAuthorizationFilter : IEndpointFilter
{
    private const string FIREBASE_UID_REQUEST_ITEM_KEY = "FirebaseUid";
    
    public async ValueTask<object?> InvokeAsync(EndpointFilterInvocationContext context, EndpointFilterDelegate next)
    {
        string? headerToken = ExtractRequestToken(context.HttpContext);
        FirebaseToken? idToken = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(headerToken);

        if (idToken is null)
            return Results.Unauthorized();

        context.HttpContext.Items.Add(FIREBASE_UID_REQUEST_ITEM_KEY, idToken.Uid);
        
        return await next(context);
    }
    
    public static string? GetFirebaseUid(HttpContext context)
    {
        return context.Items[FIREBASE_UID_REQUEST_ITEM_KEY] as string;
    }

    private static string? ExtractRequestToken(HttpContext context)
    {
        bool hasToken = context.Request.Headers
            .TryGetValue(HeadersKeys.FIREBASE_AUTH_HEADER_KEY, out StringValues tokens);
        
        string? headerToken = hasToken ? tokens.FirstOrDefault() : null;

        return headerToken;
    }
}