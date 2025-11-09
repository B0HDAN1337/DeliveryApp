using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.models
{
    public class Order
    {
        public int Id { get; set; }
        public string? PickupLocation { get; set; } = null!;
        public string? DropoffLocation { get; set; } = null!;
        public double PickupLat { get; set; }
        public double PickupLon { get; set; }
        public double DropoffLat { get; set; }
        public double DropoffLon { get; set; }
        public string? DeliveryStatus { get; set; } = "pending";
        public string? SignaturePath { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public DateTime? DeliveredAt { get; set; } = null;

        public User? Client { get; set; }
         public int ClientId { get; set; }
        public User? Courier { get; set; }
        public int? CourierId { get; set; } 

        public ICollection<RouteMarkers>? RoutePoints { get; set; }
    }
}