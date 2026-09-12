import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../domain/entities/menu_item.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/entities/order_record.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'orders_state.dart';

/// Registered as a lazy singleton and provided at the app root (same
/// pattern as FavoritesCubit) so an order placed from Item Details shows
/// up immediately on the Orders screen, from any tab.
class OrdersCubit extends Cubit<OrdersState> {
  final RestaurantRepository _repository;

  OrdersCubit(this._repository) : super(const OrdersState()) {
    _init();
  }

  Future<void> _init() async {
    final stored = await SharedPrefHelper.getOrderHistory();
    final orders = stored.map(OrderRecord.fromJson).toList()
      ..sort((a, b) => b.placedAt.compareTo(a.placedAt));
    emit(state.copyWith(status: OrdersStatus.success, orders: orders));
  }

  Future<void> _persist() =>
      SharedPrefHelper.saveOrderHistory(state.orders.map((o) => o.toJson()).toList());

  /// Called by ItemDetailsCubit right after a successful placeOrder call.
  Future<void> recordOrder({
    required int restaurantId,
    required MenuItem item,
    required int quantity,
    required double totalPrice,
  }) async {
    final record = OrderRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      restaurantId: restaurantId,
      title: item.itemName,
      imageUrl: item.imageUrl,
      itemCount: quantity,
      totalPrice: totalPrice,
      placedAt: DateTime.now(),
      lineItems: [OrderLineItem(itemName: item.itemName, quantity: quantity)],
    );
    emit(state.copyWith(orders: [record, ...state.orders]));
    await _persist();
  }

  /// Same as recordOrder but for a full cart checkout (possibly several
/// different items), rather than a single MenuItem.
Future<void> recordCartOrder({
  required String title,
  required String imageUrl,
  required int restaurantId,
  required int itemCount,
  required double totalPrice,
  required List<OrderLineItem> lineItems,
}) async {
  final record = OrderRecord(
    id: DateTime.now().microsecondsSinceEpoch.toString(),
    restaurantId: restaurantId,
    title: title,
    imageUrl: imageUrl,
    itemCount: itemCount,
    totalPrice: totalPrice,
    placedAt: DateTime.now(),
    lineItems: lineItems,
  );
  emit(state.copyWith(orders: [record, ...state.orders]));
  await _persist();
}

  /// Stub for delivery tracking — the API has no real-time status, so
  /// "Track Driver" just simulates the order arriving.
  Future<void> markCompleted(String orderId) async {
    final updated = state.orders
        .map((o) => o.id == orderId ? o.copyWith(status: OrderLocalStatus.completed) : o)
        .toList();
    emit(state.copyWith(orders: updated));
    await _persist();
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    final updated = state.orders
        .map((o) => o.id == orderId
            ? o.copyWith(status: OrderLocalStatus.cancelled, cancelReason: reason)
            : o)
        .toList();
    emit(state.copyWith(orders: updated));
    await _persist();
  }

  
  Future<bool> reorder(OrderRecord order, {List<OrderLineItem>? lineItemsOverride}) async {
  final apiKey = await SharedPrefHelper.getUserCode();
  if (apiKey == null || apiKey.isEmpty) return false;

  final items = lineItemsOverride ?? order.lineItems;
  final result = await _repository.placeOrder(
    restaurantId: order.restaurantId,
    apiKey: apiKey,
    items: items,
  );

  if (result.isSuccess) {
    final newItemCount = items.fold<int>(0, (sum, i) => sum + i.quantity);
    final unitPrice = order.itemCount > 0 ? order.totalPrice / order.itemCount : order.totalPrice;
    final record = OrderRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      restaurantId: order.restaurantId,
      title: order.title,
      imageUrl: order.imageUrl,
      itemCount: newItemCount,
      totalPrice: unitPrice * newItemCount,
      placedAt: DateTime.now(),
      lineItems: items,
    );
    emit(state.copyWith(orders: [record, ...state.orders]));
    await _persist();
  }
  return result.isSuccess;
}
}