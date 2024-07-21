import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/views/search/search_view.dart';

final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarWidget({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leading: Center(
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed('/accountView'),
          child: StreamBuilder<String?>(
              stream: _localStorage.getPicture().asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 16,
                    backgroundImage: const ExactAssetImage(
                      'assets/avatar.png',
                    ),
                    backgroundColor:
                        Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(.4),
                  );
                }
                return CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    snapshot.data!,
                  ),
                  backgroundColor:
                      Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(.4),
                );
              }),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.search),
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
                value: 1,
                child: Text("Share", style: Theme.of(context).textTheme.bodyLarge),
              ),
              const PopupMenuDivider(
                height: 10,
              ),
              PopupMenuItem(
                value: 2,
                child: Text(
                  "Invite",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            ]);
            return list;
          },
          onSelected: (dynamic value) {},
          icon: const Icon(Icons.more_vert),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
