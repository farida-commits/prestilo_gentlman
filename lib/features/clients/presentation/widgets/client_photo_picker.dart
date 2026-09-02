// features/clients/presentation/widgets/client_photo_picker.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/suit_image_widget.dart';

class ClientPhotoPicker extends StatelessWidget {
  final String? imagePath;
  final Uint8List? cachedBytes;
  final VoidCallback onPick;
  final VoidCallback onDelete;
  final bool showDelete; 

  const ClientPhotoPicker({
    super.key,
    required this.imagePath,
    this.cachedBytes,
    required this.onPick,
    required this.onDelete,
    this.showDelete = true, 
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: imagePath == null ? onPick : null,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          child: Container(
            width: double.infinity,
            height: 295,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.bmain,
              borderRadius: BorderRadius.circular(9),
            ),
            child: imagePath == null
                ? Center(
                    child: Image.asset(
                      'assets/images/photo.png',
                      width: 44,
                      height: 44,
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      cachedBytes != null
                          ? Image.memory(cachedBytes!, fit: BoxFit.cover, gaplessPlayback: true)
                          : SuitImageWidget(imagePath: imagePath!),
                          if (showDelete)
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.wine,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Image.asset(
                              'assets/images/delete.png',
                              width: 32,
                              height: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}