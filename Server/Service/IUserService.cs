using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;
using Server.ViewModel;

namespace Server.Service
{
    public interface IUserService
    {
        Task<IEnumerable<User>> GetUserAllAsync();
        
        Task<User> CreateUserAsync(UserViewModel viewModel);
        Task<User> UpdateUserAsync(int id, UserViewModel viewModel);
        Task<User> DeleteUserAsync(int id);
        Task<string> LoginUserAsync(string email, string password);
    }
}