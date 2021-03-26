import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as ImagePicker;

import 'custom_colors.dart';


class UiUtilities {
  actionAlertWidget(
    {@required BuildContext context, @required String alertType}) {
  YYDialog yyDialog = YYDialog();
  yyDialog.build(context)
    ..width = 120
    ..height = 110
    ..backgroundColor = Colors.black.withOpacity(0.8)
    ..borderRadius = 10.0
    ..useRootNavigator = false
    ..widget(Padding(
      padding: EdgeInsets.only(top: 21),
      child: SvgPicture.asset(
        alertType == 'error'
            ? 'assets/error.svg'
            : alertType == 'info'
                ? 'assets/info.svg'
                : 'assets/success.svg',
        width: 38,
        height: 38,
      ),
    ))
    ..widget(Padding(
      padding: EdgeInsets.only(top: 10),
      child: Text(
        alertType == 'error'
            ? 'Failed'
            : alertType == 'info'
                ? 'Info'
                : 'Success',
        style: TextStyle(
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ))
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    };
  yyDialog.show();
  Future.delayed(Duration(seconds: 2), () {
    yyDialog.dismiss();
  });
}


alertNotification({@required String message, @required BuildContext context}) {
  return BotToast.showSimpleNotification(
      title: message,
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor.withOpacity(.3),
      borderRadius: 10,
      duration: Duration(seconds: 4),
      align: Alignment.topCenter);
}

Future<PickedFile> getImage({@required ImagePicker.ImageSource imageSource}) async {
  return await ImagePicker.ImagePicker().getImage(source: imageSource);
}

Future<File> getCroppedFile({String file}) async {
  return await ImageCropper.cropImage(
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
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: customRedColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ));
}

String twenty4to12conventer(String unformattedTime) {
  List<String> _time = unformattedTime.split(':');
    String time;
    switch (int.parse(_time[0])) {
      case 13:
        time = '1:${_time[1]} PM';
        break;
      case 14:
        time = '2:${_time[1]} PM';
        break;
      case 15:
        time = '3:${_time[1]} PM';
        break;
      case 16:
        time = '4:${_time[1]} PM';
        break;
      case 17:
        time = '5:${_time[1]} PM';
        break;
      case 18:
        time = '6:${_time[1]} PM';
        break;
      case 19:
        time = '7:${_time[1]} PM';
        break;
      case 20:
        time = '8:${_time[1]} PM';
        break;
      case 21:
        time = '9:${_time[1]} PM';
        break;
      case 22:
        time = '10:${_time[1]} PM';
        break;
      case 23:
        time = '11:${_time[1]} PM';
        break;
    default:
     return '$unformattedTime AM';
    }
    return time;
}
}