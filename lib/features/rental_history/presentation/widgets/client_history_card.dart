// features/rental_history/presentation/widgets/client_history_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';

class ClientHistoryStats {
  final String clientId;
  final String clientName;
  final String? clientPhotoPath;
  final String totalIncome;
  final int rentalCount;
  final String lastSuit;
  final String lastRentalDate;

  const ClientHistoryStats({
    required this.clientId,
    required this.clientName,
    required this.clientPhotoPath,
    required this.totalIncome,
    required this.rentalCount,
    required this.lastSuit,
    required this.lastRentalDate,
  });
}

class ClientHistoryCard extends StatelessWidget {
  final ClientHistoryStats stats;

  const ClientHistoryCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
            child: stats.clientPhotoPath != null
                ? SuitImageWidget(imagePath: stats.clientPhotoPath!, width: 120, height: 120)
                : Container(
                    width: 120,
                    height: 120,
                    color: AppColors.bmain,
                    child: Image.asset(
                      'assets/images/photo.png',
                      width: 44,
                      height: 44,
                    )
                  ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(stats.clientName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.script20),
                  const SizedBox(height: 6),
                  _row('Total income', '\$${stats.totalIncome}'),
                  _row('Rental', '${stats.rentalCount}'),
                  _row('Last suit', stats.lastSuit),
                  _row('Last rental', stats.lastRentalDate),
                ],
              ),
            ),
          ),
        ],
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
            TextSpan(text: value, style: AppTextStyles.captionBold12),
          ],
        ),
      ),
    );
  }
}