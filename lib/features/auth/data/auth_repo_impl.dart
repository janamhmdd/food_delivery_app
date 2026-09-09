import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/safe_api_call.dart';
import '../domain/entities/user_session.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_remote_service.dart';

class AuthRepoImpl implements AuthRepository {
  final AuthRemoteService _remoteService;

  AuthRepoImpl(this._remoteService);

  @override
  Future<ApiResult<UserSession>> login(String email, String password) async {
    final result = await safeApiCall<String>(() async {
      return await _remoteService.login(email, password);
    });

    if (result.isSuccess && result.data != null) {
      final userCode = result.data!;
      await SharedPrefHelper.saveUserCode(userCode);
      await SharedPrefHelper.saveUserEmail(email);
      return ApiResult.success(UserSession(userCode: userCode, userEmail: email));
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to login');
    }
  }

  @override
  Future<ApiResult<UserSession>> signUp(String email, String password) async {
    final result = await safeApiCall<String>(() async {
      return await _remoteService.signUp(email, password);
    });

    if (result.isSuccess && result.data != null) {
      final userCode = result.data!;
      await SharedPrefHelper.saveUserCode(userCode);
      await SharedPrefHelper.saveUserEmail(email);
      return ApiResult.success(UserSession(userCode: userCode, userEmail: email));
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to sign up');
    }
  }

  @override
  Future<ApiResult<String>> changePassword(String newPassword) async {
    final userCode = await SharedPrefHelper.getUserCode();
    if (userCode == null || userCode.isEmpty) {
      return ApiResult.failure('Session expired. Please log in again.');
    }

    final result = await safeApiCall<void>(() async {
      await _remoteService.changePassword(userCode, newPassword);
    });

    if (result.isSuccess) {
      return ApiResult.success('Password updated successfully');
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to change password');
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    final userCode = await SharedPrefHelper.getUserCode();
    if (userCode == null || userCode.isEmpty) {
      return ApiResult.failure('Session expired. Please log in again.');
    }

    final result = await safeApiCall<void>(() async {
      await _remoteService.deleteAccount(userCode);
    });

    if (result.isSuccess) {
      await SharedPrefHelper.clearSession();
      return ApiResult.success(null);
    } else {
      return ApiResult.failure(result.errorMessage ?? 'Failed to delete account');
    }
  }

  @override
  Future<UserSession?> getCurrentUser() async {
    final userCode = await SharedPrefHelper.getUserCode();
    final userEmail = await SharedPrefHelper.getUserEmail();

    if (userCode != null && userCode.isNotEmpty) {
      return UserSession(
        userCode: userCode,
        userEmail: userEmail ?? '',
      );
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await SharedPrefHelper.clearSession();
  }
}
