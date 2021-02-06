import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:tasky_app/utils/custom_colors.dart';

class AccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: Colors
                  .primaries[Random().nextInt(Colors.primaries.length)]
                  .withOpacity(.2),
              radius: 60,
              backgroundImage: ExactAssetImage('assets/avatar.png'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Text(
            'Bright Sunu Etornam',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w600),
          )),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
            'View Profile',
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(fontWeight: FontWeight.normal, color: customRedColor),
          )),
          SizedBox(
            height: 25,
          ),
          Text(
            'Organizations',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, color: customGreyColor),
          ),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                'Aura Innovations',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              subtitle: Text(
                'info@etornam.dev',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: customGreyColor),
              ),
              trailing: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: customRedColor,
                  onPressed: () {},
                  child: Text(
                    'Invite',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, color: customGreyColor),
          ),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Do not disturb',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    'Off',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: customGreyColor),
                  ),
                  leading: Icon(Icons.notifications_paused_outlined,
                      color: Theme.of(context).iconTheme.color, size: 30),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                          Platform.isIOS
                              ? Icons.arrow_forward_ios_sharp
                              : Icons.arrow_forward,
                          color: Theme.of(context).iconTheme.color)),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Push',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  subtitle: Text(
                    'Manage',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: customGreyColor),
                  ),
                  leading: Icon(
                    Entypo.notification,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Support',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, color: customGreyColor),
          ),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'iOS guide',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(Icons.info_outline_rounded,
                      color: Theme.of(context).iconTheme.color, size: 30),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                          Platform.isIOS
                              ? Icons.arrow_forward_ios_sharp
                              : Icons.arrow_forward,
                          color: Theme.of(context).iconTheme.color)),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Contact support',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'More',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                fontWeight: FontWeight.normal, color: customGreyColor),
          ),
          Material(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Rate the app',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(Icons.star_border_rounded,
                      color: Theme.of(context).iconTheme.color, size: 30),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                          Platform.isIOS
                              ? Icons.arrow_forward_ios_sharp
                              : Icons.arrow_forward,
                          color: Theme.of(context).iconTheme.color)),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Privacy policy',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(
                    Icons.visibility_outlined,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Terms of service',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(
                    Feather.settings,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Version',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  leading: Icon(
                    Platform.isIOS
                        ? Ionicons.ios_phone_portrait
                        : Ionicons.md_phone_portrait,
                    color: Theme.of(context).iconTheme.color,
                    size: 30,
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
              padding: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).cardColor,
              onPressed: () {},
              child: Text(
                'Log out',
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: customRedColor),
              ))
        ],
      ),
    );
  }
}
