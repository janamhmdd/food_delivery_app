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
import '../../../core/widgets/social_circle_button.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _LoginScreenContent(),
    );
  }
}

class _LoginScreenContent extends StatelessWidget {
  const _LoginScreenContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful! Welcome back.'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          } else if (state is AuthErrorState) {
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
          final isLoading = state is AuthLoadingState;

          return Column(
            children: [
              // Top Yellow Header with Back Button and Title
              AuthHeader(
                title: 'Hello!',
                showBackButton: Navigator.canPop(context),
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
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
                    child: Form(
                      key: cubit.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Welcome Title
                          Text(
                            'Welcome',
                            style: AppTextStyles.heading.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Email or Mobile Number Field
                          AppTextField(
                            controller: cubit.loginEmailController,
                            labelText: 'Email or Mobile Number',
                            hintText: 'example@example.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter email or mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Password Field
                          AppTextField(
                            controller: cubit.loginPasswordController,
                            labelText: 'Password',
                            hintText: '*************',
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => cubit.login(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Forget Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.setPassword);
                              },
                              child: const Text(
                                'Forget Password',
                                style: AppTextStyles.link,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Log In Button
                          AppButton(
                            text: 'Log In',
                            isLoading: isLoading,
                            onPressed: () => cubit.login(),
                          ),
                          const SizedBox(height: 12),

                          // "or" Divider Text
                          Center(
                            child: Text(
                              'or',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Fingerprint Circle Button
                          Center(
                            child: SocialCircleButton.fingerprint(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.setFingerprint);
                              },
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Don't have an account? Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.signUp);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: AppTextStyles.link,
                                ),
                              ),
                            ],
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