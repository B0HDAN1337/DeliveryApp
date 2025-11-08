class Point {
  final double lat;
  final double lon;
  final String name;
  bool visited;

  Point({required this.lat, required this.lon, required this.name, required this.visited});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      lat: json['lat'],
      lon: json['lon'],
      name: json['name'] ?? '',
      visited: json['visited'] ?? false
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'name': name,
      };
}
