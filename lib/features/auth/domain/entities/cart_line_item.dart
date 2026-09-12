import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class CartLineItem extends Equatable {
  final MenuItem item;
  final int quantity;

  const CartLineItem({required this.item, required this.quantity});

  double get lineTotal => item.itemPrice * quantity;

  CartLineItem copyWith({int? quantity}) => CartLineItem(item: item, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [item.itemId, quantity];
}