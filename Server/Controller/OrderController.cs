using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Server.models;
using Server.Service;
using Server.ViewModel;

namespace Server.Controller
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrderController : ControllerBase
    {
        private readonly IOrderService _service;
        public OrderController(IOrderService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var orders = await _service.GetAllOrderAsync();
            return Ok(orders);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var order = await _service.GetOrderAsync(id);
            if (order == null)
            {
                return NotFound();
            }

            return Ok(order);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] OrderViewModel order)
        {
            try
            {
                await _service.CreateOrderAsync(order);
                return Ok();
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest("Order already exist");
            }
        }

        [HttpPost("{id}/signature")]
        public async Task<IActionResult> UploadSignature(int id, IFormFile signature)
        {
            if (signature == null || signature.Length == 0)
            {
                return BadRequest("Signature file is required.");
            }

            var success = await _service.UploadOrderSignatureAsync(id, signature);
            if (success == null)
            {
                return NotFound();
            }

            return Ok(new { message = "Signature uploaded successfully" });
        }

        [HttpPost("{id}/assign")]
        public async Task<IActionResult> AssignCourier(int id, int courierId)
        {
            var success = await _service.AssignCourierAsync(id, courierId);
            if (success == null)
            {
                return NotFound();
            }

            return Ok(new { message = "Courier assigned" });
        }
        [HttpGet("courier/{courierId}")]
        public async Task<IActionResult> GetCourierOrders(int courierId)
        {
            var orders = await _service.GetCourierOrdersAsync(courierId);
            return Ok(orders);
        }
    }
}