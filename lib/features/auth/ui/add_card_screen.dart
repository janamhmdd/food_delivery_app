import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class SavedCard {
  final String holderName;
  final String last4;
  const SavedCard({required this.holderName, required this.last4});
}

/// Figma "Add Card". No payment endpoint in the fake API, so Save Card just
/// returns the last 4 digits to the caller for the local list.
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _save() {
    final digits = _numberController.text.replaceAll(RegExp(r'\D'), '');
    if (_holderController.text.trim().isEmpty || digits.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the card details.')),
      );
      return;
    }
    Navigator.of(context).pop(
      SavedCard(holderName: _holderController.text.trim(), last4: digits.substring(digits.length - 4)),
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
                    child: Text('Add Card', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                      Container(
                        height: 170,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.wifi, color: Colors.white),
                            const Spacer(),
                            Text(
                              _numberController.text.isEmpty ? '0000 0000 0000 0000' : _numberController.text,
                              style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _holderController.text.isEmpty ? 'CARD HOLDER NAME' : _holderController.text,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                                Text(
                                  _expiryController.text.isEmpty ? '00/00' : _expiryController.text,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        controller: _holderController,
                        labelText: 'Card holder name',
                        hintText: 'John Smith',
                        onFieldSubmitted: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _numberController,
                        labelText: 'Card Number',
                        hintText: '0000 0000 0000 00',
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _expiryController,
                              labelText: 'Expiry Date',
                              hintText: '04/28',
                              keyboardType: TextInputType.datetime,
                              onFieldSubmitted: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: AppTextField(
                              controller: _cvvController,
                              labelText: 'CVV',
                              hintText: '0000',
                              keyboardType: TextInputType.number,
                              isPassword: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AppButton(text: 'Save Card', onPressed: _save),
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