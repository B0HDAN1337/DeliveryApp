import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/point.dart';
import 'package:http/http.dart' as http;
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
  LatLng? currentLocation;

  StreamSubscription<Position>? _positionStream;
  DateTime? _lastRouteUpdate;

  int _currentTargetIndex = 0; 
  String deliveryStatus = 'Waiting...';


  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
   try {
      setState(() => loading = true);
      final fetchedPoints = await api.fetchPoints();
      setState(() => points = fetchedPoints);
      await _fetchRoute();
    } catch (e) {
      print('Error loading points: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _fetchRoute() async {
  if (points.isEmpty || currentLocation == null) {
    print('No points or current location yet');
    return;
  }

  setState(() => loading = true);

  try {
    final activePoints = points.where((p) => !p.visited).toList();

    if (activePoints.isEmpty) {
      print('All points visited');
      setState(() {
        routePoints.clear();
        loading = false;
      });
      return;
    }

    final coords = [
      '${currentLocation!.longitude},${currentLocation!.latitude}',
      ...activePoints.map((p) => '${p.lon},${p.lat}')
    ].join(';');

    final url =
        'https://router.project-osrm.org/route/v1/driving/$coords?overview=full&geometries=geojson';

    print('Fetching route: $url');

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    if (data['routes'] == null || data['routes'].isEmpty) {
      throw Exception('No route found');
    }

    final coordsList = data['routes'][0]['geometry']['coordinates'] as List;

    setState(() {
      routePoints = coordsList.map((c) => LatLng(c[1], c[0])).toList();
    });

    if (routePoints.isNotEmpty) {
      mapController.move(routePoints.first, 13.0);
    }
  } catch (e) {
    print('Route error: $e');
  }

  setState(() => loading = false);
}

Future<void> _startLocationTracking() async {
  try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('GPS unavailable');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission refused');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission always refused');
      }

      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((pos) {
        setState(() {
          currentLocation = LatLng(pos.latitude, pos.longitude);
        });


        _checkProximity();
        _maybeUpdateRoute();
      });
    } catch (e) {
      print('Location tracking error: $e');
    }
}

void _maybeUpdateRoute() {
    final now = DateTime.now();
    if (_lastRouteUpdate == null ||
        now.difference(_lastRouteUpdate!).inSeconds > 5) {
      _lastRouteUpdate = now;
      _fetchRoute();
    }
  }

  void _checkProximity() async {
  if (currentLocation == null || points.isEmpty) return;

  final targetPoint = points[_currentTargetIndex];

  final distance = Geolocator.distanceBetween(
    currentLocation!.latitude,
    currentLocation!.longitude,
    targetPoint.lat,
    targetPoint.lon,
  );

  if (distance < 30) {
    if (_currentTargetIndex == 0) {
      setState(() {
        deliveryStatus = 'Taked car';
        points[_currentTargetIndex].visited = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(deliveryStatus)),
      );
    } else if (_currentTargetIndex == 1) {
      setState(() {
        deliveryStatus = 'Delivery pack collected';
        points[_currentTargetIndex].visited = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(deliveryStatus)));
    } else if(_currentTargetIndex == 2) {
      setState(() {
        deliveryStatus = "Pack delivered";
        points[_currentTargetIndex].visited = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(deliveryStatus))
      );
    }

    if (_currentTargetIndex < points.length - 1) {
      setState(() {
        _currentTargetIndex++;
      });
      _fetchRoute();
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final markers = MarkerWidget.buildMarkers(points);

    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: Column(
        children: [
          Expanded(child: MapWidget(
            mapController: mapController,
            routePoints: routePoints, 
            markers: markers, 
            currentLocation: currentLocation
            )
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: _loadData, 
            label: Text(loading ? 'Loading...' : 'Show Route'),
            icon: const Icon(Icons.alt_route),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'location',
              onPressed: () {
                if(currentLocation != null) {
                  mapController.move(currentLocation!, 15);
                }
              },
              child: const Icon(Icons.my_location),
            ),
        ],
      ),
    );
  }
}
