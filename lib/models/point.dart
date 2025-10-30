class Point {
  final double lat;
  final double lon;
  final String name;

  Point({required this.lat, required this.lon, required this.name});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      lat: json['lat'],
      lon: json['lon'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
        'name': name,
      };
}
