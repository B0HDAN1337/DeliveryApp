using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;

namespace Server.Repository
{
    public interface IOrderRepository
    {
        Task<IEnumerable<Order>> GetAllAsync();
        Task<Order?> GetByIdAsync(int id);
        Task<Order> CreateAsync(Order order);
        Task<Order> UpdateAsync(int id, Order order);
    }
}