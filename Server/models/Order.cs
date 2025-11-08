using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.models
{
    public class Order
    {
        public int Id { get; set; }
        public string OrderNumber { get; set; } = string.Empty;
        public string DeliveryStatus { get; set; } = "pending";
        public string? SignaturePath { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? DeliveredAt { get; set; } = null;
    }
}