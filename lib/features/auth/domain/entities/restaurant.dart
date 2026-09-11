
class Restaurant {
  final int restaurantId;
  final String restaurantName;
  final String address;
  final String type; 
  final bool parkingLot;

  const Restaurant({
    required this.restaurantId,
    required this.restaurantName,
    required this.address,
    required this.type,
    required this.parkingLot,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      restaurantId: json['restaurantID'] as int? ?? 0,
      restaurantName: json['restaurantName'] as String? ?? '',
      address: json['address'] as String? ?? '',
      type: json['type'] as String? ?? '',
      parkingLot: json['parkingLot'] as bool? ?? false,
    );
  }
}