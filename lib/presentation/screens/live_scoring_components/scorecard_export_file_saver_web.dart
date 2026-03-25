import 'dart:typed_data';

/// Export is not supported on web in this implementation.
Future<String> savePngToDevice(Uint8List pngBytes, String fileName) async {
  throw UnsupportedError('Scorecard export is only supported on Android/iOS.');
}

