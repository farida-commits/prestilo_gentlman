// // features/suits/presentation/widgets/suit_image_picker.dart
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:gentleman/core/widgets/suit_image_widget.dart';
// import '../../../../core/constants/app_colors.dart';

// class SuitImagePicker extends StatelessWidget {
//   final String? imagePath;
//   final Uint8List? cachedBytes;
//   final VoidCallback onPick;
//   final VoidCallback onDelete;

//   const SuitImagePicker({
//     super.key,
//     required this.imagePath,
//     this.cachedBytes,
//     required this.onPick,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: imagePath == null ? onPick : null,
//       child: Container(
//         width: double.infinity,
//         height: 295,
//         clipBehavior: Clip.antiAlias,
//         decoration: BoxDecoration(
//           color: AppColors.bmain,
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: imagePath == null
//             ? Center(
//                 child: Image.asset(
//                   'assets/images/photo.png',
//                   width: 44,
//                   height: 44,
//                   color:
//                       AppColors.grey, // Эгер сүрөттүн түсүн өзгөрткүңүз келсе
//                   colorBlendMode: BlendMode.srcIn, // Түстү сүрөткө колдонот
//                 ),
//               )
//             : Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   SuitImageWidget(imagePath: imagePath!),
//                   Positioned(
//                     right: 10,
//                     bottom: 10,
//                     child: Row(
//                       children: [
//                         _iconButton('assets/images/izmenenie.png', onPick),
//                         SizedBox(width: 8),
//                         _iconButton('assets/images/delete.png', onDelete),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _iconButton(String imagePath, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: AppColors.bmain,
//           borderRadius: BorderRadius.circular(9),
//         ),
//         child: Image.asset(
//           imagePath, 
//           width: 32, 
//           height: 32,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }


// features/suits/presentation/widgets/suit_image_picker.dart — толук алмаштыр
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gentleman/core/widgets/suit_image_widget.dart';
import '../../../../core/constants/app_colors.dart';

class SuitImagePicker extends StatelessWidget {
  final String? imagePath;
  final Uint8List? cachedBytes;
  final VoidCallback onPick;
  final VoidCallback onDelete;

  const SuitImagePicker({
    super.key,
    required this.imagePath,
    this.cachedBytes,
    required this.onPick,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: imagePath == null
            ? () {
                debugPrint('Image picker tapped!'); // текшерүү үчүн
                onPick();
              }
            : null,
        borderRadius: BorderRadius.circular(9),
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
                  child: Icon(
                    Icons.image_outlined,
                    size: 44,
                    color: AppColors.grey,
                  ),
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    SuitImageWidget(imagePath: imagePath!),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Row(
                        children: [
                          _iconButton('assets/images/izmenenie.png', onPick),
                          const SizedBox(width: 8),
                          _iconButton('assets/images/delete.png', onDelete),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _iconButton(String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.bmain,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Image.asset(imagePath, width: 32, height: 32, color: Colors.white),
      ),
    );
  }
}