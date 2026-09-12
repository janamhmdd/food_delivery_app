import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

/// Figma "Notification Setting". No settings endpoint in the fake API, so
/// toggles live only in local widget state for the current session.
class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  final Map<String, bool> _toggles = {
    'General Notification': true,
    'Sound': true,
    'Sound Call': true,
    'Vibrate': false,
    'Special Offers': false,
    'Payments': false,
    'Promo and discount': false,
    'Cashback': false,
  };

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
                    child: Text('Notification Setting', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  children: _toggles.keys.map((label) {
                    return SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(label, style: AppTextStyles.body.copyWith(fontSize: 14)),
                      value: _toggles[label]!,
                      activeThumbColor: AppColors.primary,
                      onChanged: (v) => setState(() => _toggles[label] = v),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}