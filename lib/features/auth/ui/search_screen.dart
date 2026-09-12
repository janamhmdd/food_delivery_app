import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../domain/entities/menu_item.dart';
import '../domain/repositories/restaurant_repository.dart';
import '../logic/search_cubit.dart';
import '../logic/search_state.dart';
import 'favorite_heart_button.dart';
import 'item_details_screen.dart';

/// The API has no rating field — a stable, deterministic stand-in so the
/// same item always shows the same "rating" (matches CategoryItemsScreen).
double _pseudoRating(int itemId) => min(5.0, 3.5 + (itemId % 15) / 10);

/// Live search over the item catalog via the API's `ItemName` filter,
/// debounced 400ms so it doesn't fire a request per keystroke.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(getIt<RestaurantRepository>()),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 42,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(21)),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppColors.textSecondary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              onChanged: (q) => context.read<SearchCubit>().onQueryChanged(q),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search dishes...',
                                hintStyle: AppTextStyles.hint.copyWith(color: AppColors.textSecondary),
                              ),
                              style: AppTextStyles.body,
                            ),
                          ),
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _controller,
                            builder: (context, value, _) {
                              if (value.text.isEmpty) return const SizedBox.shrink();
                              return GestureDetector(
                                onTap: () {
                                  _controller.clear();
                                  context.read<SearchCubit>().onQueryChanged('');
                                },
                                child: Icon(Icons.close, color: AppColors.textSecondary, size: 18),
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
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case SearchStatus.idle:
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search, size: 56, color: AppColors.primary.withValues(alpha: 0.4)),
                              const SizedBox(height: 12),
                              Text('Search for a dish by name', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        );
                      case SearchStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case SearchStatus.error:
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.errorMessage ?? 'Something went wrong', style: AppTextStyles.body),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => context.read<SearchCubit>().onQueryChanged(state.query),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      case SearchStatus.success:
                        if (state.results.isEmpty) {
                          return Center(
                            child: Text('No dishes found for "${state.query}"', style: AppTextStyles.body),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                          itemCount: state.results.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 16),
                          itemBuilder: (context, index) => _SearchResultRow(item: state.results[index]),
                        );
                    }
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

class _SearchResultRow extends StatelessWidget {
  final MenuItem item;
  const _SearchResultRow({required this.item});

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
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 10)),
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