
class MenuItem {
  final int itemId;
  final String itemName;
  final String itemDescription;
  final double itemPrice;
  final String restaurantName;
  final int restaurantId;
  final String imageUrl;

  const MenuItem({
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.restaurantName,
    required this.restaurantId,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      itemId: json['itemID'] as int? ?? 0,
      itemName: json['itemName'] as String? ?? '',
      itemDescription: json['itemDescription'] as String? ?? '',
      itemPrice: (json['itemPrice'] as num?)?.toDouble() ?? 0.0,
      restaurantName: json['restaurantName'] as String? ?? '',
      restaurantId: json['restaurantID'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }
}