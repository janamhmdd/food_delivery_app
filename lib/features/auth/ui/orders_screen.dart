import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/order_record.dart';
import '../logic/orders_cubit.dart';
import '../logic/orders_state.dart';
import 'cancel_order_screen.dart';
import 'leave_review_screen.dart';
import 'live_tracking_screen.dart';
import 'order_details_screen.dart';
const _kMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatOrderDate(DateTime dt) {
  final period = dt.hour >= 12 ? 'pm' : 'am';
  final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${_kMonths[dt.month - 1]}, '
      '${hour12.toString().padLeft(2, '0')}:$minute $period';
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _Header(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                      child: _StatusTabs(
                        selected: _selectedTab,
                        onSelect: (i) => setState(() => _selectedTab = i),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<OrdersCubit, OrdersState>(
                        builder: (context, state) {
                          if (state.status == OrdersStatus.loading) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final orders = switch (_selectedTab) {
                            1 => state.completed,
                            2 => state.cancelled,
                            _ => state.active,
                          };
                          if (orders.isEmpty) {
                            return Center(
                              child: Text(
                                _emptyMessageFor(_selectedTab),
                                style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                            itemCount: orders.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 14),
                            itemBuilder: (context, index) => _OrderCard(order: orders[index]),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 3,
        onTap: (index) => handleBottomNavTap(context, index, 3),
      ),
    );
  }

  String _emptyMessageFor(int tab) {
    switch (tab) {
      case 1:
        return 'No completed orders yet';
      case 2:
        return 'No cancelled orders';
      default:
        return 'No active orders';
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          Expanded(
            child: Text('My Orders', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }
}

class _StatusTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _StatusTabs({required this.selected, required this.onSelect});

  static const _labels = ['Active', 'Completed', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (index) {
        final isSelected = selected == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.peachCircle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _labels[index],
                style: AppTextStyles.body.copyWith(
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderRecord order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
      ),
      child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: order.imageUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(width: 64, height: 64, color: AppColors.peachCircle),
                  errorWidget: (_, _, _) => Container(
                    width: 64,
                    height: 64,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order.title,
                            style: AppTextStyles.heading.copyWith(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(2)}',
                          style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatOrderDate(order.placedAt),
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.itemCount == 1 ? '1 item' : '${order.itemCount} items',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                    ),
                    if (order.status != OrderLocalStatus.active) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            order.status == OrderLocalStatus.completed
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            order.status == OrderLocalStatus.completed
                                ? 'Order delivered'
                                : 'Order cancelled',
                            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (order.status == OrderLocalStatus.active) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _OrderActionButton(
                    label: 'Cancel Order',
                    filled: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => CancelOrderScreen(orderId: order.id)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OrderActionButton(
                    label: 'Track Driver',
                    filled: true,
                  onTap: () => Navigator.push(
                   context,
                     MaterialPageRoute(builder: (_) => LiveTrackingScreen(order: order)),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (order.status == OrderLocalStatus.completed) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _OrderActionButton(
                    label: 'Leave a review',
                    filled: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LeaveReviewScreen(order: order)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _OrderActionButton(
                    label: 'Order Again',
                    filled: true,
                    onTap: () async {
                      final success = await context.read<OrdersCubit>().reorder(order);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(success ? 'Order placed again!' : 'Please log in to reorder.'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
     ),
    );
  }
}

class _OrderActionButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onTap;
  const _OrderActionButton({required this.label, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.peachCircle,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: filled ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}