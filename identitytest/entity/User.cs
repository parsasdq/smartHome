using Microsoft.AspNetCore.Identity;

namespace identitytest.entity
{
   
    public class User : IdentityUser<Guid>
    {
        public string? FirstName { get; set; }

        public string? LastName { get; set; }

        public DateTime? CreatedAt { get; set; }
    }
}
