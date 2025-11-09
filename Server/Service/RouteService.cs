using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;
using Server.Repository;
using Server.ViewModel;

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
        public async Task CreateAsync(IEnumerable<RouteMarkerViewModel> viewModel)
        {
            var routes = viewModel.Select(vm => new RouteMarkers
            {
                OrderId = vm.OrderId,
                CourierId = vm.CourierId,
                lat = vm.lat,
                lon = vm.lon,
                Sequence = vm.Sequence
            }).ToList();

            await _repository.Create(routes);
        }
        public async Task<IEnumerable<RouteMarkers>> GetByIdAsync(int id)
        {
            return await _repository.GetById(id);
        }
        public async Task<IEnumerable<RouteMarkers>> UpdateByOrderId(int id, string status)
        {
            return await _repository.UpdateByOrderId(id, status);
        }
    }
}