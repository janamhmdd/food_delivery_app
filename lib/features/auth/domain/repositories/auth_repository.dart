import '../../../../core/networking/api_result.dart';
import '../entities/user_session.dart';

abstract class AuthRepository {
  Future<ApiResult<UserSession>> login(String email, String password);
  Future<ApiResult<UserSession>> signUp(String email, String password);
  Future<ApiResult<String>> changePassword(String newPassword);
  Future<ApiResult<void>> deleteAccount();
  Future<UserSession?> getCurrentUser();
  Future<void> logout();
}
