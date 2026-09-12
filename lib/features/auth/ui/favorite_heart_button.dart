import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_colors.dart';
import '../domain/entities/menu_item.dart';
import '../logic/favorites_cubit.dart';
import '../logic/favorites_state.dart';

/// Small circular heart toggle backed by the shared [FavoritesCubit].
/// Drop it inside a Stack (e.g. Positioned over a food image).
class FavoriteHeartButton extends StatelessWidget {
  final MenuItem item;
  final double size;

  const FavoriteHeartButton({super.key, required this.item, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (previous, current) =>
          previous.isFavorite(item.itemId) != current.isFavorite(item.itemId),
      builder: (context, state) {
        final isFavorite = state.isFavorite(item.itemId);
        return GestureDetector(
          onTap: () => context.read<FavoritesCubit>().toggleFavorite(item),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              size: size,
              color: isFavorite ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        );
      },
    );
  }
}