using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.ViewModel
{
    public class RouteMarkerViewModel
    {
        public int OrderId { get; set; }
        public int CourierId { get; set; }
        public double lat { get; set; }
        public double lon { get; set; }
        public int Sequence { get; set; }
    }
}