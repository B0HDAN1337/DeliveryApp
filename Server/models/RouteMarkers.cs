using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.models
{
    public class RouteMarkers
    {
        public int id { get; set; }
        public int OrderId { get; set; }
        public Order Order { get; set; } = null!;
        public int CourierId { get; set; }
        public User Courier { get; set; } = null!;
        public string? DeliveryStatus { get; set; }
        public double lat { get; set; }
        public double lon { get; set; }
        public int Sequence { get; set; }
    }
}