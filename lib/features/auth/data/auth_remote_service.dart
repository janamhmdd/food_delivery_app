import 'package:dio/dio.dart';

class AuthRemoteService {
  final Dio _dio;

  AuthRemoteService(this._dio);

  Future<String> login(String email, String password) async {
    try {
      final response = await _dio.get(
        '/api/User/getusercode',
        queryParameters: {
          'UserEmail': email,
          'Password': password,
        },
      );
      if (response.data != null && response.data['usercode'] != null) {
        return response.data['usercode'];
      } else {
        throw Exception('Invalid credentials');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to login');
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/User/register',
        data: {
          'userEmail': email,
          'password': password,
        },
      );
      if (response.data != null && response.data['usercode'] != null) {
        return response.data['usercode'];
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? 'Failed to register');
    }
  }
}