// core/widgets/suit_image_widget.dart
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SuitImageWidget extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SuitImageWidget({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Проверка на пустой путь
    if (imagePath.isEmpty || imagePath == '') {
      return _buildPlaceholder();
    }

    try {
      // Base64 картинка
      if (imagePath.startsWith('data:image')) {
        final base64Str = imagePath.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          gaplessPlayback: true,
        );
      }

      // Файловый путь
      if (imagePath.startsWith('/') || imagePath.contains('\\')) {
        final file = File(imagePath);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: fit,
            width: width,
            height: height,
          );
        }
        return _buildPlaceholder();
      }

      // Assets
      if (imagePath.startsWith('assets/')) {
        return Image.asset(
          imagePath,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        );
      }
    } catch (e) {
      debugPrint('Image load error: $e');
    }

    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.bmain,
      child: Image.asset(
        'assets/images/photo.png',
        width: 44,
        height: 44,
        color: AppColors.grey,
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}