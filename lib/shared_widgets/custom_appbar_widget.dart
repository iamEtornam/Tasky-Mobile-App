import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/utils/local_storage.dart';
import 'package:tasky_app/views/search/search_view.dart';

final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Center(
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/accountView'),
          child: StreamBuilder<String>(
              stream: _localStorage.getPicture().asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundImage: ExactAssetImage(
                      'assets/avatar.png',
                    ),
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)]
                        .withOpacity(.4),
                  );
                }
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    '${snapshot.data}',
                  ),
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .withOpacity(.4),
                );
              }),
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
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchView(),
              );
            }),
        PopupMenuButton(
          itemBuilder: (context) {
            var list = <PopupMenuEntry<Object>>[];
            list.addAll([
              PopupMenuItem(
                child: Text("Share",
                    style: Theme.of(context).textTheme.bodyText1),
                value: 1,
              ),
              PopupMenuDivider(
                height: 10,
              ),
              PopupMenuItem(
                child: Text(
                  "Invite",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                value: 2,
              )
            ]);
            return list;
          },
          onSelected: (value) {},
          icon: Icon(Icons.more_vert),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
