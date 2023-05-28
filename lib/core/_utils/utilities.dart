import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Utilities {
  Utilities._();

  static bool isKeyboardShowing(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static closeKeyboard(BuildContext context) {
    if (!isKeyboardShowing(context)) return false;
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static Future<XFile?> pickImageFromGallery() async {
    try {
      return await ImagePicker().pickImage(source: ImageSource.gallery);
    } catch (ex) {
      developer.log('Image Picker Exception: $ex');
      return null;
    }
  }

  static Future<List<XFile>?> pickMultipleImagesFromGallery() async {
    try {
      return await ImagePicker().pickMultiImage();
    } catch (ex) {
      developer.log('Image Picker Exception: $ex');
      return null;
    }
  }

  static Future<CroppedFile?> cropImage(BuildContext context, String imagePath, int size) async {
    try {
      return await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        maxHeight: size,
        maxWidth: size,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Image Cropper',
            aspectRatioLockEnabled: true,
            minimumAspectRatio: 1.0,
          )
        ],
      );
    } catch (ex) {
      developer.log('Image Cropper Exception: $ex');
      return null;
    }
  }
}
