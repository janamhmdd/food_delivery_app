import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../domain/entities/cart_line_item.dart';
import '../logic/cart_cubit.dart';
import '../logic/cart_state.dart';
import 'checkout_screen.dart';
import 'order_summary_widgets.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text('Cart', style: AppTextStyles.headerTitle),
                      ],
                    ),
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
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    if (state.isEmpty) return const _EmptyCart();
                    return _CartList(state: state);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: -1,
        onTap: (index) => handleBottomNavTap(context, index, -1),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your cart is empty', style: AppTextStyles.heading.copyWith(fontSize: 16)),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
                child: Icon(Icons.add, color: AppColors.primary, size: 40),
              ),
            ),
            const SizedBox(height: 16),
            Text('Want To Add Something?', style: AppTextStyles.heading.copyWith(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  final CartState state;
  const _CartList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(
            'You have ${state.itemCount} item${state.itemCount == 1 ? '' : 's'} in the cart',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _CartRow(entry: state.items[index]),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
          child: Column(
            children: [
              PriceSummaryRow(label: 'Subtotal', value: state.subtotal),
              PriceSummaryRow(label: 'Tax and Fees', value: state.tax),
              PriceSummaryRow(label: 'Delivery', value: state.deliveryFee),
              const Divider(height: 20),
              PriceSummaryRow(label: 'Total', value: state.total, isTotal: true),
              const SizedBox(height: 16),
              AppButton(
                text: 'Checkout',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartLineItem entry;
  const _CartRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: entry.item.imageUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(width: 56, height: 56, color: AppColors.peachCircle),
              errorWidget: (_, __, ___) => Container(
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
                Text(entry.item.itemName, style: AppTextStyles.heading.copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('\$${entry.item.itemPrice.toStringAsFixed(2)}', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          QuantityMiniStepper(
            quantity: entry.quantity,
            onChanged: (q) => context.read<CartCubit>().updateQuantity(entry.item.itemId, q),
          ),
        ],
      ),
    );
  }
}