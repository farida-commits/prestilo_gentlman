// features/suits/presentation/widgets/required_field_label.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class RequiredFieldLabel extends StatelessWidget {
  final String text;
  final bool isFilled;

  const RequiredFieldLabel({super.key, required this.text, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: AppTextStyles.caption12),
        if (!isFilled) ...[
          const SizedBox(width: 4),
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}