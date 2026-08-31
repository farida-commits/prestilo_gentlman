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

  const ClientCard({
    super.key,
    required this.client,
    required this.isSelected,
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
          color: AppColors.bgMain,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              child: client.photoPath != null
                  ? SuitImageWidget(
                      imagePath: client.photoPath!,
                      width: 80,
                      height: 88,
                    )
                  : Container(
                      width: 80,
                      height: 88,
                      color: AppColors.bmain,
                      child: const Icon(Icons.person, color: Colors.white38, size: 32),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(client.name, style: AppTextStyles.script20),
                    const SizedBox(height: 4),
                    _row('Tel.', client.phone, valueColor: AppColors.accent),
                  ],
                ),
              ),
            ),
          ],
        ),
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
            TextSpan(text: value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}