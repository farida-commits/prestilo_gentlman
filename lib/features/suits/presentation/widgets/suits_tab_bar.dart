// features/suits/presentation/widgets/suits_tab_bar.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

enum SuitFilter { all, inStock, leased }

class SuitsTabBar extends StatelessWidget {
  final SuitFilter selected;
  final bool leasedEnabled;
  final ValueChanged<SuitFilter> onChanged;

  const SuitsTabBar({
    super.key,
    required this.selected,
    required this.leasedEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tab(context, 'All', SuitFilter.all, true),
        const SizedBox(width: 20),
        _tab(context, 'In stock', SuitFilter.inStock, true),
        const SizedBox(width: 20),
        _tab(context, 'Leased', SuitFilter.leased, leasedEnabled),
      ],
    );
  }

  Widget _tab(BuildContext context, String label, SuitFilter value, bool enabled) {
    final bool isActive = selected == value;
    return GestureDetector(
      onTap: enabled ? () => onChanged(value) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: !enabled
                  ? Colors.white
                  : (isActive ? AppColors.accent : Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Builder(
              builder: (context) {
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 21,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                )..layout();
                return Container(
                  height: 2,
                  width: textPainter.width,
                  color: AppColors.accent,
                );
              },
            ),
        ],
      ),
    );
  }
}