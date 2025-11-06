using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;
using Server.Repository;

namespace Server.Service
{
    public class RouteService : IRouteService
    {
        private readonly IRouteRepository _repository;

        public RouteService(IRouteRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<RouteMarkers>> GetRouteAllAsync()
        {
            var routes = _repository.GetAllAsync();

            return await routes;
        }
    }
}