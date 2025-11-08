using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Server.models;

namespace Server.Data
{
    public class DbInitializer
    {
        public static void Initializer(DeliveryDbContext context)
        {
            context.Database.EnsureCreated();

            if (context.Users.Any() || context.RouteMarker.Any())
            {
                return;
            }

            var users = new List<User>
            {
                new User { Email = "test@test.com", Password = BCrypt.Net.BCrypt.HashPassword("string"), Role = "Courier" },
            };

            // var markers = new List<RouteMarkers>
            // {
            //     new RouteMarkers {name = "UBB", lat = 49.78559, lon = 19.057272 },
            //     new RouteMarkers {name = "Hotel Prezydent", lat = 49.823603, lon = 19.044912 },
            //     new RouteMarkers {name = "Akademik", lat = 49.81694, lon = 19.01467 },

            // };

            context.Users.AddRange(users);
            //context.RouteMarker.AddRange(markers);
            context.SaveChanges();
        }
    }
}