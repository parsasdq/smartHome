using identitytest.entity;

namespace identitytest.interfaces;

public interface IRefreshTokenService
{
    Task SaveRefreshTokenAsync(User user, string refreshToken);
    Task<bool> IsRefreshTokenValidAsync(string refreshToken);
    Task<User?> RotateRefreshTokenAsync(
    string currentRefreshToken,
    string newRefreshToken);
}

