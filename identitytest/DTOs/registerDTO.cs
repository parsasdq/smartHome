using System.ComponentModel.DataAnnotations;

namespace identitytest.DTOs
{
    public class registerDTO
    {
        [Required]
        [EmailAddress]
        public string email { get; set; }
        [Required]
        [MinLength(6)]
        public string password { get; set; }   
        public string name { get; set; }
        [Required]
        public string userName { get; set; }
    }
}
