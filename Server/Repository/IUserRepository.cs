using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;

namespace Server.Repository
{
    public interface IUserRepository
    {
        Task<IEnumerable<User>> GetAllAsync();
        Task<User> GetByIdAsync(int id);
        Task<User> CreateAsync(User user);
        Task<User> UpdateAsync(int id, User user);
        Task<User> DeleteAsync(int id);
        Task<User> LoginAsync(string email);
    }
}