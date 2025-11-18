
// reusable_image_cropper.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

/// Simple cropper wrapper using image_cropper package.
class ReusableImageCropper {
  static Future<File?> cropFile(File file, {CropAspectRatio? aspectRatio}) async {
    final res = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: aspectRatio,
      uiSettings: [
        AndroidUiSettings(toolbarTitle: 'Crop', toolbarColor: Colors.black, toolbarWidgetColor: Colors.white),
        IOSUiSettings(title: 'Crop'),
      ],
    );
    if (res == null) return null;
    return File(res.path);
  }
}
