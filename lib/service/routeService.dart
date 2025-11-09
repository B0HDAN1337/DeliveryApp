import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/point.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  final String baseUrl = 'http://0.0.0.0:8080';

  Future<List<Point>> fetchPoints() async {
    final prefs = await SharedPreferences.getInstance(); 
    final token = prefs.getString('token');
    final decode = JwtDecoder.decode(token!);
    final courierId = decode["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    
    final res = await http.get(Uri.parse('$baseUrl/api/Route/$courierId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Point.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load points');
    }
  }
}
