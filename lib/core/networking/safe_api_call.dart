import 'package:dio/dio.dart';
import 'api_result.dart';

Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final result = await apiCall();
    return ApiResult.success(result);
  } on DioException catch (e) {
    return ApiResult.failure(_mapDioError(e));
  } catch (e) {
    return ApiResult.failure('Something went wrong, please try again');
  }
}

String _mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return 'Connection timed out, please try again';

    case DioExceptionType.connectionError:
      return 'No internet connection, please check your network';

    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        return 'Invalid credentials';
      } else if (statusCode == 404) {
        return 'Requested data not found';
      } else if (statusCode != null && statusCode >= 500) {
        return 'Server error, please try again later';
      }
      return 'Something went wrong, please try again';

    default:
      return 'Something went wrong, please try again';
  }
}