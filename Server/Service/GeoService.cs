using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.Json;
using System.Threading.Tasks;
using Server.models;

namespace Server.Service
{
    public class GeoService : IGeoService
    {
        private readonly HttpClient _httpClient;

        public GeoService(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<GeoCoordinates> GeocodeAsync(string address)
        {
            if (string.IsNullOrWhiteSpace(address))
            {
                throw new ArgumentException("Address cannot be empty", nameof(address));
            }

            var url = $"https://nominatim.openstreetmap.org/search?q={Uri.EscapeDataString(address)}&format=json&limit=1";

            var request = new HttpRequestMessage(HttpMethod.Get, url);
            request.Headers.Add("User-Agent", "DeliveryApp/1.0 (contact@example.com)");
            request.Headers.Add("Accept", "application/json");

            var response = await _httpClient.SendAsync(request);
            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine(response);
                throw new Exception($"Failed to geocode address: {address}");
            }
                
            var json = await response.Content.ReadAsStringAsync();
            var data = JsonSerializer.Deserialize<GeoResponse[]>(json);

            if (data == null || data.Length == 0)
            {
                throw new Exception($"Address not found: {address}");
            }

            return new GeoCoordinates
            {
                Lat = double.Parse(data[0].lat),
                Lon = double.Parse(data[0].lon)
            };
        }
        private class GeoResponse
        {
            public string lat { get; set; } = string.Empty;
            public string lon { get; set; } = string.Empty;
        }
    }
}