import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/point.dart';

class MarkerWidget {
  static List<Marker> buildMarkers(List<Point> points) {

    return List.generate(points.length, (index) {
      final point = points[index];

      IconData icon;
      Color color;

     if (index == 0) {
        // Car
        icon = Icons.car_rental_rounded;
        color = point.visited ? Colors.grey : Colors.blue;
      } else if (index == 1) {
        // Collect pack
        icon = Icons.local_shipping;
        color = point.visited ? Colors.grey : Colors.orange;
      } else if (index == 2) {
        // Delivery pack
        icon = Icons.flag;
        color = point.visited ? Colors.grey : Colors.green;
      } else {
        icon = Icons.location_on;
        color = point.visited ? Colors.grey : Colors.red;
      }
      return Marker(
        point: LatLng(point.lat, point.lon),
        width: 50,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 36),
          ],
        ),
      );
    });
  }
}
