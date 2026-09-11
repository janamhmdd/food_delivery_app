import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../domain/entities/menu_item.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/entities/restaurant.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../logic/category_keyword_map.dart';
import 'restaurant_remote_service.dart';

class RestaurantRepoImpl implements RestaurantRepository {
  final RestaurantRemoteService _remoteService;

  RestaurantRepoImpl(this._remoteService);

  @override
  Future<ApiResult<List<MenuItem>>> getAllItems() async {
    final result = await safeApiCall<List<dynamic>>(() async {
      return await _remoteService.getAllItems();
    });

    if (result.isSuccess && result.data != null) {
      final items = result.data!
          .map((json) => MenuItem.fromJson(json as Map<String, dynamic>))
          .toList();
      return ApiResult.success(items);
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to load items');
    }
  }

  @override
  Future<ApiResult<List<MenuItem>>> getItemsByCategory(String category) async {
    final result = await safeApiCall<List<MenuItem>>(() async {
      // Don't pass `category` here — the API only understands real cuisine
      // names (e.g. "Biryani"), not our 5 UI buckets, so it would always
      // return an empty list. Fetch everything and filter client-side.
      final restaurantJson = await _remoteService.getRestaurants();
      final restaurants = restaurantJson
          .map((json) => Restaurant.fromJson(json as Map<String, dynamic>))
          .where((r) => matchesCategoryKeywords(category, r.type))
          .toList();

      final items = <MenuItem>[];
      for (final restaurant in restaurants) {
        final menuJson = await _remoteService.getMenu(restaurant.restaurantId);
        items.addAll(
          menuJson.map((json) => MenuItem.fromJson(json as Map<String, dynamic>)),
        );
      }
      return items;
    });

    if (result.isSuccess && result.data != null) {
      return ApiResult.success(result.data!);
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to load items for $category');
    }
  }

  @override
  Future<ApiResult<void>> placeOrder({
    required int restaurantId,
    required String apiKey,
    required List<OrderLineItem> items,
  }) async {
    final result = await safeApiCall<dynamic>(() async {
      return await _remoteService.makeOrder(
        restaurantId: restaurantId,
        apiKey: apiKey,
        menuDTO: items.map((i) => i.toJson()).toList(),
      );
    });

    if (result.isSuccess) {
      return ApiResult.success(null);
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to place order');
    }
  }
}