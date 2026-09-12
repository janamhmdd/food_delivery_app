import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';


class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>()..loadUserProfile(),
      child: const _MyProfileContent(),
    );
  }
}

class _MyProfileContent extends StatefulWidget {
  const _MyProfileContent();

  @override
  State<_MyProfileContent> createState() => _MyProfileContentState();
}

class _MyProfileContentState extends State<_MyProfileContent> {
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _prefilled = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text('My Profile', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is ProfileLoadedState && !_prefilled) {
                      _prefilled = true;
                      _emailController.text = state.session.userEmail;
                      if (_fullNameController.text.isEmpty) {
                        _fullNameController.text = state.session.userEmail.isNotEmpty
                            ? state.session.userEmail.split('@').first
                            : '';
                      }
                    }
                  },
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.authBackground.withValues(alpha: 0.3),
                                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
                                ),
                                child: const Icon(Icons.person, size: 52, color: AppColors.primary),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppTextField(
                          controller: _fullNameController,
                          labelText: 'Full Name',
                          hintText: 'Enter your full name',
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _dobController,
                          labelText: 'Date of Birth',
                          hintText: 'DD / MM / YYYY',
                          prefixIcon: const Icon(Icons.cake_outlined),
                          keyboardType: TextInputType.datetime,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'your@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          enabled: false,
                        ),
                        const SizedBox(height: 14),
                        AppTextField(
                          controller: _phoneController,
                          labelText: 'Phone Number',
                          hintText: '+1 234 567 8900',
                          prefixIcon: const Icon(Icons.call_outlined),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Update Profile',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile updated')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}