import 'dart:math';

import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Center(
        child: CircleAvatar(
          radius: 16,
          backgroundImage:
              ExactAssetImage('assets/avatar.png',),
              backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(.4),
        ),
      ),
      title: Text(
        '$title',
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
