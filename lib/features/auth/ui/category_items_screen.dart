import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../logic/category_items_cubit.dart';
import '../logic/category_items_state.dart';
import '../logic/filter_categories.dart';
import 'item_details_screen.dart';
import 'search_screen.dart';
import '../../../core/routing/bottom_nav_handler.dart';
import 'favorite_heart_button.dart';

double _pseudoRating(int itemId) => min(5.0, 3.5 + (itemId % 15) / 10);

class CategoryItemsScreen extends StatelessWidget {
  final String category;
  const CategoryItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryItemsCubit(getIt<RestaurantRepository>(), category)..fetch(),
      child: const _CategoryItemsView(),
    );
  }
}

class _CategoryItemsView extends StatefulWidget {
  const _CategoryItemsView();

  @override
  State<_CategoryItemsView> createState() => _CategoryItemsViewState();
}

class _CategoryItemsViewState extends State<_CategoryItemsView> {
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: BlocBuilder<CategoryItemsCubit, CategoryItemsState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          child: _CategoryRow(
                            selected: state.category,
                            onSelect: (cat) => context.read<CategoryItemsCubit>().switchCategory(cat),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Text('Sort By ', style: AppTextStyles.body.copyWith(fontSize: 13)),
                              Text('Popular', style: AppTextStyles.link.copyWith(fontSize: 13)),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                                onPressed: () => setState(() => _sortAscending = !_sortAscending),
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: _Body(state: state, sortAscending: _sortAscending)),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: 1,
        onTap: (index) => handleBottomNavTap(context, index, 1),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final CategoryItemsState state;
  final bool sortAscending;
  const _Body({required this.state, required this.sortAscending});

  @override
  Widget build(BuildContext context) {
    switch (state.status) {
      case CategoryItemsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case CategoryItemsStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.errorMessage ?? 'Something went wrong', style: AppTextStyles.body),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.read<CategoryItemsCubit>().fetch(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case CategoryItemsStatus.success:
        if (state.items.isEmpty) {
          return Center(
            child: Text('No items found for ${state.category}', style: AppTextStyles.body),
          );
        }
        final items = List.of(state.items)
          ..sort((a, b) => sortAscending
              ? a.itemPrice.compareTo(b.itemPrice)
              : b.itemPrice.compareTo(a.itemPrice));
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _ItemRow(item: items[index]),
        );
    }
  }
}

class _ItemRow extends StatelessWidget {
  final MenuItem item;
  const _ItemRow({required this.item});

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
           width: 90,
             height: 90,
              child: Stack(
               children: [
                ClipRRect(
                borderRadius: BorderRadius.circular(14),
                 child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                   width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(width: 90, height: 90, color: AppColors.peachCircle),
                   errorWidget: (_, _, _) => Container(
                    width: 90,
                   height: 90,
                color: AppColors.peachCircle,
            child: Icon(Icons.fastfood, color: AppColors.primary),
          ),
        ),
      ),
      Positioned(top: 2, right: 2, child: FavoriteHeartButton(item: item, size: 12)),
    ],
  ),
),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: AppTextStyles.heading.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(rating.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white, fontSize: 10)),
                          const Icon(Icons.star, color: Colors.white, size: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.itemDescription,
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.itemPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
              child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Search', style: AppTextStyles.hint.copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.filter),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.tune, size: 16, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline, size: 16, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _CategoryRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: kTopCategories.map((cat) {
        final isSelected = cat.label == selected;
        return GestureDetector(
          onTap: () => onSelect(cat.label),
          child: Column(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: isSelected ? AppColors.primary : AppColors.peachCircle,
                child: Icon(cat.icon, color: isSelected ? Colors.white : AppColors.primary, size: 20),
              ),
              const SizedBox(height: 4),
              Text(cat.label, style: AppTextStyles.body.copyWith(fontSize: 11)),
            ],
          ),
        );
      }).toList(),
    );
  }
}