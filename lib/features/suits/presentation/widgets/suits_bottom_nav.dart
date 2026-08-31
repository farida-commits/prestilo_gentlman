// features/suits/presentation/widgets/suits_bottom_nav.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SuitsBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const SuitsBottomNav({
    super.key, 
    required this.currentIndex, 
    required this.onTap
    });

   static const List<String> _icons = [
    'assets/images/suits.png',
    'assets/images/rental.png',
    'assets/images/statistics.png',
    'assets/images/settings.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final bool isActive = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.bmain,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Image.asset(
              _icons[index],
              width: 32,
              height: 32,
            )
          ),
        );
      }),
    );
  }
}