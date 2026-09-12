import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import 'add_card_screen.dart';

class _PaymentOption {
  final IconData icon;
  final String label;
  const _PaymentOption(this.icon, this.label);
}

const _kOtherOptions = [
  _PaymentOption(Icons.apple, 'Apple Pay'),
  _PaymentOption(Icons.payment, 'Paypal'),
  _PaymentOption(Icons.g_mobiledata, 'Google Pay'),
];

/// Figma "Payment Methods". No payment endpoint in the fake API, so cards
/// and the selected method live only in local widget state.
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<SavedCard> _cards = [const SavedCard(holderName: 'John Smith', last4: '4300')];
  int _selected = 0; // index into _cards, then _kOtherOptions after that

  Future<void> _addCard() async {
    final result = await Navigator.push<SavedCard>(
      context,
      MaterialPageRoute(builder: (_) => const AddCardScreen()),
    );
    if (result != null) {
      setState(() {
        _cards.add(result);
        _selected = _cards.length - 1;
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
                    child: Text('Payment Methods', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          for (int i = 0; i < _cards.length; i++) ...[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.credit_card, color: AppColors.primary),
                              title: Text(
                                '*** *** *** ${_cards[i].last4}',
                                style: AppTextStyles.subheading.copyWith(fontSize: 14),
                              ),
                              subtitle: Text(
                                _cards[i].holderName,
                                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                              ),
                              trailing: Icon(
                                _selected == i ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: AppColors.primary,
                              ),
                              onTap: () => setState(() => _selected = i),
                            ),
                            const Divider(height: 1),
                          ],
                          for (int j = 0; j < _kOtherOptions.length; j++) ...[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(_kOtherOptions[j].icon, color: AppColors.primary),
                              title: Text(
                                _kOtherOptions[j].label,
                                style: AppTextStyles.subheading.copyWith(fontSize: 14),
                              ),
                              trailing: Icon(
                                _selected == _cards.length + j
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: AppColors.primary,
                              ),
                              onTap: () => setState(() => _selected = _cards.length + j),
                            ),
                            if (j != _kOtherOptions.length - 1) const Divider(height: 1),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: TextButton(
                        onPressed: _addCard,
                        child: Text(
                          'Add New Card',
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