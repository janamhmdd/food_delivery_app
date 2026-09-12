import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';

/// Shared price-breakdown row used by Cart, Checkout, and Payment.
class PriceSummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  const PriceSummaryRow({super.key, required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? AppTextStyles.heading.copyWith(fontSize: 15)
        : AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 13);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: isTotal ? style.copyWith(color: AppColors.primary) : style),
        ],
      ),
    );
  }
}

/// Shared tiny +/- quantity stepper used by Cart and Checkout.
class QuantityMiniStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const QuantityMiniStepper({super.key, required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniStepButton(icon: Icons.remove, onTap: () => onChanged(quantity - 1)),
        SizedBox(
          width: 24,
          child: Text('$quantity', textAlign: TextAlign.center, style: AppTextStyles.heading.copyWith(fontSize: 14)),
        ),
        _MiniStepButton(icon: Icons.add, onTap: () => onChanged(quantity + 1)),
      ],
    );
  }
}

class _MiniStepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MiniStepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.peachCircle, borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 14, color: AppColors.primary),
      ),
    );
  }
}