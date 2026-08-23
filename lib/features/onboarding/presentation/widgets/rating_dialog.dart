// features/onboarding/presentation/widgets/rating_dialog.dart
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 4;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xF2F2F2CC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        width: 270,
        height: 273.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset('assets/images/icon.jpg',)
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Tap a star to rate. You can also leave a \ncomment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xff001420)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () => setState(() => _rating = index + 1),
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: 26,
                  ),
                );
              }),
            ),
            const Divider(height: 1, color: Color(0x3C3C435C),),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel', 
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Container(width: 1, height: 44, color: Color(0x3C3C435C)),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}