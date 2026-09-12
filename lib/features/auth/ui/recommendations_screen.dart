import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../logic/cart_cubit.dart';
import '../logic/items_list_cubit.dart';
import '../logic/items_list_state.dart';
import 'item_details_screen.dart';

/// The API has no rating field — a stable, deterministic stand-in so the
/// same item always shows the same "rating" (matches CategoryItemsScreen).
double _pseudoRating(int itemId) => min(5.0, 3.5 + (itemId % 15) / 10);

/// Figma "Recommendations" (frame 8). The first item is featured full-width
/// with a "New Product" tag, the rest sit in a 2-column grid — both with a
/// local quantity stepper and an add-to-cart button.
class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsListCubit(getIt<RestaurantRepository>())..fetch(),
      child: const _RecommendationsView(),
    );
  }
}

class _RecommendationsView extends StatelessWidget {
  const _RecommendationsView();

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
                    child: Text('Recommendations', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                child: BlocBuilder<ItemsListCubit, ItemsListState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case ItemsListStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case ItemsListStatus.error:
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.errorMessage ?? 'Something went wrong', style: AppTextStyles.body),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => context.read<ItemsListCubit>().fetch(),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      case ItemsListStatus.success:
                        if (state.items.isEmpty) {
                          return Center(child: Text('No items available', style: AppTextStyles.body));
                        }
                        final items = state.items;
                        final featured = items.first;
                        final rest = items.skip(1).toList();
                        return CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                              sliver: SliverToBoxAdapter(
                                child: Text(
                                  'Discover the dishes recommended by the chef.',
                                  style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                              sliver: SliverToBoxAdapter(child: _FeaturedCard(item: featured)),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              sliver: SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.78,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _GridCard(item: rest[index]),
                                  childCount: rest.length,
                                ),
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 0,
        onTap: (index) => handleBottomNavTap(context, index, 0),
      ),
    );
  }
}

/// Small "-  qty  +  cart" row shared by the featured card and the grid
/// cards. Quantity is local to the widget; tapping cart adds that many.
class _QuantityAddRow extends StatefulWidget {
  final MenuItem item;
  const _QuantityAddRow({required this.item});

  @override
  State<_QuantityAddRow> createState() => _QuantityAddRowState();
}

class _QuantityAddRowState extends State<_QuantityAddRow> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => setState(() => _quantity = _quantity > 1 ? _quantity - 1 : 1),
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: AppColors.peachCircle, shape: BoxShape.circle),
            child: const Icon(Icons.remove, size: 12, color: AppColors.primary),
          ),
        ),
        SizedBox(
          width: 22,
          child: Text('$_quantity', textAlign: TextAlign.center, style: AppTextStyles.body.copyWith(fontSize: 12)),
        ),
        GestureDetector(
          onTap: () => setState(() => _quantity++),
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.add, size: 12, color: Colors.white),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () {
            context.read<CartCubit>().addItem(widget.item, quantity: _quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${widget.item.itemName} added to cart'), duration: const Duration(seconds: 1)),
            );
          },
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.shopping_cart_outlined, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final MenuItem item;
  const _FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final rating = _pseudoRating(item.itemId);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            height: 110,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(width: 110, height: 110, color: AppColors.peachCircle),
                    errorWidget: (_, _, _) => Container(
                      width: 110,
                      height: 110,
                      color: AppColors.peachCircle,
                      child: Icon(Icons.fastfood, color: AppColors.primary),
                    ),
                  ),
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10)),
                        const Icon(Icons.star, color: Colors.white, size: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                  child: const Text('New Product', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
                const SizedBox(height: 6),
                Text(item.itemName, style: AppTextStyles.heading.copyWith(fontSize: 14), maxLines: 2),
                const SizedBox(height: 4),
                Text(
                  item.itemDescription,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${item.itemPrice.toStringAsFixed(2)}',
                      style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 15),
                    ),
                    const Spacer(),
                    _QuantityAddRow(item: item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final MenuItem item;
  const _GridCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final rating = _pseudoRating(item.itemId);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemDetailsScreen(item: item)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(color: AppColors.peachCircle),
                    errorWidget: (_, _, _) => Container(
                      color: AppColors.peachCircle,
                      child: Icon(Icons.fastfood, color: AppColors.primary),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 9)),
                          const Icon(Icons.star, color: Colors.white, size: 9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.itemName,
            style: AppTextStyles.heading.copyWith(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            item.itemDescription,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                '\$${item.itemPrice.toStringAsFixed(2)}',
                style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 13),
              ),
              const Spacer(),
              _QuantityAddRow(item: item),
            ],
          ),
        ],
      ),
    );
  }
}