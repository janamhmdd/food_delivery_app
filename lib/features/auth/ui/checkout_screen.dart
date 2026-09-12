import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/entities/cart_line_item.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';
import 'order_summary_widgets.dart';
import 'payment_screen.dart';

const String kDefaultShippingAddress = '778 Locust View Drive Oakland, CA';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = kDefaultShippingAddress;
  bool _editingItems = false;

  Future<void> _editAddress() async {
    final controller = TextEditingController(text: _address);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Shipping Address'),
        content: TextField(controller: controller, maxLines: 2),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(controller.text.trim()), child: const Text('Save')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) setState(() => _address = result);
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
                  Expanded(child: Text('Confirm Order', textAlign: TextAlign.center, style: AppTextStyles.headerTitle)),
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
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping Address', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                            GestureDetector(onTap: _editAddress, child: const Icon(Icons.edit, size: 16, color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(12)),
                          child: Text(_address, style: AppTextStyles.body),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order Summary', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                            GestureDetector(
                              onTap: () => setState(() => _editingItems = !_editingItems),
                              child: Text('Edit', style: AppTextStyles.link),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...state.items.map((entry) => _CheckoutItemRow(entry: entry, editing: _editingItems)),
                        const SizedBox(height: 12),
                        PriceSummaryRow(label: 'Subtotal', value: state.subtotal),
                        PriceSummaryRow(label: 'Tax and Fees', value: state.tax),
                        PriceSummaryRow(label: 'Delivery', value: state.deliveryFee),
                        const Divider(height: 24),
                        PriceSummaryRow(label: 'Total', value: state.total, isTotal: true),
                        const SizedBox(height: 24),
                        AppButton(
                          text: 'Place Order',
                          onPressed: state.isEmpty
                              ? null
                              : () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => PaymentScreen(shippingAddress: _address)),
                                  ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckoutItemRow extends StatelessWidget {
  final CartLineItem entry;
  final bool editing;
  const _CheckoutItemRow({required this.entry, required this.editing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: entry.item.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 52, height: 52, color: AppColors.peachCircle),
              errorWidget: (_, __, ___) => Container(
                width: 52,
                height: 52,
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
                Text(entry.item.itemName, style: AppTextStyles.heading.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('\$${entry.item.itemPrice.toStringAsFixed(2)}', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                if (editing) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.read<CartCubit>().removeItem(entry.item.itemId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.peachCircle, borderRadius: BorderRadius.circular(14)),
                          child: Text('Cancel Order', style: AppTextStyles.body.copyWith(color: AppColors.primary, fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      QuantityMiniStepper(
                        quantity: entry.quantity,
                        onChanged: (q) => context.read<CartCubit>().updateQuantity(entry.item.itemId, q),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}