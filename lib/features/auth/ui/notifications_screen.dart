import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

class _NotificationItem {
  final IconData icon;
  final String message;
  const _NotificationItem(this.icon, this.message);
}

const _notifications = [
  _NotificationItem(Icons.restaurant, 'We have added a product you might like.'),
  _NotificationItem(Icons.favorite, 'One of your favorite is on promotion.'),
  _NotificationItem(Icons.shopping_bag, 'Your order has been delivered.'),
  _NotificationItem(Icons.delivery_dining, 'The delivery is on his way.'),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  const Icon(Icons.notifications, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'Notifications',
                    style: AppTextStyles.headerTitle.copyWith(color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _notifications.length,
                separatorBuilder: (_, _) => const Divider(color: Colors.white24, height: 24),
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(item.icon, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.message,
                          style: AppTextStyles.body.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}