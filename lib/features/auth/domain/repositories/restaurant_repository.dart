import '../../../../core/networking/api_result.dart';
import '../entities/menu_item.dart';
import '../entities/order_line_item.dart';

abstract class RestaurantRepository {
  Future<ApiResult<List<MenuItem>>> getAllItems({String? itemName});

  Future<ApiResult<List<MenuItem>>> getItemsByCategory(String category);


  Future<ApiResult<void>> placeOrder({
    required int restaurantId,
    required String apiKey,
    required List<OrderLineItem> items,
  });
}