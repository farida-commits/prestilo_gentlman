// features/suits/presentation/widgets/suit_card.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/suit_entity.dart';
import 'package:gentleman/core/widgets/suit_image_widget.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 120,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                    child: SuitImageWidget(
                      imagePath: suit.imagePath,
                      width: 120,
                      height: 120,
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
                          color: Colors.black.withValues(alpha: 0.55),
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
                  padding: const EdgeInsets.only(right: 12, left: 18, top: 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({
    required this.label, 
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '\u2022 $label ',
            style: AppTextStyles.caption.copyWith(color: Colors.white),
          ),
          TextSpan(
            text: value,
            style: AppTextStyles.captionBold12.copyWith(color: Colors.white,),
          ),
        ],
      ),
    );
  }
}