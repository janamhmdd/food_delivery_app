import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';
import '../logic/orders_cubit.dart';
import 'order_confirmed_screen.dart';

const List<String> _kPaymentMethods = ['Credit Card', 'Cash on Delivery', 'PayPal'];

class PaymentScreen extends StatefulWidget {
  final String shippingAddress;
  const PaymentScreen({super.key, required this.shippingAddress});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = 'Credit Card';
  bool _isPaying = false;

  Future<void> _editPaymentMethod() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Payment Method'),
        children: _kPaymentMethods
            .map((m) => SimpleDialogOption(onPressed: () => Navigator.of(context).pop(m), child: Text(m)))
            .toList(),
      ),
    );
    if (result != null) setState(() => _paymentMethod = result);
  }

  Future<void> _pay() async {
    setState(() => _isPaying = true);
    final error = await context.read<CartCubit>().checkout();
    if (!mounted) return;
    setState(() => _isPaying = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final order = context.read<OrdersCubit>().state.orders.first;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderConfirmedScreen(order: order)));
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
                  Expanded(child: Text('Payment', textAlign: TextAlign.center, style: AppTextStyles.headerTitle)),
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
                        Text('Shipping Address', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.fieldFill, borderRadius: BorderRadius.circular(12)),
                          child: Text(widget.shippingAddress, style: AppTextStyles.body),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order Summary', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                            Text('\$${state.total.toStringAsFixed(2)}', style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...state.items.map((e) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${e.item.itemName}   ${e.quantity} item${e.quantity == 1 ? '' : 's'}',
                                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            )),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Method', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                            GestureDetector(onTap: _editPaymentMethod, child: Text('Edit', style: AppTextStyles.link)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.credit_card, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Text(
                              _paymentMethod == 'Credit Card' ? 'Credit Card  •••• 4242' : _paymentMethod,
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Time', style: AppTextStyles.heading.copyWith(fontSize: 15)),
                                Text('Estimated Delivery', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12)),
                              ],
                            ),
                            Text('25 mins', style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        AppButton(text: 'Pay Now', onPressed: _pay, isLoading: _isPaying),
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