import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';


class CustomBottomSheetWidget extends StatelessWidget {
  final List<Options> options;
  final double height;
  final String title;

  const CustomBottomSheetWidget(
      {Key key, @required this.options, this.height = 170.0, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? title != null
            ? CupertinoActionSheet(
                message: Text(
                  '$title',
                ),
                actions: options
                    .map((e) => CupertinoButton(
                        child: Text(
                          e.label,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: customRedColor),
                        ),
                        onPressed: e.onTap))
                    .toList(),
                cancelButton: CupertinoButton(
                    child: Text('Cancel',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop()))
            : CupertinoActionSheet(
                actions: options
                    .map((e) => CupertinoButton(
                        child: Text(
                          e.label,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: customRedColor),
                        ),
                        onPressed: e.onTap))
                    .toList(),
                cancelButton: CupertinoButton(
                    child: Text('Cancel',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.red)),
                    onPressed: () => Navigator.of(context).pop()))
        : Container(
            height: height,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                title != null
                    ? Text(
                        '$title',
                      )
                    : SizedBox(),
                Column(
                  children: options
                      .map((e) => Column(
                            children: [
                              InkWell(
                                onTap: e.onTap,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: customRedColor)),
                                ),
                              ),
                              Divider()
                            ],
                          ))
                      .toList(),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class Options {
  String label;
  Function onTap;

  Options({@required String label, Function onTap}) {
    this.label = label;
    this.onTap = onTap;
  }
}
