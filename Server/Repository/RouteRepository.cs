using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Server.Data;
using Server.models;

namespace Server.Repository
{
    public class RouteRepository : IRouteRepository
    {
        private readonly DeliveryDbContext _context;

        public RouteRepository(DeliveryDbContext context)
        {
            _context = context;
        }
        public async Task<IEnumerable<RouteMarkers>> GetAllAsync()
        {
            return await _context.RouteMarker.ToListAsync();
        }
    }
}