import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
}