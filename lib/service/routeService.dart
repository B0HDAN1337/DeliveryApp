import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/point.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  final String baseUrl = 'http://0.0.0.0:8080';

  Future<List<Point>> fetchPoints() async {
    final res = await http.get(Uri.parse('$baseUrl/api/Route'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Point.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load points');
    }
  }
}
