using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Server.Service;
using Server.ViewModel;

namespace Server.Controller
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly IUserService _service;
        public UserController(IUserService service)
        {
            _service = service;
        }

        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var users = await _service.GetUserAllAsync();
            return Ok(users);
        }

        [HttpPost("Register")]
        public async Task<IActionResult> Create([FromBody] UserViewModel userViewModel)
        {
            try
            {
                await _service.CreateUserAsync(userViewModel);
                return Ok();
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest("User with this username or email is already exist");
            }
        }

        [Authorize]
        [HttpPut("Update/{id}")]
        public async Task<IActionResult> Update(int id, UserViewModel userViewModel)
        {
            await _service.UpdateUserAsync(id, userViewModel);
            return Ok();
        }

        [Authorize]
        [HttpDelete("Delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _service.DeleteUserAsync(id);
            return Ok();
        }
        
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserViewModel request)
        {
            var token = await _service.LoginUserAsync(request.Email, request.Password);
            if (token == null)
            {
                return Unauthorized();
            }

            return Ok(new { token });
        }
    }
}