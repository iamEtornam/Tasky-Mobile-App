import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tasky_app/managers/user_manager.dart';
import 'package:tasky_app/models/user.dart';
import 'package:tasky_app/utils/local_storage.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/views/account/personal_account_view.dart';
import 'package:textfield_tags/textfield_tags.dart';

final UserManager _userManager = GetIt.I.get<UserManager>();
final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

class AccountView extends StatefulWidget {
  const AccountView({Key key}) : super(key: key);

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final Logger _logger = Logger();
  List<String> teams = [];

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
        padding: const EdgeInsets.all(24),
        children: [
          StreamBuilder<User>(
              stream: _userManager.getUserInformation().asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.primaries[
                                  Random().nextInt(Colors.primaries.length)]
                              .withOpacity(.2),
                          radius: 60,
                          backgroundImage: const ExactAssetImage('assets/avatar.png'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Text(
                        'Full Name here',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(fontWeight: FontWeight.w600),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'View Profile',
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                            fontWeight: FontWeight.normal,
                            color: customRedColor),
                      )),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Organizations',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.normal,
                            color: customGreyColor),
                      ),
                      Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            'My Company',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          subtitle: Text(
                            'info@mail.com',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: customGreyColor),
                          ),
                          trailing: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                backgroundColor: customRedColor,
                              ),
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
                    ],
                  );
                }
                return Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]
                            .withOpacity(.2),
                        radius: 60,
                        backgroundImage: snapshot.data == null
                            ? const ExactAssetImage('assets/avatar.png')
                            : NetworkImage(snapshot.data.data.picture),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Text(
                      snapshot.data.data.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontWeight: FontWeight.w600),
                    )),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (Platform.isIOS) {
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const PersonalAccountView();
                              },
                            );
                          } else {
                            showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const PersonalAccountView();
                              },
                            );
                          }
                        },
                        child: Text(
                          'View Profile',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.normal,
                              color: customRedColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Organizations',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          color: customGreyColor),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(
                          snapshot.data?.data?.organization?.name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        subtitle: Text(
                          snapshot.data?.data?.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: customGreyColor),
                        ),
                        trailing: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor: customRedColor,
                            ),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: SizedBox(
                                        height: 150,
                                        child: Column(
                                          children: [
                                            TextFieldTags(
                                              textFieldStyler: TextFieldStyler(
                                                helperText: '',
                                                cursorColor: Theme.of(context)
                                                    .textSelectionTheme
                                                    .cursorColor,
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.grey),
                                                hintText: 'Emails',
                                                textFieldBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                customGreyColor)),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                                textFieldEnabledBorder:
                                                   const  UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                customGreyColor)),
                                                textFieldFocusedBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                customGreyColor)),
                                              ),
                                              //[tagsStyler] is required and shall not be null
                                              tagsStyler: TagsStyler(
                                                //These are properties you can tweek for customization of tags
                                                tagTextStyle: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.white),
                                                tagDecoration: BoxDecoration(
                                                  color: customRedColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                                tagCancelIcon: const Icon(
                                                    Icons.cancel,
                                                    size: 18.0,
                                                    color: Colors.white),
                                                tagPadding:
                                                    const EdgeInsets.all(8.0),

                                                // EdgeInsets tagPadding = const EdgeInsets.all(4.0),
                                                // EdgeInsets tagMargin = const EdgeInsets.symmetric(horizontal: 4.0),
                                                // BoxDecoration tagDecoration = const BoxDecoration(color: Color.fromARGB(255, 74, 137, 92)),
                                                // TextStyle tagTextStyle,
                                                // Icon tagCancelIcon = const Icon(Icons.cancel, size: 18.0, color: Colors.green)
                                                // isHashTag: true,
                                              ),
                                              onTag: (tag) {
                                                //This give you tags entered
                                                _logger.d('onTag ' + tag);
                                                setState(() {
                                                  teams.add(tag);
                                                });
                                              },
                                              onDelete: (tag) {
                                                _logger.d('onDelete ' + tag);
                                                setState(() {
                                                  teams.remove(tag);
                                                });
                                              },
                                            ),
                                           const  SizedBox(
                                              height: 10,
                                            ),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    backgroundColor:
                                                        customRedColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    )),
                                                onPressed: () {},
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, right: 15),
                                                  child: Text(
                                                    'Invite email(s)',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Text(
                              'Invite',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                    ),
                  ],
                );
              }),
          const SizedBox(
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
                const Divider(),
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
          const SizedBox(
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
                const Divider(),
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
          const SizedBox(
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
                const Divider(),
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
                const Divider(),
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
                const Divider(),
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
          const SizedBox(
            height: 30,
          ),
          TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: Theme.of(context).cardColor,
              ),
              onPressed: () async {
                BotToast.showLoading(
                    allowClick: false,
                    clickClose: false,
                    backButtonBehavior: BackButtonBehavior.ignore);
                final fb.FirebaseAuth firebaseAuth = fb.FirebaseAuth.instance;
                firebaseAuth.signOut().then((_) async {
                  await _localStorage.clearStorage();
                  BotToast.closeAllLoading();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/loginView', (route) => false);
                });
              },
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
