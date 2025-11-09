class Order {
  final int id;
  final String pickupLocation;
  final String dropoffLocation;
  final String deliveryStatus;

  Order({
    required this.id,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.deliveryStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      pickupLocation: json['pickupLocation'],
      dropoffLocation: json['dropoffLocation'],
      deliveryStatus: json['deliveryStatus'],
    );
  }
}
