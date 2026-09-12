import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../domain/entities/menu_item.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/item_category_keywords.dart';
import '../domain/repositories/restaurant_repository.dart';
import 'restaurant_remote_service.dart';

class RestaurantRepoImpl implements RestaurantRepository {
  final RestaurantRemoteService _remoteService;

  RestaurantRepoImpl(this._remoteService);

  @override
  Future<ApiResult<List<MenuItem>>> getAllItems({String? itemName}) async {
    final result = await safeApiCall<List<dynamic>>(() async {
      return await _remoteService.getAllItems(itemName: itemName);
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
      // Classify by each item's own name/description instead of the
      // restaurant's cuisine type — see item_category_keywords.dart for why.
      final itemsJson = await _remoteService.getAllItems();
      final items = itemsJson.map((json) => MenuItem.fromJson(json as Map<String, dynamic>));
      return items
          .where((i) => matchesItemCategoryKeywords(category, i.itemName, i.itemDescription))
          .toList();
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