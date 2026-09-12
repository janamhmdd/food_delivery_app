import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

/// Figma "Password Setting". The fake API's change-password endpoint takes
/// only a new password (no verification of the current one), so "Current
/// Password" is validated locally as required-but-not-checked.
class PasswordSettingScreen extends StatelessWidget {
  const PasswordSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _PasswordSettingContent(),
    );
  }
}

class _PasswordSettingContent extends StatefulWidget {
  const _PasswordSettingContent();

  @override
  State<_PasswordSettingContent> createState() => _PasswordSettingContentState();
}

class _PasswordSettingContentState extends State<_PasswordSettingContent> {
  final _currentPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                  Expanded(
                    child: Text('Password Setting', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is PasswordChangeSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: AppColors.success),
                      );
                      Navigator.of(context).pop();
                    } else if (state is PasswordChangeErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                      );
                    }
                  },
                  builder: (context, state) {
                    final isChanging = state is PasswordChangeLoadingState;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: cubit.changePasswordFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _currentPasswordController,
                              labelText: 'Current Password',
                              isPassword: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                              validator: (v) => (v == null || v.isEmpty) ? 'Enter your current password' : null,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Forgot Password?', style: AppTextStyles.link),
                              ),
                            ),
                            const SizedBox(height: 6),
                            AppTextField(
                              controller: cubit.newPasswordController,
                              labelText: 'New Password',
                              hintText: 'Enter at least 6 characters',
                              isPassword: true,
                              prefixIcon: const Icon(Icons.lock_reset),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Please enter a new password';
                                if (v.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            AppTextField(
                              controller: cubit.confirmNewPasswordController,
                              labelText: 'Confirm New Password',
                              isPassword: true,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(Icons.lock_reset),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Please confirm your new password';
                                if (v != cubit.newPasswordController.text) return 'Passwords do not match';
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              text: 'Change Password',
                              isLoading: isChanging,
                              onPressed: () {
                                if (cubit.changePasswordFormKey.currentState!.validate()) {
                                  cubit.changePassword();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}