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
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 16,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: !enabled
                  ? Colors.white.withOpacity(0.25)
                  : (isActive ? AppColors.accent : Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 2,
              width: 20,
              color: AppColors.accent,
            ),
        ],
      ),
    );
  }
}