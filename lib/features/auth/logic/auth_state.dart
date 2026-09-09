abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String userCode;
  AuthSuccessState(this.userCode);
}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState(this.message);
}