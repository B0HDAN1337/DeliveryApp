using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.models;

namespace Server.Repository
{
    public class OrderRepository : IOrderRepository
    {
        private readonly DeliveryDbContext _context;
        public OrderRepository(DeliveryDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<Order>> GetAllAsync()
        {
            return await _context.Orders.ToListAsync();
        }
        public async Task<Order?> GetByIdAsync(int id)
        {
            return await _context.Orders.FindAsync(id);
        }
        public async Task<Order> CreateAsync(Order order)
        {
            var orderExisting = await _context.Orders.FirstOrDefaultAsync(o => o.OrderNumber == order.OrderNumber);
            
            if (orderExisting != null)
            {
                throw new InvalidOperationException("this order already exist");
            }

            await _context.Orders.AddAsync(order);
            await _context.SaveChangesAsync();

            return orderExisting;
        }
        public async Task<Order> UpdateAsync(int id, Order order)
        {
            var existOrder = await _context.Orders.FindAsync(id);

            existOrder.OrderNumber = order.OrderNumber;
            existOrder.DeliveryStatus = order.DeliveryStatus;
            existOrder.OrderNumber = order.OrderNumber;
            existOrder.CreatedAt = order.CreatedAt;
            existOrder.DeliveredAt = order.DeliveredAt;

            await _context.SaveChangesAsync();

            return existOrder;
        }
    }
}