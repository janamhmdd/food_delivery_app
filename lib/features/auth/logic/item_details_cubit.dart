import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../domain/entities/menu_item.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'generic_add_ons.dart';
import 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  final RestaurantRepository _repository;
  final MenuItem item;

  ItemDetailsCubit(this._repository, this.item) : super(const ItemDetailsState());

  void incrementQuantity() => emit(state.copyWith(quantity: state.quantity + 1));

  void decrementQuantity() {
    if (state.quantity <= 1) return;
    emit(state.copyWith(quantity: state.quantity - 1));
  }

  void toggleAddOn(String addOnName) {
    final updated = Set<String>.from(state.selectedAddOns);
    if (updated.contains(addOnName)) {
      updated.remove(addOnName);
    } else {
      updated.add(addOnName);
    }
    emit(state.copyWith(selectedAddOns: updated));
  }

  /// Sum of the base item price and selected add-ons, times quantity.
  /// Add-ons are cosmetic (see generic_add_ons.dart) — this total is for
  /// display only and isn't what actually gets sent to the order API.
  double get displayTotal {
    final addOnTotal = kGenericAddOns
        .where((a) => state.selectedAddOns.contains(a.name))
        .fold(0.0, (sum, a) => sum + a.price);
    return (item.itemPrice + addOnTotal) * state.quantity;
  }

  Future<void> placeOrder() async {
    final apiKey = await SharedPrefHelper.getUserCode();
    if (apiKey == null || apiKey.isEmpty) {
      emit(state.copyWith(
        orderStatus: OrderStatus.error,
        errorMessage: 'Please log in to place an order.',
      ));
      return;
    }

    emit(state.copyWith(orderStatus: OrderStatus.placing));

    final result = await _repository.placeOrder(
      restaurantId: item.restaurantId,
      apiKey: apiKey,
      items: [OrderLineItem(itemName: item.itemName, quantity: state.quantity)],
    );

    if (result.isSuccess) {
      emit(state.copyWith(orderStatus: OrderStatus.success));
    } else {
      emit(state.copyWith(
        orderStatus: OrderStatus.error,
        errorMessage: result.errorMessage ?? 'Failed to place order',
      ));
    }
  }
}