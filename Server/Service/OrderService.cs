using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Threading.Tasks;
using Server.models;
using Server.Repository;
using Server.ViewModel;

namespace Server.Service
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _repository;
        private readonly IWebHostEnvironment _env;
        public OrderService(IOrderRepository repository,IWebHostEnvironment env)
        {
            _repository = repository;
            _env = env;
        }
        public async Task<IEnumerable<Order>> GetAllOrderAsync()
        {
            return await _repository.GetAllAsync();
        }
        public async Task<Order> GetOrderAsync(int id)
        {
            return await _repository.GetByIdAsync(id);
        }
        public async Task<Order> CreateOrderAsync(OrderViewModel orderViewModel)
        {
            var order = new Order
            {
                OrderNumber = orderViewModel.OrderNumber,
                CreatedAt = orderViewModel.CreatedAt
            };
            return await _repository.CreateAsync(order);
        }
        public async Task<bool> UploadOrderSignatureAsync(int orderId,  IFormFile signatureFile)
        {
            var order = await _repository.GetByIdAsync(orderId);
            if (order == null) return false;

            string uploadDir = Path.Combine(_env.WebRootPath, "signatures");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            string fileName = $"signature_{orderId}.png";
            string filePath = Path.Combine(uploadDir, fileName);

            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await signatureFile.CopyToAsync(stream);
            }

            order.SignaturePath = $"signatures/{fileName}";
            order.DeliveryStatus = "delivered";
            order.DeliveredAt = DateTime.UtcNow;

            await _repository.UpdateAsync(orderId, order);

            return true;
        }
    }
}