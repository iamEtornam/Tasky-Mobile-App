import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as image_picker;

import 'custom_colors.dart';

const defaultAvatarUrl = 'https://asset.cloudinary.com/iametornam/6ccefc294e57bc7f90054f08f5e4fe0f';

enum AlertType { error , info, success }

class UiUtilities {
  actionAlertWidget({required BuildContext context, required AlertType alertType}) {
    final yyDialog = YYDialog()..build(context)
      ..width = 120
      ..height = 110
      ..backgroundColor = Colors.black.withOpacity(0.8)
      ..borderRadius = 10.0
      ..useRootNavigator = false
      ..widget(Padding(
        padding: const EdgeInsets.only(top: 21),
        child: SvgPicture.asset(
          alertType == AlertType.error
              ? 'assets/error.svg'
              : alertType == AlertType.info
                  ? 'assets/info.svg'
                  : 'assets/success.svg',
          width: 38,
          height: 38,
        ),
      ))
      ..widget(Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          alertType.name == 'error'
              ? 'Failed'
              : alertType.name == 'info'
                  ? 'Info'
                  : 'Success',
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ))
      ..animatedFunc = (child, animation) {
        return ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(animation),
          child: child,
        );
      };
    yyDialog.show();
    Future.delayed(const Duration(seconds: 2), () {
      yyDialog.dismiss();
    });
  }

  alertNotification({required String message, required BuildContext context}) {
    return BotToast.showSimpleNotification(
        title: message,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.1),
        borderRadius: 10.0,
        duration: const Duration(seconds: 4),
        align: Alignment.topCenter);
  }

  Future<XFile?> getImage({required image_picker.ImageSource imageSource}) async {
    return await image_picker.ImagePicker().pickImage(source: imageSource);
  }

  Future<File?> getCroppedFile({required String file}) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 70,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: customRedColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        )
      ],
    );

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
