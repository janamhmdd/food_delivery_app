import 'package:flutter/material.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/order_record.dart';
import 'delivery_time_screen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  final OrderRecord order;
  const OrderConfirmedScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final deliveryBy = order.placedAt.add(const Duration(minutes: 45));
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
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
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 3)),
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
                      Text('¡Order Confirmed!', style: AppTextStyles.heading.copyWith(fontSize: 20), textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text('Your order has been placed successfully', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      Text(
                        'Delivery by ${_formatDeliveryBy(deliveryBy)}',
                        style: AppTextStyles.body.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => DeliveryTimeScreen(order: order)),
                        ),
                        child: Text('Track my order', style: AppTextStyles.link.copyWith(decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Text(
                'If you have any questions, please reach out directly to our customer support',
                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
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

String _formatDeliveryBy(DateTime dt) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final period = dt.hour >= 12 ? 'PM' : 'AM';
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${days[dt.weekday - 1]}, ${_ordinal(dt.day)}, $hour12:$minute $period';
}

String _ordinal(int day) {
  if (day >= 11 && day <= 13) return '${day}th';
  switch (day % 10) {
    case 1:
      return '${day}st';
    case 2:
      return '${day}nd';
    case 3:
      return '${day}rd';
    default:
      return '${day}th';
  }
}