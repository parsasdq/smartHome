using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using identitytest.entity;
namespace identitytest.data;

public class AppDbContext
    : IdentityDbContext<User, IdentityRole<Guid>, Guid>
{
    public AppDbContext(
        DbContextOptions<AppDbContext> options)
        : base(options)
    {

    }
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
}
