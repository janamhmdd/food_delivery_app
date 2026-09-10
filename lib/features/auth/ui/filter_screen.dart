import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_text_styles.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../logic/filter_categories.dart';
import '../logic/filter_cubit.dart';
import '../logic/filter_state.dart';

class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterCubit(),
      child: const _FilterView(),
    );
  }
}

class _FilterView extends StatelessWidget {
  const _FilterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  final cubit = context.read<FilterCubit>();
                  final currentTop = kTopCategories.firstWhere(
                    (c) => c.label == state.topCategory,
                    orElse: () => kTopCategories.first,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SectionTitle('Categories'),
                      const SizedBox(height: 12),
                      _TopCategoryRow(
                        selected: state.topCategory,
                        onSelect: cubit.selectTopCategory,
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 16),
                      const _SectionTitle('Sort by'),
                      const SizedBox(height: 8),
                      _RatingRow(
                        rating: state.ratingFilter,
                        onSelect: cubit.setRating,
                      ),
                      const SizedBox(height: 16),
                      Divider(height: 1, color: AppColors.border),
                      const SizedBox(height: 16),
                      const _SectionTitle('Categories'),
                      const SizedBox(height: 12),
                      _SubCategoryWrap(
                        subCategories: currentTop.subCategories,
                        selected: state.selectedSubCategories,
                        onToggle: cubit.toggleSubCategory,
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle('Price'),
                      _PriceSlider(
                        value: state.priceStop,
                        onChanged: cubit.setPriceStop,
                      ),
                      const SizedBox(height: 12),
                      AppButton(
                        text: 'Apply',
                        onPressed: () {
                          final filter = cubit.buildFilter();
                          Navigator.of(context).pop<RestaurantFilter>(filter);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
          ),
          const AppBottomNavBar(selectedIndex: 1),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.headerYellow,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 8,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Filter',
              textAlign: TextAlign.center,
              style: AppTextStyles.headerTitle,
            ),
          ),
          _CircleIcon(icon: Icons.shopping_cart_outlined),
          const SizedBox(width: 8),
          _CircleIcon(icon: Icons.person_outline),
        ],
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: Icon(icon, color: AppColors.primary, size: 18),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.heading.copyWith(fontSize: 18),
    );
  }
}

class _TopCategoryRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _TopCategoryRow({required this.selected, required this.onSelect});

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
                radius: 26,
                backgroundColor: isSelected ? AppColors.primary : AppColors.peachCircle,
                child: Icon(
                  cat.icon,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                cat.label,
                style: AppTextStyles.body.copyWith(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RatingRow extends StatelessWidget {
  final int rating; // 0..5
  final ValueChanged<int> onSelect;
  const _RatingRow({required this.rating, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Top Rated', style: AppTextStyles.body),
        const SizedBox(width: 10),
        ...List.generate(5, (i) {
          final starIndex = i + 1;
          return IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(
              starIndex <= rating ? Icons.star : Icons.star_border,
              color: AppColors.primary,
              size: 22,
            ),
            onPressed: () => onSelect(starIndex),
          );
        }),
      ],
    );
  }
}

class _SubCategoryWrap extends StatelessWidget {
  final List<String> subCategories;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _SubCategoryWrap({
    required this.subCategories,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: subCategories.map((label) {
        final isSelected = selected.contains(label);
        return GestureDetector(
          onTap: () => onToggle(label),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.peachCircle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? Colors.white : AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PriceSlider extends StatelessWidget {
  final double value; // 0..3
  final ValueChanged<double> onChanged;
  const _PriceSlider({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.peachCircle,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            min: 0,
            max: 3,
            divisions: 3,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: kPriceStops
                .map((label) => Text(label, style: AppTextStyles.body.copyWith(fontSize: 12)))
                .toList(),
          ),
        ),
      ],
    );
  }
}