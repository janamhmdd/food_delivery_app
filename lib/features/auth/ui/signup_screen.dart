import 'package:flutter/gestures.dart';
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

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: const _SignUpScreenContent(),
    );
  }
}

class _SignUpScreenContent extends StatelessWidget {
  const _SignUpScreenContent();

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
                content: Text('Registration successful! Welcome.'),
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
              // Top Yellow Header with "New Account"
              AuthHeader(
                title: 'New Account',
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
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                    child: Form(
                      key: cubit.signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Full name
                          AppTextField(
                            controller: cubit.signUpFullNameController,
                            labelText: 'Full name',
                            hintText: 'example@example.com',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // 2. Password
                          AppTextField(
                            controller: cubit.signUpPasswordController,
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
                          const SizedBox(height: 8),

                          // 3. Email
                          AppTextField(
                            controller: cubit.signUpEmailController,
                            labelText: 'Email',
                            hintText: 'example@example.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid email format';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // 4. Mobile Number
                          AppTextField(
                            controller: cubit.signUpMobileController,
                            labelText: 'Mobile Number',
                            hintText: '+ 123 456 789',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 8),

                          // 5. Date of birth
                          AppTextField(
                            controller: cubit.signUpDobController,
                            labelText: 'Date of birth',
                            hintText: 'DD / MM /YYY',
                            keyboardType: TextInputType.datetime,
                          ),
                          const SizedBox(height: 10),

                          // Terms and Conditions Notice
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                  height: 1.35,
                                ),
                                children: [
                                  const TextSpan(text: 'By continuing, you agree to\n'),
                                  TextSpan(
                                    text: 'Terms of Use',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Terms of Use tapped'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy.',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Privacy Policy tapped'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Sign Up Button
                          AppButton(
                            text: 'Sign Up',
                            isLoading: isLoading,
                            onPressed: () => cubit.signUp(),
                          ),
                          const SizedBox(height: 8),

                          // "or sign up with"
                          Center(
                            child: Text(
                              'or sign up with',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Social Icons Row (Google, Facebook, Fingerprint)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SocialCircleButton.google(
                                size: 38,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Google Sign In coming soon.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 14),
                              SocialCircleButton.facebook(
                                size: 38,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Facebook Sign In coming soon.'),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 14),
                              SocialCircleButton.fingerprint(
                                size: 38,
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.setFingerprint);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Already have an account? Log in
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.5,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.maybePop(context),
                                child: const Text(
                                  'Log in',
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
