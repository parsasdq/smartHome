using identitytest.entity;

namespace identitytest.interfaces
{
 
    

    public interface IJWTservice
    {
       
        string GenerateRefToken();
        string GenerateToken(User user);
    }
}
