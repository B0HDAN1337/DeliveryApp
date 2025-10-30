import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/point.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  final String baseUrl = 'http://127.0.0.1:3000';

  Future<List<Point>> fetchPoints() async {
    final res = await http.get(Uri.parse('$baseUrl/points'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Point.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load points');
    }
  }

  Future<List<LatLng>> fetchRoute(List<Point> points) async {
    final body = jsonEncode({
      'waypoints': points.map((p) => p.toJson()).toList(),
    });

    final res = await http.post(
      Uri.parse('$baseUrl/route'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final coords = data['geometry']['coordinates'] as List;
      return coords.map((c) => LatLng(c[1], c[0])).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}
