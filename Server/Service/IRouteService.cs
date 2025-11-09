using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Server.models;
using Server.ViewModel;

namespace Server.Service
{
    public interface IRouteService
    {
        Task<IEnumerable<RouteMarkers>> GetRouteAllAsync();
        Task CreateAsync(IEnumerable<RouteMarkerViewModel> viewModel);
        Task<IEnumerable<RouteMarkers>> GetByIdAsync(int id);   
    }
}