import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import 'add_address_screen.dart';


class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final List<SavedAddress> _addresses = [
    const SavedAddress(name: 'My home', address: '778 Locust View Drive Oakland, CA'),
    const SavedAddress(name: 'My Office', address: '778 Locust View Drive Oakland, CA'),
    const SavedAddress(name: "Parent's House", address: '778 Locust View Drive Oakland, CA'),
  ];
  int _selected = 0;

  Future<void> _addAddress() async {
    final result = await Navigator.push<SavedAddress>(
      context,
      MaterialPageRoute(builder: (_) => const AddAddressScreen()),
    );
    if (result != null) {
      setState(() {
        _addresses.add(result);
        _selected = _addresses.length - 1;
      });
    }
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
                    child: Text('Delivery Address', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _addresses.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final addr = _addresses[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.home_outlined, color: AppColors.primary),
                            title: Text(addr.name, style: AppTextStyles.subheading.copyWith(fontSize: 14)),
                            subtitle: Text(
                              addr.address,
                              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                            ),
                            trailing: Icon(
                              _selected == index ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: AppColors.primary,
                            ),
                            onTap: () => setState(() => _selected = index),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: TextButton(
                        onPressed: _addAddress,
                        child: Text(
                          'Add New Address',
                          style: AppTextStyles.body.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}