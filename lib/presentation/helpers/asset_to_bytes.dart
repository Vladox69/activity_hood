import 'package:flutter/services.dart';
import 'dart:ui' as ui;

Future<Uint8List> assetToByte(String path) async {
  final byteData = await rootBundle.load(path);
  final bytes = byteData.buffer.asUint8List();
  final codec = await ui.instantiateImageCodec(bytes, targetHeight: 100);
  final frame = await codec.getNextFrame();
  final newByteData =
      await frame.image.toByteData(format: ui.ImageByteFormat.png);
  return newByteData!.buffer.asUint8List();
}
