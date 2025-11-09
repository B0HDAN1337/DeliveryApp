using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.ViewModel
{
    public class OrderViewModel
    {
        public int ClientId { get; set; }
        public string PickupLocation { get; set; }
        public string DropoffLocation { get; set; }
    }
}