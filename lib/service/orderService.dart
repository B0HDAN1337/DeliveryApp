import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://0.0.0.0:8080/api/Order';

  Future<List<Order>> fetchAvailableOrders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  final response = await http.get(
    Uri.parse('$baseUrl'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    final available = data.where((e) => e['courierId'] == null).toList();
    return available.map((e) => Order.fromJson(e)).toList();
  } else {
    throw Exception('Failed to fetch orders');
  }
}

Future<String?> getUserId() async {
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


  Future<bool> acceptOrder(int orderId, int courierId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/$orderId/assign?courierId=$courierId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }
}
