// core/utils/image_file_saver.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class ImageFileSaver {
  static Future<String> saveBase64Image(String base64String) async {
    try {
      if (base64String.isEmpty) {
        debugPrint('Base64 string is empty');
        return '';
      }

      final appDir = await getApplicationDocumentsDirectory();
      final suitsDir = Directory('${appDir.path}/suits_images');
      
      if (!await suitsDir.exists()) {
        await suitsDir.create(recursive: true);
      }

      final fileName = 'suit_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${suitsDir.path}/$fileName');

      // Удали "data:image/jpeg;base64," часть
      String base64Str = base64String;
      if (base64Str.contains(',')) {
        base64Str = base64Str.split(',').last;
      }

      final bytes = base64Decode(base64Str);
      await file.writeAsBytes(bytes);
      
      debugPrint('Image saved: ${file.path}');
      return file.path;
    } catch (e) {
      debugPrint('Image save error: $e');
      return '';
    }
  }
}