import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'favorites_state.dart';

/// Registered as a lazy singleton (see service_locator.dart) and provided
/// once at the app root (see main.dart), so every screen shares one
/// instance: toggle a heart anywhere and it updates everywhere.
class FavoritesCubit extends Cubit<FavoritesState> {
  final RestaurantRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState()) {
    _init();
  }

  Future<void> _init() async {
    final ids = await SharedPrefHelper.getFavoriteIds();
    emit(state.copyWith(favoriteIds: ids));
    await _hydrateItems();
  }

  /// Shared prefs only stores item IDs, so on startup this fetches full
  /// item details (name/image/price) from the same "all items" endpoint
  /// the Home screen uses, then filters down to the saved IDs.
  Future<void> _hydrateItems() async {
    if (state.favoriteIds.isEmpty) {
      emit(state.copyWith(status: FavoritesStatus.success, favoriteItems: const []));
      return;
    }
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await _repository.getAllItems();

    if (result.isSuccess && result.data != null) {
      final items = result.data!.where((i) => state.favoriteIds.contains(i.itemId)).toList();
      emit(state.copyWith(status: FavoritesStatus.success, favoriteItems: items));
    } else {
      emit(state.copyWith(
        status: FavoritesStatus.error,
        errorMessage: result.errorMessage ?? 'Failed to load favorites',
      ));
    }
  }

  Future<void> refresh() => _hydrateItems();

  bool isFavorite(int itemId) => state.favoriteIds.contains(itemId);

  Future<void> toggleFavorite(MenuItem item) async {
    final ids = Set<int>.from(state.favoriteIds);
    final items = List<MenuItem>.from(state.favoriteItems);

    if (ids.contains(item.itemId)) {
      ids.remove(item.itemId);
      items.removeWhere((i) => i.itemId == item.itemId);
    } else {
      ids.add(item.itemId);
      items.add(item);
    }

    emit(state.copyWith(
      status: FavoritesStatus.success,
      favoriteIds: ids,
      favoriteItems: items,
    ));
    await SharedPrefHelper.saveFavoriteIds(ids);
  }
}