import 'dart:convert';
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
        return response.data['usercode'].toString();
      } else {
        throw Exception('Invalid credentials');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ??
          (e.response?.statusCode == 400 || e.response?.statusCode == 404 || e.response?.statusCode == 401
              ? 'Invalid email or password'
              : 'Failed to login. Please try again.');
      throw Exception(message);
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
        return response.data['usercode'].toString();
      } else {
        throw Exception('Registration failed');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to register. Please try again.';
      throw Exception(message);
    }
  }

  Future<void> changePassword(String userCode, String newPassword) async {
    try {
      await _dio.put(
        '/api/User/$userCode',
        data: jsonEncode(newPassword),
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to update password';
      throw Exception(message);
    }
  }

  Future<void> deleteAccount(String userCode) async {
    try {
      await _dio.delete('/api/User/$userCode');
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'Failed to delete account';
      throw Exception(message);
    }
  }
}