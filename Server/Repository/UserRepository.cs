using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;

namespace Server.Repository
{
    public class UserRepository : IUserRepository
    {
        public Task<IEnumerable<User>> GetAllAsync()
        {
            throw new NotImplementedException();
        }
        public Task<User> CreateAsync(User user)
        {
            throw new NotImplementedException();
        }
        public Task<User> UpdateAsync(int id, User user)
        {
            throw new NotImplementedException();
        }
        public Task<User> DeleteAsync(int id)
        {
            throw new NotImplementedException();
        }
        public Task<User> LoginAsync(string email)
        {
            throw new NotImplementedException();
        } 
    }
}