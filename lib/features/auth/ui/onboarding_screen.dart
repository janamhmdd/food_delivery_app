import 'package:flutter/material.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';

class _OnboardingPage {
  final String imageAsset;
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.imageAsset,
    required this.icon,
    required this.title,
    required this.description,
  });
}


const _pages = [
  _OnboardingPage(
    imageAsset: 'assets/images/onboarding_1.png',
    icon: Icons.shopping_bag_outlined,
    title: 'Order For Food',
    description:
        'Lorem ipsum dolor sit amet, conse ctetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
  ),
  _OnboardingPage(
    imageAsset: 'assets/images/onboarding_2.png',
    icon: Icons.credit_card_outlined,
    title: 'Easy Payment',
    description:
        'Lorem ipsum dolor sit amet, conse ctetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
  ),
  _OnboardingPage(
    imageAsset: 'assets/images/onboarding_3.png',
    icon: Icons.delivery_dining_outlined,
    title: 'Fast Delivery',
    description:
        'Lorem ipsum dolor sit amet, conse ctetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  bool get _isLastPage => _currentPage == _pages.length - 1;

  Future<void> _finishOnboarding() async {
    await SharedPrefHelper.setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.welcome);
  }

  void _next() {
    if (_isLastPage) {
      _finishOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _OnboardingPageView(page: _pages[index]),
          ),
          if (!_isLastPage)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text('Skip', style: AppTextStyles.link),
              ),
            ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 28,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    final isActive = index == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isActive ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.peachCircle,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                AppButton(
                  text: _isLastPage ? 'Get Started' : 'Next',
                  onPressed: _next,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;
  const _OnboardingPageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Image.asset(
            page.imageAsset,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.peachCircle,
              child: Icon(page.icon, size: 48, color: AppColors.primary),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
            child: Column(
              children: [
                Icon(page.icon, color: AppColors.primary, size: 28),
                const SizedBox(height: 12),
                Text(
                  page.title,
                  style: AppTextStyles.heading.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}