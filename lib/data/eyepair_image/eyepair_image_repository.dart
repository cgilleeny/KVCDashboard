import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_check_kidz_dashboard/data/eyepair_image/eyepair_image_network_service.dart';
import 'package:image/image.dart';

class ImageRepository {
  Map<String, Map<String, MemoryImage>> eyeImageMap = {};
  ImageNetworkService networkService;
  ImageRepository(this.networkService);

  Future<MemoryImage?> fetchImage(String rowKey, String suffix,
      {bool cropBottom = false}) async {
    var screeningMap = eyeImageMap[rowKey];
    var memoryImage = screeningMap?[suffix];
    if (memoryImage != null) {
      return memoryImage;
    }
    final imageBytes = await networkService.fetchImage(rowKey, suffix);
    if (imageBytes != null) {
      if (cropBottom) {
        memoryImage = await _cropInBackground(imageBytes);
      } else {
        memoryImage = MemoryImage(imageBytes);
      }
      screeningMap ??= {};
      screeningMap[suffix] = memoryImage;
      eyeImageMap[rowKey] = screeningMap;
    }
    return memoryImage;
  }

  Future<MemoryImage> _cropInBackground(Uint8List imageBytes) async {
    final p = ReceivePort();
    await Isolate.spawn(
        _cropBottomForThreeFourthsAspectRation, [p.sendPort, imageBytes]);
    return await p.first as MemoryImage;
  }

  static void _cropBottomForThreeFourthsAspectRation(List<dynamic> args) async {
    final p = args[0] as SendPort;
    final imageBytes = args[1] as Uint8List;

    final image = decodeImage(imageBytes);
    // if (image != null) {
    //   args[1] = null;
    //   Isolate.exit(
    //     p,
    //     args,
    //   );
    // }

    // print(
        // 'image.width: ${image?.width}, image.height: ${image?.height}, w/.75 = ${image?.width / 0.75}');
    if (image != null && image.height > (image.width / 0.75).round()) {
      final face =
          copyCrop(image, 0, 0, image.width, (image.width / 0.75).round());
      args[1] = MemoryImage(Uint8List.fromList(encodeJpg(face)));
      Isolate.exit(
        p,
        MemoryImage(Uint8List.fromList(encodeJpg(face))),
      );
    }
    args[1] = MemoryImage(imageBytes);
    Isolate.exit(
      p,
      MemoryImage(imageBytes),
    );
  }
}
