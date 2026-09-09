import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_header.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _SetPasswordScreenContent(),
    );
  }
}

class _SetPasswordScreenContent extends StatelessWidget {
  const _SetPasswordScreenContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is PasswordChangeSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginScreen,
              (route) => false,
            );
          } else if (state is PasswordChangeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isChanging = state is PasswordChangeLoadingState;

          return Column(
            children: [
              // Top Yellow Header with "Set Password"
              AuthHeader(
                title: 'Set Password',
                showBackButton: true,
                onBackPressed: () => Navigator.maybePop(context),
              ),

              // Form Sheet Container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Form(
                      key: cubit.changePasswordFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Subtitle description from Figma
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          AppTextField(
                            controller: cubit.newPasswordController,
                            labelText: 'Password',
                            hintText: '*************',
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password Field
                          AppTextField(
                            controller: cubit.confirmNewPasswordController,
                            labelText: 'Confirm Password',
                            hintText: '*************',
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => cubit.changePassword(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != cubit.newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),

                          // Create New Password Button
                          AppButton(
                            text: 'Create New Password',
                            isLoading: isChanging,
                            onPressed: () => cubit.changePassword(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Navigation Bar
              const AppBottomNavBar(selectedIndex: 0),
            ],
          );
        },
      ),
    );
  }
}
