import 'package:dio/dio.dart';

class RestaurantRemoteService {
  final Dio _dio;

  RestaurantRemoteService(this._dio);


  Future<List<dynamic>> getAllItems() async {
    final response = await _dio.get('/api/Restaurant/items');
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
}