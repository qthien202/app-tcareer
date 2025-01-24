import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

enum ImageOrientation { portrait, landscape }

Future<ImageOrientation> getImageOrientation(dynamic imageSource) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  Image image;

  if (imageSource is String && imageSource.startsWith('http')) {
    image = Image.network(imageSource);
  } else if (imageSource is Uint8List) {
    image = Image.memory(imageSource);
  } else if (imageSource is File) {
    image = Image.file(imageSource);
  } else if (imageSource is String && File(imageSource).existsSync()) {
    image = Image.file(File(imageSource));
  } else {
    throw ArgumentError('Unsupported image source');
  }

  image.image.resolve(const ImageConfiguration()).addListener(
    ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) {
        completer.complete(imageInfo);
      },
    ),
  );

  final ImageInfo imageInfo = await completer.future;
  final int width = imageInfo.image.width;
  final int height = imageInfo.image.height;

  return width > height
      ? ImageOrientation.landscape
      : ImageOrientation.portrait;
}
