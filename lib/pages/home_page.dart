import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/point.dart';
import '../service/routeService.dart';
import '../widgets/marker_widget.dart';
import '../widgets/map_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final mapController = MapController();
  final api = RouteService();

  List<Point> points = [];
  List<LatLng> routePoints = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedPoints = await api.fetchPoints();
      setState(() => points = fetchedPoints);
      await _fetchRoute();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchRoute() async {
    if (points.length < 2) return;

    setState(() => loading = true);
    try {
      final fetchedRoute = await api.fetchRoute(points);
      setState(() => routePoints = fetchedRoute);
      if (routePoints.isNotEmpty) {
        mapController.move(routePoints.first, 6.0);
      }
    } catch (e) {
      print('Route error: $e');
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final markers = MarkerWidget.buildMarkers(points);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: MapWidget(
        mapController: mapController,
        routePoints: routePoints,
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _fetchRoute,
        label: Text(loading ? 'Loading...' : 'Show Route'),
        icon: const Icon(Icons.alt_route),
      ),
    );
  }
}
