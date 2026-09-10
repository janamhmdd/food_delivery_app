import '../../../../core/networking/api_result.dart';
import '../entities/menu_item.dart';

abstract class RestaurantRepository {
  Future<ApiResult<List<MenuItem>>> getAllItems();
}