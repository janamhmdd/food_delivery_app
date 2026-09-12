import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../logic/cart_cubit.dart';
import '../logic/items_list_cubit.dart';
import '../logic/items_list_state.dart';
import 'favorite_heart_button.dart';
import 'item_details_screen.dart';

/// The API has no rating field — a stable, deterministic stand-in so the
/// same item always shows the same "rating" (matches CategoryItemsScreen).
double _pseudoRating(int itemId) => min(5.0, 3.5 + (itemId % 15) / 10);

/// Figma "Best Seller" (frame 6). Shows the whole catalog sorted by price
/// descending — the same ranking Home uses to pick its 4-item preview.
class BestSellerScreen extends StatelessWidget {
  const BestSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemsListCubit(getIt<RestaurantRepository>())..fetch(),
      child: const _BestSellerView(),
    );
  }
}

class _BestSellerView extends StatelessWidget {
  const _BestSellerView();

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
                    child: Text('Best Seller', textAlign: TextAlign.center, style: AppTextStyles.headerTitle),
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
                        final items = List.of(state.items)
                          ..sort((a, b) => b.itemPrice.compareTo(a.itemPrice));
                        return CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                              sliver: SliverToBoxAdapter(
                                child: Text(
                                  'Discover our most popular dishes!',
                                  style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 16),
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                              sliver: SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 14,
                                  childAspectRatio: 0.72,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _BestSellerCard(item: items[index]),
                                  childCount: items.length,
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

class _BestSellerCard extends StatelessWidget {
  final MenuItem item;
  const _BestSellerCard({required this.item});

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
            aspectRatio: 1.15,
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
                  Positioned(top: 6, right: 6, child: FavoriteHeartButton(item: item, size: 12)),
                  Positioned(
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        '\$${item.itemPrice.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.itemName,
                  style: AppTextStyles.heading.copyWith(fontSize: 13.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 9)),
                    const Icon(Icons.star, color: Colors.white, size: 9),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.itemDescription,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CartCubit>().addItem(item);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.itemName} added to cart'), duration: const Duration(seconds: 1)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}