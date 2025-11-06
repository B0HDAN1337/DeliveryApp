using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;

namespace Server.Repository
{
    public interface IRouteRepository
    {
        Task<IEnumerable<RouteMarkers>> GetAllAsync();
    }
}