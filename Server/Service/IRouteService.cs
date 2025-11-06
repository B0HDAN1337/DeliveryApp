using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;

namespace Server.Service
{
    public interface IRouteService
    {
        Task<IEnumerable<RouteMarkers>> GetRouteAllAsync();
    }
}