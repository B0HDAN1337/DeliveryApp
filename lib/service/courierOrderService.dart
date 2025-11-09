import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class CourierOrderService {
  final String baseUrl = 'http://0.0.0.0:8080/api/Order';

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    final decode = JwtDecoder.decode(token!);
    print(decode.keys);  
    print(decode.values);
    final id = decode["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    if (id == null) {
      print("Role not found in token!");
    }

    return id;
  }

  Future<List<Order>> fetchMyOrders() async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    final courierId = await _getUserId();
    final response = await http.get(
      Uri.parse('$baseUrl/courier/$courierId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch orders');
    }
  }

  Future<void> acceptOrder(int orderId) async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    final courierId = await _getUserId();
    final response = await http.post(
      Uri.parse('$baseUrl/$orderId/assign?courierId=$courierId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to accept order');
    }
  }

  Future<void> updateStatus(int orderId, String status) async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('$baseUrl/$orderId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status');
    }
  }
}
