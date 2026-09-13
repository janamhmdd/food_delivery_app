import 'package:flutter/material.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/order_record.dart';
import 'live_tracking_screen.dart';

class _DeliveryStep {
  final String label;
  final String duration;
  const _DeliveryStep(this.label, this.duration);
}

const List<_DeliveryStep> _kDeliverySteps = [
  _DeliveryStep('Your order has been accepted', '2 min'),
  _DeliveryStep('The restaurant is preparing your order', '5 min'),
  _DeliveryStep('The delivery is on his way', '10 min'),
  _DeliveryStep('Your order has been delivered', '8 min'),
];

class DeliveryTimeScreen extends StatelessWidget {
  final OrderRecord order;
  const DeliveryTimeScreen({super.key, required this.order});

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
                  Expanded(child: Text('Delivery time', textAlign: TextAlign.center, style: AppTextStyles.headerTitle)),
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
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('Shipping Address', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(12)),
                      child: const Text('778 Locust View Drive Oakland, CA', style: AppTextStyles.body),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        color: AppColors.peachCircle,
                        child: Image.asset(
                          'assets/images/map_1.png', 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Time', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Estimated Delivery', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                            Text('25 mins', style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._kDeliverySteps.map((step) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(child: Text(step.label, style: AppTextStyles.body.copyWith(fontSize: 13))),
                              Text(step.duration, style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: const Text('Return Home'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveTrackingScreen(order: order))),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            ),
                            child: const Text('Track Order'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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