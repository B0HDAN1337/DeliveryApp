using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Server.models;

namespace Server.Data
{
    public class DeliveryDbContext : DbContext
    {
        public DeliveryDbContext(DbContextOptions<DeliveryDbContext> options) : base(options) { }
        
        public DbSet<User> Users { get; set; }
        public DbSet<RouteMarkers> RouteMarker { get; set; }
        public DbSet<Order> Orders { get; set; }


    }
}