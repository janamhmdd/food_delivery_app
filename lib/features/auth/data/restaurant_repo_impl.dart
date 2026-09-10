import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
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
}