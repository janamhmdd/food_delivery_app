import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final Color backgroundColor;

  const AppBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      color: backgroundColor,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          top: 9,
          bottom: bottomPadding > 0 ? bottomPadding : 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_outlined),
            _buildNavItem(1, Icons.room_service_outlined),
            _buildNavItem(2, Icons.favorite_border_rounded),
            _buildNavItem(3, Icons.receipt_long_outlined),
            _buildNavItem(4, Icons.headset_mic_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: () => onTap?.call(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.9),
          size: 23,
        ),
      ),
    );
  }
}
