import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../logic/orders_cubit.dart';
import 'cancel_confirmation_screen.dart';

const List<String> _kCancelReasons = [
  'Ordered by mistake',
  'Delivery is taking too long',
  'Changed my mind',
  'Found a better price elsewhere',
  'Item is no longer needed',
];

class CancelOrderScreen extends StatefulWidget {
  final String orderId;
  const CancelOrderScreen({super.key, required this.orderId});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  String? _selectedReason;
  final _othersController = TextEditingController();

  @override
  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _othersController.text.trim().isNotEmpty
        ? _othersController.text.trim()
        : _selectedReason;

    if (reason == null || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a reason.')),
      );
      return;
    }

    context.read<OrdersCubit>().cancelOrder(widget.orderId, reason);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CancelConfirmationScreen()),
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
                    child: Text('Cancel Order', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please let us know why you'd like to cancel your order. "
                        "This helps us improve our service.",
                        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ..._kCancelReasons.map(
                        (reason) => _ReasonRow(
                          label: reason,
                          isSelected: _selectedReason == reason,
                          onTap: () => setState(() {
                            _selectedReason = reason;
                            _othersController.clear();
                          }),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Others', style: AppTextStyles.fieldLabel),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _othersController,
                        maxLines: 3,
                        onChanged: (_) => setState(() => _selectedReason = null),
                        decoration: InputDecoration(
                          hintText: 'Others reason...',
                          filled: true,
                          fillColor: AppColors.fieldFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(text: 'Submit', onPressed: _submit),
                      const SizedBox(height: 20),
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

class _ReasonRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _ReasonRow({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.body)),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}