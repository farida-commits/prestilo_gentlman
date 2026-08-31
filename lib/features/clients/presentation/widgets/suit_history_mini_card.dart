// features/clients/presentation/widgets/suit_history_mini_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';
import '../../../rental_history/domain/entities/rental_record_entity.dart';

class SuitHistoryMiniCard extends StatelessWidget {
  final RentalRecordEntity record;
  final VoidCallback? onDelete;

  const SuitHistoryMiniCard({super.key, required this.record, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SuitImageWidget(imagePath: record.suitImagePath, width: 90, height: 110),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(record.suitName, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.script20),
                      const SizedBox(height: 4),
                      _row('Brand:', record.suitBrand),
                      _row('Price:', '\$${record.suitPrice}'),
                      _row('Fabric:', record.suitFabric),
                      _row('Size', record.suitSize),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (onDelete != null)
            Positioned(
              left: 6,
              top: 6,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.wine,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
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
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}