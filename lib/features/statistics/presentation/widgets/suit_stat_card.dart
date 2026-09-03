import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';

class SuitStatCard extends StatelessWidget {
  final String suitName;
  final String suitImagePath;
  final String totalProfit;
  final int leaseCount;
  final Color sliceColor;
  final bool isSelected;
  final bool isOverdue;
  final VoidCallback onTap;

  const SuitStatCard({
    super.key,
    required this.suitName,
    required this.suitImagePath,
    required this.totalProfit,
    required this.leaseCount,
    required this.sliceColor,
    required this.isSelected,
    required this.isOverdue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 90,
        decoration: BoxDecoration(
          color: isOverdue ? AppColors.wine.withValues(alpha: 0.5) : AppColors.navy,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                  child: SuitImageWidget(imagePath: suitImagePath, width: 80, height: 90),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(suitName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.script20),
                        const SizedBox(height: 4),
                        _row('Total profit', '\$$totalProfit'),
                        _row('Number of leases', '$leaseCount'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Түс индикатору — donut сектору менен дал келет
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: sliceColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppTextStyles.caption12,
          children: [
            TextSpan(text: '\u2022 $label '),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}