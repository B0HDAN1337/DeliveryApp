import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String baseUrl = 'http://0.0.0.0:8080/api/User';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final decode = JwtDecoder.decode(token!);
    print(decode.keys);  
    print(decode.values);
    final role = decode["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
    if (role == null) {
      print("Role not found in token!");
    }

    return role;
  }
}
