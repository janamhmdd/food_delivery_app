import 'package:flutter/material.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/order_record.dart';

class OrderDeliveredScreen extends StatefulWidget {
  final OrderRecord order;
  const OrderDeliveredScreen({super.key, required this.order});

  @override
  State<OrderDeliveredScreen> createState() => _OrderDeliveredScreenState();
}

class _OrderDeliveredScreenState extends State<OrderDeliveredScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primary, width: 3),
                              ),
                            ),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('¡Order Delivered!', style: AppTextStyles.heading.copyWith(fontSize: 20), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(
                        'Your order has been successfully delivered, enjoy it!',
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Text('Rate your delivery', style: AppTextStyles.heading.copyWith(fontSize: 14)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (i) {
                          final filled = i < _rating;
                          return IconButton(
                            onPressed: () => setState(() => _rating = i + 1),
                            icon: Icon(filled ? Icons.star : Icons.star_border, color: AppColors.primary, size: 28),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  children: const [
                    TextSpan(text: 'If you have any questions, please reach out directly to our '),
                    TextSpan(
                      text: 'customer support',
                      style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 3,
        onTap: (index) => handleBottomNavTap(context, index, 3),
      ),
    );
  }
}