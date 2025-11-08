using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;
using Server.ViewModel;

namespace Server.Service
{
    public interface IOrderService
    {
        Task<IEnumerable<Order>> GetAllOrderAsync();
        Task<Order> GetOrderAsync(int id);
        Task<Order> CreateOrderAsync(OrderViewModel order);
        Task<bool> UploadOrderSignatureAsync(int orderId,  IFormFile signatureFile);
    }
}