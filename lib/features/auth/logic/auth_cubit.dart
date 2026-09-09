import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitialState());

  // Login form controllers
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Sign up form controllers
  final TextEditingController signUpFullNameController = TextEditingController();
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController = TextEditingController();
  final TextEditingController signUpConfirmPasswordController = TextEditingController();
  final TextEditingController signUpMobileController = TextEditingController();
  final TextEditingController signUpDobController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  // Change / Set password form controllers
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController = TextEditingController();
  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    emit(AuthLoadingState());
    final result = await _authRepository.login(
      loginEmailController.text.trim(),
      loginPasswordController.text.trim(),
    );

    if (result.isSuccess && result.data != null) {
      emit(AuthSuccessState(
        result.data!.userCode,
        userEmail: result.data!.userEmail,
      ));
    } else {
      emit(AuthErrorState(result.errorMessage ?? 'Failed to login'));
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    if (signUpConfirmPasswordController.text.isNotEmpty &&
        signUpPasswordController.text != signUpConfirmPasswordController.text) {
      emit(AuthErrorState('Passwords do not match'));
      return;
    }

    emit(AuthLoadingState());
    final result = await _authRepository.signUp(
      signUpEmailController.text.trim(),
      signUpPasswordController.text.trim(),
    );

    if (result.isSuccess && result.data != null) {
      emit(AuthSuccessState(
        result.data!.userCode,
        userEmail: result.data!.userEmail,
      ));
    } else {
      emit(AuthErrorState(result.errorMessage ?? 'Failed to register'));
    }
  }

  Future<void> changePassword() async {
    if (!changePasswordFormKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmNewPasswordController.text) {
      emit(PasswordChangeErrorState('Passwords do not match'));
      return;
    }

    emit(PasswordChangeLoadingState());
    final result = await _authRepository.changePassword(
      newPasswordController.text.trim(),
    );

    if (result.isSuccess) {
      newPasswordController.clear();
      confirmNewPasswordController.clear();
      emit(PasswordChangeSuccessState(result.data ?? 'Password updated successfully'));
    } else {
      emit(PasswordChangeErrorState(result.errorMessage ?? 'Failed to update password'));
    }
  }

  Future<void> loadUserProfile() async {
    emit(ProfileLoadingState());
    final session = await _authRepository.getCurrentUser();
    if (session != null) {
      emit(ProfileLoadedState(session));
    } else {
      emit(AuthErrorState('No user session found'));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(LogoutSuccessState());
  }

  Future<void> deleteAccount() async {
    emit(AuthLoadingState());
    final result = await _authRepository.deleteAccount();
    if (result.isSuccess) {
      emit(AccountDeletedSuccessState());
    } else {
      emit(AuthErrorState(result.errorMessage ?? 'Failed to delete account'));
    }
  }

  @override
  Future<void> close() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpFullNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpMobileController.dispose();
    signUpDobController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    return super.close();
  }
}