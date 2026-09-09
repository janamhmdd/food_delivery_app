import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..loadUserProfile(),
      child: const _ProfileScreenContent(),
    );
  }
}

class _ProfileScreenContent extends StatelessWidget {
  const _ProfileScreenContent();

  void _showChangePasswordSheet(BuildContext context, AuthCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.85,
              ),
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is PasswordChangeSuccessState) {
                    Navigator.pop(bottomSheetContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.success,
                        behavior: SnackBarBehavior.floating,
                      ),
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

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Form(
                      key: cubit.changePasswordFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              width: 48,
                              height: 5,
                              decoration: BoxDecoration(
                                color: AppColors.border,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Change Password',
                            style: AppTextStyles.heading.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Enter your new password below to update your account.',
                            style: AppTextStyles.hint,
                          ),
                          const SizedBox(height: 16),
                          AppTextField(
                            controller: cubit.newPasswordController,
                            labelText: 'New Password',
                            hintText: 'Enter at least 6 characters',
                            isPassword: true,
                            prefixIcon: const Icon(Icons.lock_outline),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a new password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AppTextField(
                            controller: cubit.confirmNewPasswordController,
                            labelText: 'Confirm New Password',
                            hintText: 'Re-enter your new password',
                            isPassword: true,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(Icons.lock_reset),
                            onFieldSubmitted: (_) => cubit.changePassword(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please confirm your new password';
                              }
                              if (value != cubit.newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          AppButton(
                            text: 'Update Password',
                            isLoading: isChanging,
                            onPressed: () => cubit.changePassword(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, AuthCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account'),
        content: const Text(
          'This action is irreversible. All your order history and account details will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.deleteAccount();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccessState || state is AccountDeletedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is AccountDeletedSuccessState
                      ? 'Account deleted successfully.'
                      : 'Logged out successfully.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.loginScreen,
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
          String email = 'Loading...';
          String userCode = '';

          if (state is ProfileLoadedState) {
            email = state.session.userEmail.isNotEmpty
                ? state.session.userEmail
                : 'Registered User';
            userCode = state.session.userCode;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                // User Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.authBackground.withValues(alpha: 0.3),
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 52,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.fastfood,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        email,
                        style: AppTextStyles.heading.copyWith(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      if (userCode.isNotEmpty)
                        Text(
                          'ID: ${userCode.substring(0, userCode.length > 8 ? 8 : userCode.length)}...',
                          style: AppTextStyles.hint.copyWith(fontSize: 12),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Settings Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.lock_outline,
                        iconColor: AppColors.primary,
                        title: 'Change Password',
                        subtitle: 'Update your account security',
                        onTap: () => _showChangePasswordSheet(context, cubit),
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 20),
                      _ProfileMenuItem(
                        icon: Icons.logout_rounded,
                        iconColor: AppColors.error,
                        title: 'Log Out',
                        subtitle: 'Sign out from this device',
                        textColor: AppColors.error,
                        onTap: () => _showLogoutDialog(context, cubit),
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 20),
                      _ProfileMenuItem(
                        icon: Icons.delete_outline_rounded,
                        iconColor: AppColors.textSecondary,
                        title: 'Delete Account',
                        subtitle: 'Permanently remove your account',
                        textColor: AppColors.textSecondary,
                        onTap: () => _showDeleteAccountDialog(context, cubit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? textColor;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: AppTextStyles.subheading.copyWith(
          fontSize: 15,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.hint.copyWith(fontSize: 12),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onTap: onTap,
    );
  }
}
