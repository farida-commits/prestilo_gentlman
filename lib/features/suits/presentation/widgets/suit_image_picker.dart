// features/suits/presentation/widgets/suit_image_picker.dart
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SuitImagePicker extends StatelessWidget {
  final String? imagePath;
  final VoidCallback onPick;
  final VoidCallback onDelete;

  const SuitImagePicker({
    super.key,
    required this.imagePath,
    required this.onPick,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: imagePath == null ? onPick : null,
      child: Container(
        width: double.infinity,
        height: 260,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(16),
        ),
        child: imagePath == null
            ? const Center(
                child: Icon(Icons.image_outlined, color: Colors.white38, size: 48),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(File(imagePath!), fit: BoxFit.cover),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        _iconButton(Icons.edit_outlined, onPick),
                        const SizedBox(width: 8),
                        _iconButton(Icons.delete_outline, onDelete),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}