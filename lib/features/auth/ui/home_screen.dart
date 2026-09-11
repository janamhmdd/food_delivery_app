import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/routing/routes.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../domain/entities/menu_item.dart';
import '../logic/filter_categories.dart';
import '../logic/home_cubit.dart';
import '../logic/home_state.dart';
import 'category_items_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..fetchHomeData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerYellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HeaderSection(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case HomeStatus.loading:
                      case HomeStatus.initial:
                        return const Center(child: CircularProgressIndicator());
                      case HomeStatus.error:
                        return _ErrorView(
                          message: state.errorMessage ?? 'Something went wrong',
                          onRetry: () => context.read<HomeCubit>().fetchHomeData(),
                        );
                      case HomeStatus.success:
                        return RefreshIndicator(
                          onRefresh: () => context.read<HomeCubit>().fetchHomeData(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _CategoryRow(
                                  selected: state.selectedCategory,
                                  onSelect: (cat) {
                                    context.read<HomeCubit>().selectCategory(cat);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryItemsScreen(category: cat),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                _SectionHeader(
                                  title: 'Best Seller',
                                  onViewAll: () {}, // wire to a full item-list screen if you build one
                                ),
                                const SizedBox(height: 12),
                                _BestSellerRow(items: state.bestSellers),
                                const SizedBox(height: 20),
                                const _PromoBanner(),
                                const SizedBox(height: 20),
                                const _SectionTitle('Recommend'),
                                const SizedBox(height: 12),
                                _RecommendRow(items: state.recommended),
                              ],
                            ),
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(selectedIndex: 0),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Search',
                          style: AppTextStyles.hint.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.filter),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primary,
                          child: const Icon(Icons.tune, color: Colors.white, size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _HeaderCircleIcon(icon: Icons.shopping_cart_outlined, onTap: () {}),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.notifications_none,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                ),
              ),
              const SizedBox(width: 8),
              _HeaderCircleIcon(
                icon: Icons.person_outline,
                onTap: () => Navigator.pushNamed(context, Routes.profile),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text('Good Morning', style: AppTextStyles.headerTitle.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            "Rise And Shine! It's Breakfast Time",
            style: AppTextStyles.body.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}

class _HeaderCircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderCircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white,
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
    );
  }
}

/// Tapping a chip is cosmetic for now — see HomeCubit.selectCategory for why
/// (the items endpoint has no category field to actually filter these by).
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
                radius: 24,
                backgroundColor: isSelected ? AppColors.primary : AppColors.peachCircle,
                child: Icon(cat.icon, color: isSelected ? Colors.white : AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(cat.label, style: AppTextStyles.body.copyWith(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.heading.copyWith(fontSize: 18));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SectionTitle(title),
        GestureDetector(
          onTap: onViewAll,
          child: Row(
            children: [
              Text('View All', style: AppTextStyles.link),
              Icon(Icons.chevron_right, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

/// Image, name and price are real API data (MenuItem.imageUrl/itemPrice).
class _BestSellerRow extends StatelessWidget {
  final List<MenuItem> items;
  const _BestSellerRow({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('No items available', style: AppTextStyles.body);
    }
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _FoodCard(item: items[index], width: 100),
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final MenuItem item;
  final double width;
  const _FoodCard({required this.item, required this.width});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: item.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: AppColors.peachCircle),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.peachCircle,
                child: Icon(Icons.fastfood, color: AppColors.primary),
              ),
            ),
            Positioned(
              left: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '\$${item.itemPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Static marketing content — not from the API, just matching the Figma banner.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height:120,
            child: Image.asset(
              'assets/images/Promo.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Experience our delicious new dish',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '30% OFF',
                  style: AppTextStyles.headerTitle.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Image, name and price are real API data. The 5.0 star badge and heart
/// icon are decorative — the API has no rating or favorites field, so they
/// don't do anything yet. Wire the heart to local/shared-prefs state if you
/// want a working favorites list without backend support.
class _RecommendRow extends StatelessWidget {
  final List<MenuItem> items;
  const _RecommendRow({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text('No items available', style: AppTextStyles.body);
    }
    return Row(
      children: items
          .map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: AspectRatio(
                    aspectRatio: 0.85,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppColors.peachCircle),
                            errorWidget: (_, __, ___) => Container(
                              color: AppColors.peachCircle,
                              child: Icon(Icons.fastfood, color: AppColors.primary),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            left: 6,
                            child: _Badge(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text('5.0', style: TextStyle(fontSize: 10)),
                                  Icon(Icons.star, size: 12, color: Colors.amber),
                                ],
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 6,
                            right: 6,
                            child: _Badge(child: Icon(Icons.favorite_border, size: 14)),
                          ),
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                ),
              ))
          .toList(),
    );
  }
}

class _Badge extends StatelessWidget {
  final Widget child;
  const _Badge({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: AppTextStyles.body, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}