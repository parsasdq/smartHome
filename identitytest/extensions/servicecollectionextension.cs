using identitytest.interfaces;
using identitytest.Services;

namespace identitytest.extensions
{
    public static class servicecollectionextension
    {
        public static IServiceCollection addAppServices(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddScoped<IJWTservice, JwtService>();
            services.AddScoped<IRefreshTokenService, RefreshTokenService>();
            return services;
        }
    }
}
