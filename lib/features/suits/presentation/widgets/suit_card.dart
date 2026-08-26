// features/suits/presentation/widgets/suit_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/suit_entity.dart';

class SuitCard extends StatelessWidget {
  final SuitEntity suit;
  final VoidCallback? onTap;

  const SuitCard({super.key, required this.suit, this.onTap});

  Color get _bgColor {
    switch (suit.status) {
      case SuitStatus.inStock:
        return AppColors.navy;
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
        height: 130,
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                  child: Image.asset(
                    suit.imagePath,
                    width: 110,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                if (suit.dateLabel != null)
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        suit.dateLabel!,
                        style: const TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      suit.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.script20,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(label: 'Brand:', value: suit.brand),
                    _InfoRow(label: 'Price:', value: suit.price),
                    _InfoRow(label: 'Fabric:', value: suit.fabric),
                    _InfoRow(label: 'Size', value: suit.size),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppTextStyles.caption12,
          children: [
            TextSpan(text: '\u2022 $label '),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}