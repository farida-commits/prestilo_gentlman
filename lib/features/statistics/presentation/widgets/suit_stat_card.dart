import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';
import '../../../suits/domain/entities/suit_entity.dart';

class SuitStatCard extends StatelessWidget {
  final String suitName;
  final String suitImagePath;
  final String totalProfit;
  final int leaseCount;
  final Color sliceColor;
  final bool isSelected;
  final SuitStatus status;
  final VoidCallback onTap;

  const SuitStatCard({
    super.key,
    required this.suitName,
    required this.suitImagePath,
    required this.totalProfit,
    required this.leaseCount,
    required this.sliceColor,
    required this.isSelected,
    required this.status,
    required this.onTap,
  });

    Color get _bgColor {
    switch (status) {
      case SuitStatus.inStock:
        return AppColors.bmain;
      case SuitStatus.leased:
        return AppColors.brown;
      case SuitStatus.overdue:
        return AppColors.wine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 86,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(9),
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
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                  child: SuitImageWidget(imagePath: suitImagePath, width: 86, height: 86),
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
                  borderRadius: BorderRadius.circular(4),
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
            TextSpan(text: value, style: AppTextStyles.captionBold12.copyWith(color: Colors.white),),
          ],
        ),
      ),
    );
  }
}