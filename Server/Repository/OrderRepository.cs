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
        public async Task CreateAsync(Order order)
        {
            await _context.Orders.AddAsync(order);
            await _context.SaveChangesAsync();
        }
        public async Task<Order> UpdateAsync(int id, Order order)
        {
            var existOrder = await _context.Orders.FindAsync(id);

            existOrder.ClientId = order.ClientId;
            existOrder.CourierId = order.CourierId;
            existOrder.PickupLocation = order.PickupLocation;
            existOrder.DropoffLocation = order.DropoffLocation;
            existOrder.DeliveryStatus = order.DeliveryStatus;
            existOrder.CreatedAt = order.CreatedAt;
            existOrder.DeliveredAt = order.DeliveredAt;
            existOrder.SignaturePath = order.SignaturePath;

            await _context.SaveChangesAsync();

            return existOrder;
        }
    }
}