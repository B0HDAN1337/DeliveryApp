import 'dart:convert';
import 'package:delivery_app/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserOrderService {
  final String baseUrl = 'http://0.0.0.0:8080/api/Order';

  Future<List<Order>> getMyOrders() async {
    final prefs = await SharedPreferences.getInstance(); 
      final token = prefs.getString('token');
      final decode = JwtDecoder.decode(token!);
      final id = decode["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];

    final response = await http.get(
      Uri.parse('$baseUrl/client/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Order.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> createOrder(String pickup, String dropoff) async {
      final prefs = await SharedPreferences.getInstance(); 
      final token = prefs.getString('token');
      final decode = JwtDecoder.decode(token!);
      final id = decode["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'clientId': id,
        'pickupLocation': pickup,
        'dropoffLocation': dropoff,
        'deliveryStatus': "pending",
        'createdAt': DateTime.now().toIso8601String()
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create order');
    }
  }

  Future<void> cancelOrder(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$orderId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel order');
    }
  }
}
