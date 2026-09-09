import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../data/auth_remote_service.dart';
import '../../../core/helpers/shared_pref_helper.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteService _authService;

  AuthCubit(this._authService) : super(AuthInitialState());


  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();


  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    emit(AuthLoadingState());
    try {
      final userCode = await _authService.login(
        loginEmailController.text.trim(),
        loginPasswordController.text.trim(),
      );

      await SharedPrefHelper.saveUserCode(userCode);
      emit(AuthSuccessState(userCode));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    emit(AuthLoadingState());
    try {
      final userCode = await _authService.signUp(
        signUpEmailController.text.trim(),
        signUpPasswordController.text.trim(),
      );

      await SharedPrefHelper.saveUserCode(userCode);
      emit(AuthSuccessState(userCode));
    } catch (e) {
      emit(AuthErrorState(e.toString().replaceAll('Exception: ', '')));
    }
  }

  @override
  Future<void> close() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    return super.close();
  }
}