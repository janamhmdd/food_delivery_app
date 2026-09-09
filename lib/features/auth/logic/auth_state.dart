import '../domain/entities/user_session.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String userCode;
  final String? userEmail;
  AuthSuccessState(this.userCode, {this.userEmail});
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}

// Profile & Password states
class ProfileLoadingState extends AuthState {}

class ProfileLoadedState extends AuthState {
  final UserSession session;
  ProfileLoadedState(this.session);
}

class PasswordChangeLoadingState extends AuthState {}

class PasswordChangeSuccessState extends AuthState {
  final String message;
  PasswordChangeSuccessState(this.message);
}

class PasswordChangeErrorState extends AuthState {
  final String message;
  PasswordChangeErrorState(this.message);
}

class LogoutSuccessState extends AuthState {}

class AccountDeletedSuccessState extends AuthState {}