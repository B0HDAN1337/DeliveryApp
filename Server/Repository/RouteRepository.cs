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
        public async Task Create(IEnumerable<RouteMarkers> marker)
        {
            await _context.RouteMarker.AddRangeAsync(marker);
            await _context.SaveChangesAsync();
        }
        public async Task<IEnumerable<RouteMarkers>> GetById(int id)
        {
            return await _context.RouteMarker.Where(r => r.CourierId == id && r.DeliveryStatus != "delivered").ToListAsync();
        }   
    }
}