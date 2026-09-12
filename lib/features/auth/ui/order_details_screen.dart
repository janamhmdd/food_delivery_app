import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/entities/order_line_item.dart';
import '../domain/entities/order_record.dart';
import '../logic/orders_cubit.dart';
import '../domain/pricing_constants.dart';
// The API has no subtotal/tax/delivery breakdown, so these are fixed local
// display rules rather than server data — flag this if you want them to
// vary per restaurant/order later.

class OrderDetailsScreen extends StatefulWidget {
  final OrderRecord order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late List<int> _quantities;

  @override
  void initState() {
    super.initState();
    _quantities = widget.order.lineItems.map((i) => i.quantity).toList();
  }

  double get _unitPrice => widget.order.itemCount > 0
      ? widget.order.totalPrice / widget.order.itemCount
      : widget.order.totalPrice;

  double get _subtotal {
    final totalQty = _quantities.fold<int>(0, (sum, q) => sum + q);
    return _unitPrice * totalQty;
  }

  double get _tax => _subtotal * kTaxRate;
  double get _total => _subtotal + _tax + kDeliveryFee;

  String get _orderNumber {
    final n = widget.order.id.hashCode.abs() % 1000000;
    return n.toString().padLeft(7, '0');
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
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
                    child: Text('Order Details', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('Order No. $_orderNumber', style: AppTextStyles.heading.copyWith(fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(
                      _formatOrderDate(order.placedAt),
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(order.lineItems.length, (index) {
                      final line = order.lineItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: order.imageUrl,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(width: 56, height: 56, color: AppColors.peachCircle),
                                errorWidget: (_, _, _) => Container(
                                  width: 56,
                                  height: 56,
                                  color: AppColors.peachCircle,
                                  child: Icon(Icons.fastfood, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(line.itemName, style: AppTextStyles.heading.copyWith(fontSize: 14)),
                                  const SizedBox(height: 2),
                                  Text(
                                    '\$${_unitPrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            _QuantityStepper(
                              quantity: _quantities[index],
                              onChanged: (q) => setState(() => _quantities[index] = q),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(height: 24),
                    _SummaryRow(label: 'Subtotal', value: _subtotal),
                    _SummaryRow(label: 'Tax and Fees', value: _tax),
                    _SummaryRow(label: 'Delivery', value: kDeliveryFee),
                    const Divider(height: 24),
                    _SummaryRow(label: 'Total', value: _total, isTotal: true),
                    const SizedBox(height: 24),
                    AppButton(
                      text: 'Order Again',
                      onPressed: () async {
                        final overrideItems = List<OrderLineItem>.generate(
                          order.lineItems.length,
                          (i) => OrderLineItem(itemName: order.lineItems[i].itemName, quantity: _quantities[i]),
                        );
                        final success = await context
                            .read<OrdersCubit>()
                            .reorder(order, lineItemsOverride: overrideItems);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Order placed again!' : 'Please log in to reorder.')),
                        );
                      },
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

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StepButton(icon: Icons.remove, onTap: quantity > 1 ? () => onChanged(quantity - 1) : null),
        SizedBox(
          width: 24,
          child: Text('$quantity', textAlign: TextAlign.center, style: AppTextStyles.heading.copyWith(fontSize: 14)),
        ),
        _StepButton(icon: Icons.add, onTap: () => onChanged(quantity + 1)),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.peachCircle, borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, size: 14, color: onTap == null ? AppColors.textSecondary : AppColors.primary),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isTotal;
  const _SummaryRow({required this.label, required this.value, this.isTotal = false});

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

String _formatOrderDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final period = dt.hour >= 12 ? 'pm' : 'am';
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${months[dt.month - 1]}, ${hour12.toString().padLeft(2, '0')}:$minute $period';
}