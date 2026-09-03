// features/clients/presentation/widgets/client_card.dart — толук алмаштыр
import 'package:flutter/material.dart';
import 'package:gentleman/features/suits/domain/entities/client_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/suit_image_widget.dart';

class ClientCard extends StatelessWidget {
  final ClientEntity client;
  final bool isSelected;
  final VoidCallback onTap;
  final int loyalty;
  final String? favoriteSuit;

  const ClientCard({
    super.key,
    required this.client,
    required this.isSelected,
    required this.onTap,
    this.loyalty = 0,
    this.favoriteSuit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.bmain,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
              child: client.photoPath != null
                  ? SuitImageWidget(
                      imagePath: client.photoPath!,
                      width: 100,
                      height: 100,
                    )
                  : Container(
                      width: 100,
                      height: 100,
                      color: AppColors.bmain,
                      child: Image.asset(
                        'assets/images/person.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(client.name, style: AppTextStyles.script20),
                    const SizedBox(height: 4),
                    _row('Tel.', client.phone, valueColor: AppColors.accent),
                    _row('Loyalty', '$loyalty'),
                    if (favoriteSuit != null)
                      _row('Favorite suit', favoriteSuit!, bold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color valueColor = Colors.white, bool bold = false,}) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: AppTextStyles.caption12,
          children: [
            TextSpan(text: '\u2022 $label '),
            TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}