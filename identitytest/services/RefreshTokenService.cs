
using System.Security.Cryptography;
using System.Text;
using identitytest.data;
using identitytest.entity;
using identitytest.interfaces;
using Microsoft.EntityFrameworkCore;

namespace identitytest.Services;

public class RefreshTokenService : IRefreshTokenService
{
    private readonly AppDbContext _context;

    public RefreshTokenService(AppDbContext context)
    {
        _context = context;
    }

    public async Task SaveRefreshTokenAsync(
        User user,
        string refreshToken)
    {
        var tokenHash = Convert.ToHexString(
            SHA256.HashData(
                Encoding.UTF8.GetBytes(refreshToken)
            )
        );

        var token = new RefreshToken
        {
            UserId = user.Id,
            TokenHash = tokenHash,
            ExpiresAt = DateTime.UtcNow.AddDays(7)
        };

        _context.RefreshTokens.Add(token);
        await _context.SaveChangesAsync();
    }
    public async Task<bool> IsRefreshTokenValidAsync(
        string refreshToken)
    {
        if (string.IsNullOrWhiteSpace(refreshToken))
            return false;

        var tokenHash = Convert.ToHexString(
            SHA256.HashData(
                Encoding.UTF8.GetBytes(refreshToken)
            )
        );

        var token = await _context.RefreshTokens
            .FirstOrDefaultAsync(t => t.TokenHash == tokenHash);

        if (token is null)
            return false;

        if (token.ExpiresAt <= DateTime.UtcNow)
            return false;

        if (token.RevokedAt is not null)
            return false;

        return true;
    }
    public async Task<User?> RotateRefreshTokenAsync(
     string currentRefreshToken,
     string newRefreshToken)
    {
        if (string.IsNullOrWhiteSpace(currentRefreshToken) ||
            string.IsNullOrWhiteSpace(newRefreshToken))
        {
            return null;
        }

        var now = DateTime.UtcNow;

        var currentHash = Convert.ToHexString(
            SHA256.HashData(
                Encoding.UTF8.GetBytes(currentRefreshToken)));

        var token = await _context.RefreshTokens
            .Include(t => t.User)
            .FirstOrDefaultAsync(t => t.TokenHash == currentHash);

        if (token is null ||
            token.ExpiresAt <= now ||
            token.RevokedAt is not null ||
            token.User is null)
        {
            return null;
        }

        // Revoke old refresh token
        token.RevokedAt = now;

        // Hash new refresh token
        var newTokenHash = Convert.ToHexString(
            SHA256.HashData(
                Encoding.UTF8.GetBytes(newRefreshToken)));

        // Save new refresh token
        var newToken = new RefreshToken
        {
            UserId = token.UserId,
            TokenHash = newTokenHash,
            CreatedAt = now,
            ExpiresAt = now.AddDays(7)
        };

        _context.RefreshTokens.Add(newToken);

        await _context.SaveChangesAsync();

        return token.User;
    }
}

