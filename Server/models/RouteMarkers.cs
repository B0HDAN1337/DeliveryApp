using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Server.models
{
    public class RouteMarkers
    {
        public int id { get; set; }
        public string name { get; set; }
        public double lat { get; set; }
        public double lon { get; set; }
    }
}