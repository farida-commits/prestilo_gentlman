// features/rental_history/presentation/widgets/suit_history_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';

class SuitHistoryStats {
  final String suitId;
  final String suitName;
  final String suitImagePath;
  final String totalProfit;
  final int leaseCount;
  final String lastRentalDate;
  final String lastCustomer;

  const SuitHistoryStats({
    required this.suitId,
    required this.suitName,
    required this.suitImagePath,
    required this.totalProfit,
    required this.leaseCount,
    required this.lastRentalDate,
    required this.lastCustomer,
  });
}

class SuitHistoryCard extends StatelessWidget {
  final SuitHistoryStats stats;

  const SuitHistoryCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: SuitImageWidget(imagePath: stats.suitImagePath, width: 110, height: 130),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stats.suitName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.script20),
                  const SizedBox(height: 6),
                  _row('Total profit', '\$${stats.totalProfit}'),
                  _row('Number of leases', '${stats.leaseCount}'),
                  _row('Last rental', stats.lastRentalDate),
                  _row('Last customer', stats.lastCustomer, valueColor: AppColors.accent),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppTextStyles.caption12,
          children: [
            TextSpan(text: '\u2022 $label '),
            TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.w700, color: valueColor)),
          ],
        ),
      ),
    );
  }
}