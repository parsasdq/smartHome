using System.ComponentModel.DataAnnotations;

namespace identitytest.DTOs;

public class LoginDTO
{
    [Required]
    public string email { get; set; } = string.Empty;

    [Required]
    public string password { get; set; } = string.Empty;
}