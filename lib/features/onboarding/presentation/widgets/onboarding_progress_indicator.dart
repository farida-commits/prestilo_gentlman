// features/onboarding/presentation/widgets/onboarding_progress_indicator.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class OnboardingProgressIndicator extends StatelessWidget {
  final int totalPages;
  final int currentPage;

  const OnboardingProgressIndicator({
    super.key,
    required this.totalPages,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPages, (index) {
        final bool isActive = index == currentPage;

        if (isActive) {
          return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}