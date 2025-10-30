import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final List<LatLng> routePoints;
  final List<Marker> markers;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.routePoints,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    final polyline = Polyline(
      points: routePoints,
      strokeWidth: 4.0,
      color: Colors.blue,
    );

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(49.0, 19.0),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        if (routePoints.isNotEmpty) PolylineLayer(polylines: [polyline]),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
