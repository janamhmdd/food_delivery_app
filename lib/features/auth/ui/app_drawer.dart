import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..loadUserProfile(),
      child: const _AppDrawerContent(),
    );
  }
}

class _AppDrawerContent extends StatelessWidget {
  const _AppDrawerContent();

  void _showLogoutDialog(BuildContext context, AuthCubit cubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => cubit.logout(),
            child: const Text('Yes, logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      backgroundColor: AppColors.primary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (route) => false);
          } else if (state is AuthErrorState) {
            Navigator.pop(context); // close the confirm dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          String name = 'Registered User';
          String email = '';
          if (state is ProfileLoadedState) {
            email = state.session.userEmail;
            if (email.isNotEmpty) name = email.split('@').first;
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.25),
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: AppTextStyles.subheading.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (email.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                email,
                                style: AppTextStyles.hint.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _DrawerItem(
                        icon: Icons.shopping_bag_outlined,
                        label: 'My Orders',
                        onTap: () => Navigator.pushNamed(context, Routes.orders),
                      ),
                      _DrawerItem(
                        icon: Icons.person_outline,
                        label: 'My Profile',
                        onTap: () => Navigator.pushNamed(context, Routes.myProfile),
                      ),
                      _DrawerItem(
                        icon: Icons.location_on_outlined,
                        label: 'Delivery Address',
                        onTap: () => Navigator.pushNamed(context, Routes.deliveryAddress),
                      ),
                      _DrawerItem(
                        icon: Icons.credit_card_outlined,
                        label: 'Payment Methods',
                        onTap: () => Navigator.pushNamed(context, Routes.paymentMethods),
                      ),
                      _DrawerItem(
                        icon: Icons.call_outlined,
                        label: 'Contact Us',
                        onTap: () => Navigator.pushNamed(context, Routes.contactUs),
                      ),
                      _DrawerItem(
                        icon: Icons.chat_bubble_outline,
                        label: 'Help & FAQs',
                        onTap: () => Navigator.pushNamed(context, Routes.help),
                      ),
                      _DrawerItem(
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                        onTap: () => Navigator.pushNamed(context, Routes.settings),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
                _DrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  onTap: () => _showLogoutDialog(context, cubit),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
              child: Icon(icon, color: Colors.white, size: 19),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}