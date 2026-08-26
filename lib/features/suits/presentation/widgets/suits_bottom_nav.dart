// features/suits/presentation/widgets/suits_bottom_nav.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SuitsBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SuitsBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _icons = [
    Icons.checkroom, // Suits
    Icons.receipt_long, // Rental history
    Icons.bar_chart, // Statistics
    Icons.tune, // Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_icons.length, (index) {
        final bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _icons[index],
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      }),
    );
  }
}