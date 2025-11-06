import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final List<LatLng> routePoints;
  final List<Marker> markers;
  final LatLng? currentLocation;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.routePoints,
    required this.markers,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    final polyline = Polyline(
      points: routePoints,
      strokeWidth: 4.0,
      color: Colors.blue,
    );

    final currentMarker = currentLocation != null
        ? Marker(
            point: currentLocation!,
            width: 60,
            height: 60,
            child: const Icon(
              Icons.my_location,
              color: Colors.blueAccent,
              size: 32,
            ),
          )
        : null;

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(49.78559, 19.057272),
        initialZoom: 15.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        if (routePoints.isNotEmpty) PolylineLayer(polylines: [polyline]),
        MarkerLayer(markers: markers),

        if (currentMarker != null) MarkerLayer(markers: [currentMarker])
      ],
    );
  }
}
