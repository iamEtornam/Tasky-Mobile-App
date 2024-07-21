import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_apps_settings/open_apps_settings.dart';
import 'package:open_apps_settings/settings_enum.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tasky_mobile_app/managers/organization_manager.dart';
import 'package:tasky_mobile_app/managers/user_manager.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';
import 'package:tasky_mobile_app/views/account/personal_account_view.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final UserManager _userManager = GetIt.I.get<UserManager>();
  final OrganizationManager _organizationManager =
      GetIt.I.get<OrganizationManager>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();
  final InAppReview _inAppReview = InAppReview.instance;
  final _tagsController = TextfieldTagsController();
  final UiUtilities uiUtilities = UiUtilities();
  Data? userData;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    await _userManager.getUserInformation();
    userData = await _localStorage.getUserInfo();
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant AccountView oldWidget) {
    super.didUpdateWidget(oldWidget);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            getUserInfo();
          },
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              FutureBuilder<Data?>(
                  future: Future.value(userData),
                  builder: (context, snapshot) {
                    if ((snapshot.connectionState == ConnectionState.waiting ||
                            snapshot.connectionState == ConnectionState.done) &&
                        snapshot.data == null) {
                      return Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .withOpacity(.2),
                              radius: 60,
                              backgroundImage:
                                  const ExactAssetImage('assets/avatar.png'),
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
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.w600),
                          )),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                              child: Text(
                            'View Profile',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: customRedColor),
                          )),
                          const SizedBox(
                            height: 25,
                          ),
                          Text(
                            'Organizations',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: customGreyColor),
                          ),
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              title: Text(
                                'My Company',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                'info@mail.com',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: customGreyColor),
                              ),
                              trailing: TextButton(
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    backgroundColor: customRedColor,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Invite',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
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
                            backgroundColor: Colors
                                .primaries[Random().nextInt(Colors.primaries.length)]
                                .withOpacity(.2),
                            radius: 60,
                            backgroundImage: (snapshot.data?.picture == null
                                    ? const ExactAssetImage('assets/avatar.png')
                                    : NetworkImage(snapshot.data!.picture!))
                                as ImageProvider<Object>?,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                            child: Text(
                          snapshot.data?.name ?? 'Not provided',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: customRedColor),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Organization',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: customGreyColor),
                        ),
                        Material(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(
                              snapshot.data?.organization?.name ??
                                  'Not provided',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            subtitle: Text(
                              snapshot.data?.email ?? 'Not provided',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
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
                                        return AlertDialog.adaptive(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          content: SizedBox(
                                            height: 170,
                                            child: Column(
                                              children: [
                                                TextFieldTags(
                                                  textfieldTagsController:
                                                      _tagsController,
                                                  inputfieldBuilder: (context,
                                                      tec,
                                                      fn,
                                                      error,
                                                      onChanged,
                                                      onSubmitted) {
                                                    return ((context, sc, tags,
                                                        onTagDelete) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: TextField(
                                                          controller: tec,
                                                          focusNode: fn,
                                                          decoration:
                                                              InputDecoration(
                                                            isDense: true,
                                                            border: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                        color:
                                                                            customGreyColor)),
                                                            focusedBorder:
                                                                const UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                customGreyColor)),
                                                            helperText:
                                                                'Emails',
                                                            helperStyle:
                                                                const TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      74,
                                                                      137,
                                                                      92),
                                                            ),
                                                            hintText:
                                                                _tagsController
                                                                        .hasTags
                                                                    ? ''
                                                                    : "Enter emails",
                                                            errorText: error,
                                                            prefixIcon: tags
                                                                    .isNotEmpty
                                                                ? SingleChildScrollView(
                                                                    controller:
                                                                        sc,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                        children:
                                                                            tags.map((String
                                                                                tag) {
                                                                      return Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              customRedColor,
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.0),
                                                                        ),
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        margin: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Text(
                                                                              tag,
                                                                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                                                            ),
                                                                            const SizedBox(width: 4.0),
                                                                            InkWell(
                                                                              child: const Icon(
                                                                                Icons.cancel,
                                                                                size: 14.0,
                                                                                color: Colors.white,
                                                                              ),
                                                                              onTap: () {
                                                                                onTagDelete(tag);
                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList()),
                                                                  )
                                                                : null,
                                                          ),
                                                          onChanged: onChanged,
                                                          onSubmitted:
                                                              onSubmitted,
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  textSeparators: const [
                                                    ' ',
                                                    ','
                                                  ],
                                                  letterCase: LetterCase.small,
                                                  validator: (String tag) {
                                                    final tags = _tagsController
                                                            .getTags ??
                                                        [];
                                                    if (tags.contains(tag)) {
                                                      return 'you already entered that';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            customRedColor,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        )),
                                                    onPressed: () async {
                                                      if ((_tagsController
                                                                  .getTags ??
                                                              [])
                                                          .isNotEmpty) {
                                                        BotToast.showLoading(
                                                            allowClick: false,
                                                            clickClose: false,
                                                            backButtonBehavior:
                                                                BackButtonBehavior
                                                                    .ignore);
                                                        await _organizationManager
                                                            .inviteMember(
                                                                emails: _tagsController
                                                                        .getTags ??
                                                                    [])
                                                            .then((sent) {
                                                          BotToast
                                                              .closeAllLoading();
                                                          if (sent) {
                                                            uiUtilities
                                                                .actionAlertWidget(
                                                                    context:
                                                                        context,
                                                                    alertType:
                                                                        AlertType
                                                                            .success);
                                                            uiUtilities.alertNotification(
                                                                context:
                                                                    context,
                                                                message:
                                                                    _organizationManager
                                                                        .message!);

                                                            Future.delayed(
                                                                const Duration(
                                                                    seconds: 2),
                                                                () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          } else {
                                                            uiUtilities
                                                                .actionAlertWidget(
                                                                    context:
                                                                        context,
                                                                    alertType:
                                                                        AlertType
                                                                            .error);
                                                            uiUtilities.alertNotification(
                                                                context:
                                                                    context,
                                                                message:
                                                                    _organizationManager
                                                                        .message!);
                                                          }
                                                        }).catchError(
                                                                (onError) {
                                                          uiUtilities
                                                              .actionAlertWidget(
                                                                  context:
                                                                      context,
                                                                  alertType:
                                                                      AlertType
                                                                          .error);
                                                          uiUtilities
                                                              .alertNotification(
                                                                  context:
                                                                      context,
                                                                  message:
                                                                      'Failed to send email invitations');
                                                        });
                                                      } else {
                                                        uiUtilities
                                                            .actionAlertWidget(
                                                                context:
                                                                    context,
                                                                alertType: AlertType
                                                                        .info);
                                                        uiUtilities
                                                            .alertNotification(
                                                                context:
                                                                    context,
                                                                message:
                                                                    'Fields cannot be empty');
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15,
                                                              right: 15),
                                                      child: Text(
                                                        'Invite email(s)',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
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
                                      .labelLarge!
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
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.normal, color: customGreyColor),
              ),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                content: Text(
                                  userData?.fcmToken == null
                                      ? 'Are you sure you want to receive Notifications?'
                                      : 'Are you sure you don\'t want to receive Notifications?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.red),
                                      )),
                                  TextButton(
                                      onPressed: () async {
                                        BotToast.showLoading(
                                            allowClick: false,
                                            clickClose: false,
                                            backButtonBehavior:
                                                BackButtonBehavior.ignore);
                                        final hasToken =
                                            userData?.fcmToken != null;
                                        if (hasToken) {
                                          await _userManager
                                              .sendNotificationToken(
                                                  token: null)
                                              .then((_) async {
                                            await getUserInfo();

                                            await _fcm
                                                .deleteToken()
                                                .then((value) {
                                              BotToast.closeAllLoading();
                                              Navigator.pop(context);
                                            }).catchError((_) {
                                              BotToast.closeAllLoading();
                                            });
                                          });
                                        } else {
                                          await _fcm.requestPermission();
                                          final token = await _fcm.getToken();
                                          await _userManager
                                              .sendNotificationToken(
                                                  token: token)
                                              .then((_) async {
                                            await getUserInfo();
                                            BotToast.closeAllLoading();
                                            // ignore: use_build_context_synchronously
                                            Navigator.pop(context);
                                          }).catchError((_) {
                                            BotToast.closeAllLoading();
                                          });
                                        }
                                      },
                                      child: Text('Yes',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(color: Colors.red)))
                                ],
                              );
                            });
                      },
                      title: Text(
                        'Do not disturb',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        userData?.fcmToken == null ? 'On' : 'Off',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: customGreyColor),
                      ),
                      leading: Icon(Icons.notifications_paused_outlined,
                          color: Theme.of(context).iconTheme.color, size: 30),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () {
                        OpenAppsSettings.openAppsSettings(
                            settingsCode: SettingsCode.NOTIFICATION);
                      },
                      title: Text(
                        'Push Notifications',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        'Manage',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: customGreyColor),
                      ),
                      leading: Icon(
                        Entypo.notification,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'Support',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.normal, color: customGreyColor),
              ),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        Platform.isIOS ? 'iOS guide' : 'Android guide',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(Icons.info_outline_rounded,
                          color: Theme.of(context).iconTheme.color, size: 30),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () =>
                          Navigator.of(context).pushNamed('/supportView'),
                      title: Text(
                        'Contact support',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                'More',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.normal, color: customGreyColor),
              ),
              Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        if (await _inAppReview.isAvailable()) {
                          await _inAppReview.requestReview();
                        } else {
                          Platform.isIOS
                              ? _launchURL(url: '')
                              : _launchURL(url: '');
                        }
                      },
                      title: Text(
                        'Rate the app',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(Icons.star_border_rounded,
                          color: Theme.of(context).iconTheme.color, size: 30),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => _launchURL(
                          url:
                              'https://www.privacypolicygenerator.info/live.php?token=RRoYC8f5TiNZtKNOStV9f3o8b25vOqp7'),
                      title: Text(
                        'Privacy policy',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(
                        Icons.visibility_outlined,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () => _launchURL(
                          url:
                              'https://www.privacypolicygenerator.info/live.php?token=RRoYC8f5TiNZtKNOStV9f3o8b25vOqp7'),
                      title: Text(
                        'Terms of service',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(
                        Feather.settings,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () async {
                        final PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();

                        String version = packageInfo.version;
                        String buildNumber = packageInfo.buildNumber;
                        if (!context.mounted) return;
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                title: Text(
                                  'App version',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                content: Text(
                                  'Current app version is $version+$buildNumber',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'OK',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(color: Colors.red),
                                      )),
                                ],
                              );
                            });
                      },
                      title: Text(
                        'Version',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      leading: Icon(
                        Platform.isIOS
                            ? Ionicons.ios_phone_portrait
                            : Ionicons.md_phone_portrait,
                        color: Theme.of(context).iconTheme.color,
                        size: 30,
                      ),
                      trailing: Icon(
                        Platform.isIOS
                            ? Icons.arrow_forward_ios_sharp
                            : Icons.arrow_forward,
                        color: Theme.of(context).iconTheme.color,
                      ),
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
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog.adaptive(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: Text(
                              'Information',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            content: Text(
                              'Are you sure you want to log out?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontSize: 18),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.red),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    BotToast.showLoading(
                                        allowClick: false,
                                        clickClose: false,
                                        backButtonBehavior:
                                            BackButtonBehavior.ignore);
                                    final fb.FirebaseAuth firebaseAuth =
                                        fb.FirebaseAuth.instance;
                                    firebaseAuth.signOut().then((_) async {
                                      await _localStorage.clearStorage();
                                      BotToast.closeAllLoading();
                                      if (!context.mounted) return;

                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/loginView', (route) => false);
                                    });
                                  },
                                  child: Text('Logout',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge))
                            ],
                          );
                        });
                  },
                  child: Text(
                    'Log out',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(color: customRedColor),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL({required String url}) async =>
      await canLaunchUrl(Uri.parse(url))
          ? await launchUrl(Uri.parse(url))
          : throw 'Could not launch $url';
}
