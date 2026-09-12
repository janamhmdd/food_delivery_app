import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class SavedAddress {
  final String name;
  final String address;
  const SavedAddress({required this.name, required this.address});
}

/// Figma "Add New Address". Returns a [SavedAddress] via Navigator.pop when
/// the user taps Apply, so the caller can add it to its local list.
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _apply() {
    if (_nameController.text.trim().isEmpty || _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
      return;
    }
    Navigator.of(context).pop(
      SavedAddress(name: _nameController.text.trim(), address: _addressController.text.trim()),
    );
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
                    child: Text('Add New Address', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.peachCircle,
                          ),
                          child: const Icon(Icons.home_outlined, color: AppColors.primary, size: 34),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        hintText: 'e.g. My Home',
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _addressController,
                        labelText: 'Address',
                        hintText: 'Street, city, state',
                        keyboardType: TextInputType.streetAddress,
                      ),
                      const SizedBox(height: 24),
                      AppButton(text: 'Apply', onPressed: _apply),
                    ],
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