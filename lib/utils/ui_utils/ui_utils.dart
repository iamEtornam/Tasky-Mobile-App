import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:image_picker/image_picker.dart';

import 'custom_colors.dart';

const defaultAvatarUrl =
    'https://asset.cloudinary.com/iametornam/6ccefc294e57bc7f90054f08f5e4fe0f';

enum AlertType { error, info, success }

class UiUtilities {
  actionAlertWidget(
      {required BuildContext context, required AlertType alertType}) {
    Future.delayed(const Duration(seconds: 3), () {
      if (!context.mounted) return;
      Navigator.of(context).pop();
    });
    return showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              children: [
                Center(
                  child: SvgPicture.asset(
                    alertType == AlertType.error
                        ? 'assets/error.svg'
                        : alertType == AlertType.info
                            ? 'assets/info.svg'
                            : 'assets/success.svg',
                    width: 38,
                    height: 38,
                  ),
                ),
                Center(
                  child: Text(
                    alertType.name == 'error'
                        ? 'Failed'
                        : alertType.name == 'info'
                            ? 'Info'
                            : 'Success',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  alertNotification({required String message, required BuildContext context}) {
    return BotToast.showSimpleNotification(
        title: message,
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withValues(alpha: .1),
        borderRadius: 10.0,
        duration: const Duration(seconds: 4),
        align: Alignment.topCenter);
  }

  Future<XFile?> getImage(
      {required image_picker.ImageSource imageSource}) async {
    return await image_picker.ImagePicker().pickImage(source: imageSource);
  }

  Future<File?> getCroppedFile({required String file}) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: file,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: customRedColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]),
          IOSUiSettings(title: 'Crop Image', aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ])
        ]);

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  String twenty4to12conventer(String unformattedTime) {
    List<String> splitTime = unformattedTime.split(':');
    String time;
    switch (int.parse(splitTime[0])) {
      case 13:
        time = '1:${splitTime[1]} PM';
        break;
      case 14:
        time = '2:${splitTime[1]} PM';
        break;
      case 15:
        time = '3:${splitTime[1]} PM';
        break;
      case 16:
        time = '4:${splitTime[1]} PM';
        break;
      case 17:
        time = '5:${splitTime[1]} PM';
        break;
      case 18:
        time = '6:${splitTime[1]} PM';
        break;
      case 19:
        time = '7:${splitTime[1]} PM';
        break;
      case 20:
        time = '8:${splitTime[1]} PM';
        break;
      case 21:
        time = '9:${splitTime[1]} PM';
        break;
      case 22:
        time = '10:${splitTime[1]} PM';
        break;
      case 23:
        time = '11:${splitTime[1]} PM';
        break;
      default:
        return '$unformattedTime AM';
    }
    return time;
  }
}
