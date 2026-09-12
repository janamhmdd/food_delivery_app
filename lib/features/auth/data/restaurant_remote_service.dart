import 'package:dio/dio.dart';

class RestaurantRemoteService {
  final Dio _dio;

  RestaurantRemoteService(this._dio);

  Future<List<dynamic>> getAllItems({String? itemName, String? sortByPrice}) async {
    final response = await _dio.get(
      '/api/Restaurant/items',
      queryParameters: {
        if (itemName != null && itemName.isNotEmpty) 'ItemName': itemName,
        if (sortByPrice != null && sortByPrice.isNotEmpty) 'sortbyprice': sortByPrice,
      },
    );
    return response.data as List<dynamic>;
  }

  Future<List<dynamic>> getRestaurants({String? category}) async {
    final response = await _dio.get(
      '/api/Restaurant',
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    return response.data as List<dynamic>;
  }

  
  Future<List<dynamic>> getMenu(int restaurantId, {String? sortByPrice}) async {
    final response = await _dio.get(
      '/api/Restaurant/$restaurantId/menu',
      queryParameters: {
        if (sortByPrice != null && sortByPrice.isNotEmpty) 'sortbyprice': sortByPrice,
      },
    );
    return response.data as List<dynamic>;
  }

  Future<dynamic> makeOrder({
    required int restaurantId,
    required String apiKey,
    required List<Map<String, dynamic>> menuDTO,
  }) async {
    final response = await _dio.post(
  '/api/Order/$restaurantId/makeorder',
    queryParameters: {'apikey': apiKey},
    data: {'menuDTO': menuDTO},
    );
    return response.data;
  }
}