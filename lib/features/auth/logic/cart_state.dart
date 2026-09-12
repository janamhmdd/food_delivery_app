import 'package:equatable/equatable.dart';
import '../domain/entities/cart_line_item.dart';
import '../domain/pricing_constants.dart';

class CartState extends Equatable {
  final List<CartLineItem> items;
  const CartState({this.items = const []});

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, e) => sum + e.quantity);
  double get subtotal => items.fold(0.0, (sum, e) => sum + e.lineTotal);
  double get tax => subtotal * kTaxRate;
  double get deliveryFee => items.isEmpty ? 0.0 : kDeliveryFee;
  double get total => subtotal + tax + deliveryFee;

  CartState copyWith({List<CartLineItem>? items}) => CartState(items: items ?? this.items);

  @override
  List<Object?> get props => [items];
}