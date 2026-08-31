// features/suits/presentation/widgets/suit_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/capitalize_formatter.dart';

class SuitTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDollar;
  final bool isMultiline;
  final bool isNumberOnly;
  final TextInputType? keyboardType;
  final VoidCallback? onChanged;
  final bool capitalizeFirstLetter;

  const SuitTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isDollar = false,
    this.isMultiline = false,
    this.isNumberOnly = false,
    this.keyboardType,
    this.onChanged,
    this.capitalizeFirstLetter = true,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = [];

    if (isDollar || isNumberOnly) {
      formatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (capitalizeFirstLetter) {
      formatters.add(CapitalizeFirstLetterFormatter());
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: isMultiline ? 12 : 0,
      ),
      constraints: BoxConstraints(minHeight: isMultiline ? 44 : 44),
      decoration: BoxDecoration(
        color: AppColors.bmain,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: isMultiline ? Alignment.topLeft : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: isMultiline
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (isDollar) const Text('\$ ', style: AppTextStyles.body16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: (isDollar || isNumberOnly) ? TextInputType.number : keyboardType,
              inputFormatters: formatters,
              maxLines: isMultiline ? 7 : 1,
              minLines: isMultiline ? 1 : 1,
              style: AppTextStyles.body16,
              cursorColor: AppColors.accent,
              onChanged: (_) => onChanged?.call(),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: hint,
                hintStyle: AppTextStyles.body16.copyWith(
                  color: Color(0xff454954),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
