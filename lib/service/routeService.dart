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
}
