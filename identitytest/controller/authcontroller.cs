using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using identitytest.entity;
using identitytest.DTOs;
using identitytest.data;
using identitytest.interfaces;
using identitytest.Services;
using Microsoft.AspNetCore.Authorization;

namespace identitytest.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly UserManager<User> _userManager;
    private readonly IJWTservice _jwtService;
    private readonly IRefreshTokenService _refreshTokenService;
    private readonly AppDbContext _context;
    public AuthController(UserManager<User> userManager,IJWTservice jWTservice, AppDbContext context)
    {
        _userManager = userManager;
        _jwtService = jWTservice;
        _context = context;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(registerDTO dto)
    {
        var existingUser = await _userManager.FindByEmailAsync(dto.email);

        if (existingUser != null)
        {
            return BadRequest(new
            {
                message = "This email is already registered."
            });
        }

        var user = new User
        {
            Email = dto.email,
            UserName = dto.userName,
            FirstName = dto.name
        };

        var result = await _userManager.CreateAsync(user, dto.password);

        if (!result.Succeeded)
        {
            return BadRequest(result.Errors);
        }
        string refToken = _jwtService.GenerateRefToken();
        string token = _jwtService.GenerateToken(user);

        return Ok(new
        {
            message = "User registered successfully.",
            token = token,
            reftoken = refToken,
            user = new
            {
                id = user.Id,
                userName = user.UserName,
                email = user.Email
            }
        });
      
    }
    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginDTO dto)
    {
        User? user;

        // اول بررسی می‌کنیم ورودی ایمیل است یا نام کاربری
        if (dto.email.Contains('@'))
        {
            user = await _userManager.FindByEmailAsync(dto.email);
        }
        else
        {
            user = await _userManager.FindByNameAsync(dto.email);
        }

        // اگر کاربر پیدا نشد
        if (user == null)
        {
            return Unauthorized(new
            {
                message = "Invalid username/email or password."
            });
        }

        // بررسی رمز عبور
        bool isPasswordValid = await _userManager.CheckPasswordAsync(
            user,
            dto.password
        );

        if (!isPasswordValid)
        {
            return Unauthorized(new
            {
                message = "Invalid username/email or password."
            });
        }

        // تولید JWT
        string token = _jwtService.GenerateToken(user);
        string refToken = _jwtService.GenerateRefToken();
        return Ok(new
        {
            message = "Login successful.",
            reftoken = refToken,
            token = token,
            user = new
            {
                id = user.Id,
                userName = user.UserName,
                email = user.Email
            }
        });
    }
    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh(
    [FromBody] RefreshTokenRequestDTO request)
    {
        var newRefreshToken = _jwtService.GenerateRefToken();

        var user = await _refreshTokenService.RotateRefreshTokenAsync(
            request.RefreshToken,
            newRefreshToken);
        

        if (user is null)
        {
            return Unauthorized(new
            {
                message = "Refresh token is invalid or expired."
            });
        }

        var newAccessToken = _jwtService.GenerateToken(user);

        return Ok(new
        {
            accessToken = newAccessToken,
            refreshToken = newRefreshToken
        });
    }
    [Authorize]
    [HttpGet("test")]
    public IActionResult TestAccessToken()
    {
        return Ok(new
        {
            message = "Access token is valid.",
            isAuthenticated = User.Identity?.IsAuthenticated
        });
    }
}
