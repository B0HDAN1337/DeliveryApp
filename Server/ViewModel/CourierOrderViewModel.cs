using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.ViewModel
{
    public class CourierOrderViewModel
    {
        public string? PickupLocation { get; set; }
        public string? DropoffLocation { get; set; }
        public string? DeliveryStatus { get; set; }
        public string? SignaturePath { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? DeliveredAt { get; set; }
         public int ClientId { get; set; }
        public int? CourierId { get; set; } 
    }
}