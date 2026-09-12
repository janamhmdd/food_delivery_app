import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../domain/entities/cart_line_item.dart';
import '../domain/entities/menu_item.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'cart_state.dart';
import 'orders_cubit.dart';

/// Registered as a lazy singleton and provided at the app root (same
/// pattern as FavoritesCubit/OrdersCubit), so the cart persists as you
/// browse Home, Menu, and Item Details. It's in-memory only — not saved to
/// disk — so it resets on app restart.
class CartCubit extends Cubit<CartState> {
  final RestaurantRepository _repository;

  CartCubit(this._repository) : super(const CartState());

  void addItem(MenuItem item, {int quantity = 1}) {
    final items = List<CartLineItem>.from(state.items);
    final index = items.indexWhere((e) => e.item.itemId == item.itemId);
    if (index >= 0) {
      items[index] = items[index].copyWith(quantity: items[index].quantity + quantity);
    } else {
      items.add(CartLineItem(item: item, quantity: quantity));
    }
    emit(state.copyWith(items: items));
  }

  void updateQuantity(int itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }
    final items =
        state.items.map((e) => e.item.itemId == itemId ? e.copyWith(quantity: quantity) : e).toList();
    emit(state.copyWith(items: items));
  }

  void removeItem(int itemId) {
    final items = state.items.where((e) => e.item.itemId != itemId).toList();
    emit(state.copyWith(items: items));
  }

  void clear() => emit(const CartState());

  /// Places one real order per restaurant represented in the cart (the API
  /// only accepts a single restaurant per order), records one combined
  /// OrderRecord for the whole checkout, then empties the cart.
  /// Returns null on success, or an error message on failure.
  Future<String?> checkout() async {
    if (state.items.isEmpty) return 'Your cart is empty.';

    final apiKey = await SharedPrefHelper.getUserCode();
    if (apiKey == null || apiKey.isEmpty) return 'Please log in to place an order.';

    final byRestaurant = <int, List<CartLineItem>>{};
    for (final entry in state.items) {
      byRestaurant.putIfAbsent(entry.item.restaurantId, () => []).add(entry);
    }

    for (final group in byRestaurant.entries) {
      final result = await _repository.placeOrder(
        restaurantId: group.key,
        apiKey: apiKey,
        items: group.value.map((e) => OrderLineItem(itemName: e.item.itemName, quantity: e.quantity)).toList(),
      );
      if (!result.isSuccess) {
        return result.errorMessage ?? 'Failed to place order';
      }
    }

    final first = state.items.first;
    final title = state.items.length == 1
        ? first.item.itemName
        : '${first.item.itemName} and ${state.items.length - 1} other${state.items.length > 2 ? 's' : ''}';

    await getIt<OrdersCubit>().recordCartOrder(
      title: title,
      imageUrl: first.item.imageUrl,
      restaurantId: first.item.restaurantId,
      itemCount: state.itemCount,
      totalPrice: state.total,
      lineItems: state.items.map((e) => OrderLineItem(itemName: e.item.itemName, quantity: e.quantity)).toList(),
    );

    clear();
    return null;
  }
}