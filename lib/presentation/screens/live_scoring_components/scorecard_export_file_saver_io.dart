import 'dart:io';

import 'dart:typed_data';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';

/// Saves PNG bytes to the device and returns the absolute file path.
Future<String> savePngToDevice(Uint8List pngBytes, String fileName) async {
  // Save to gallery. Since this package does not return a path when saving
  // directly from bytes, we write to a temp file first, then ask the package
  // to save that file to the gallery.
  final tempFile = File('${Directory.systemTemp.path}/$fileName');
  await tempFile.writeAsBytes(pngBytes, flush: true);

  final saver = ImageGallerySaver();
  await saver.saveFile(tempFile.path);

  // Return the file path we created (works for sharing as well).
  return tempFile.path;
}

