import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/point.dart';

class MarkerWidget {
  static List<Marker> buildMarkers(List<Point> points) {
    return points.map((p) {
      return Marker(
        width: 80,
        height: 80,
        point: LatLng(p.lat, p.lon),
        child: Column(
          children: [
            const Icon(Icons.location_pin, color: Colors.red, size: 36),
            Container(
              padding: const EdgeInsets.all(2),
              color: Colors.white,
              child: Text(p.name, style: const TextStyle(fontSize: 10)),
            ),
          ],
        ),
      );
    }).toList();
  }
}
