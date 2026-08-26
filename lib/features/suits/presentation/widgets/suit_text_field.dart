// features/suits/presentation/widgets/suit_text_field.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class SuitTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDollar;
  final bool isMultiline;
  final TextInputType? keyboardType;
  final VoidCallback? onChanged;

  const SuitTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isDollar = false,
    this.isMultiline = false,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: isMultiline ? 12 : 0),
      constraints: BoxConstraints(minHeight: isMultiline ? 100 : 48),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: isMultiline ? Alignment.topLeft : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          if (isDollar) const Text('\$ ', style: AppTextStyles.body16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: isMultiline ? 5 : 1,
              minLines: isMultiline ? 3 : 1,
              style: AppTextStyles.body16,
              cursorColor: AppColors.accent,
              onChanged: (_) => onChanged?.call(),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: AppTextStyles.body16.copyWith(color: Colors.white38),
              ),
            ),
          ),
        ],
      ),
    );
  }
}