// features/suits/presentation/widgets/photo_access_dialog.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class PhotoAccessDialog extends StatelessWidget {
  const PhotoAccessDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const PhotoAccessDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.only(left: 53, right: 53),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Container(
            width: 270,
            height: 269.5,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2).withValues(alpha: 0.8), // CC = 0.8 alpha
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    children: [
                      Text(
                        '"Prestilo: Own your style"\nWould Like to Access Your \nPhotos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "You'll be able to upload a picture of your suit",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13, 
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0x3C3C435C)),
                _option(context, 'Select Photos...', 'select'),
                const Divider(height: 1, color: Color(0x3C3C435C)),
                _option(context, 'Allow Access to all Photos', 'allow_all'),
                const Divider(height: 1, color: Color(0x3C3C435C)),
                _option(context, "Don't Allow", 'deny', isBold: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(BuildContext context, String text, String value, {bool isBold = false}) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => Navigator.pop(context, value),
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xff007AFF),
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}