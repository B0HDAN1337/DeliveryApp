using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Server.Service;
using Server.ViewModel;

namespace Server.Controller
{
    [ApiController]
    [Route("api/[controller]")]
    public class RouteController : ControllerBase
    {
        private readonly IRouteService _service;
        public RouteController(IRouteService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var routes = await _service.GetRouteAllAsync();
            return Ok(routes);
        }

        [HttpPost]
        public async Task<IActionResult> Create(IEnumerable<RouteMarkerViewModel> viewModel)
        {
            await _service.CreateAsync(viewModel);
            return Ok();
        }

        [HttpGet("courierId/{courierId}")]
        public async Task<IActionResult> GetByCourierId(int courierId)
        {
            var routes = await _service.GetByIdAsync(courierId);
            return Ok(routes);
        }
    }
}