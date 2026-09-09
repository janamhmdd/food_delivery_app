import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/auth_header.dart';
import '../../../core/widgets/fingerprint_painter.dart';

class SetFingerprintScreen extends StatefulWidget {
  final bool initialScanned;

  const SetFingerprintScreen({
    super.key,
    this.initialScanned = false,
  });

  @override
  State<SetFingerprintScreen> createState() => _SetFingerprintScreenState();
}

class _SetFingerprintScreenState extends State<SetFingerprintScreen>
    with SingleTickerProviderStateMixin {
  late bool _isScanned;
  int _step = 0; // 0, 1, 2, 3, 4
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _isScanned = widget.initialScanned;
    if (_isScanned) {
      _step = 4;
      _currentProgress = 1.0;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _progressAnimation = Tween<double>(
      begin: _currentProgress,
      end: _currentProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFingerprintTap() {
    if (_isScanned && _step == 4) return;

    final nextStep = _step + 1;
    final targetProgress = nextStep / 4.0;

    HapticFeedback.selectionClick();

    _progressAnimation = Tween<double>(
      begin: _currentProgress,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.reset();
    _animationController.forward();

    setState(() {
      _step = nextStep;
      _currentProgress = targetProgress;
    });

    if (_step == 4) {
      _isScanned = true;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fingerprint captured successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onContinue() {
    if (!_isScanned || _step < 4) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete the fingerprint scan first, or tap Skip.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  void _onSkip() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  String _getStepInstruction() {
    switch (_step) {
      case 0:
        return 'Touch sensor to begin setup (Step 1 of 4)';
      case 1:
        return 'Lift and touch again (Step 2 of 4)';
      case 2:
        return 'Great! Touch again (Step 3 of 4)';
      case 3:
        return 'Almost done! One more touch (Step 4 of 4)';
      case 4:
      default:
        return 'Fingerprint registered ✓';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: Column(
        children: [
          // Top Yellow Header matching Figma
          AuthHeader(
            title: 'Set Your Fingerprint',
            showBackButton: true,
            onBackPressed: () => Navigator.maybePop(context),
          ),

          // White Sheet Container
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Description paragraph matching Figma
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12.5,
                        height: 1.45,
                      ),
                    ),

                    // Center Interactive Fingerprint (Figma 2-E unscanned / 2-F scanned)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              key: const Key('fingerprint_target'),
                              onTap: _onFingerprintTap,
                              behavior: HitTestBehavior.opaque,
                              child: AnimatedBuilder(
                                animation: _progressAnimation,
                                builder: (context, child) {
                                  return SizedBox(
                                    width: 185,
                                    height: 220,
                                    child: CustomPaint(
                                      painter: FingerprintPainter(
                                        color: const Color(0xFFFBD6C6),
                                        activeColor: AppColors.primary,
                                        scanProgress: _progressAnimation.value,
                                        strokeWidth: 10.5,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 14),

                            // 4-dot step indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                final isPassed = index < _step;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: isPassed ? 16 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: isPassed
                                        ? AppColors.primary
                                        : const Color(0xFFFBD6C6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(height: 10),

                            // Instructional helper text
                            Text(
                              _getStepInstruction(),
                              style: AppTextStyles.body.copyWith(
                                color: _step == 4
                                    ? AppColors.success
                                    : AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: _step == 4 ? FontWeight.bold : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Two Buttons Row: Skip & Continue matching Figma
                    Row(
                      children: [
                        // Skip Button (Soft Peach Fill, Orange Text)
                        Expanded(
                          child: AppButton(
                            text: 'Skip',
                            backgroundColor: const Color(0xFFFDE4D8),
                            textColor: AppColors.primary,
                            height: 46,
                            borderRadius: 24,
                            onPressed: _onSkip,
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Continue Button (Orange Fill, White Text)
                        Expanded(
                          child: AppButton(
                            text: 'Continue',
                            backgroundColor: _step == 4
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.85),
                            textColor: Colors.white,
                            height: 46,
                            borderRadius: 24,
                            onPressed: _onContinue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sleek Bottom Navigation Bar matching Figma
          const AppBottomNavBar(selectedIndex: 0),
        ],
      ),
    );
  }
}
