import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:readmore/readmore.dart';
import 'package:tasky_mobile_app/managers/inbox_manager.dart';
import 'package:tasky_mobile_app/models/comment.dart' as comment;
import 'package:tasky_mobile_app/models/inbox.dart';
import 'package:tasky_mobile_app/shared_widgets/empty_widget.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/extentions.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';
import 'package:time_ago_provider/time_ago_provider.dart' as time_ago;

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final InboxManager _inboxManager = GetIt.I.get<InboxManager>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final List<String> options = [
    'All',
    'Assigned to me',
    '@Mentioned',
    'Assigned to team'
  ];
  int currentIndex = 0;
  AsyncSnapshot<Inbox?>? _snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inbox',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize:
              Size(MediaQuery.of(context).size.width, kToolbarHeight),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                        options.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    currentIndex = index;
                                  });
                                },
                                child: Material(
                                  color: currentIndex == index
                                      ? customRedColor.withOpacity(.2)
                                      : customGreyColor.withOpacity(.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      options[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              color: currentIndex == index
                                                  ? customRedColor
                                                  : customGreyColor),
                                    )),
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              ),
              Visibility(
                visible: _snapshot?.connectionState == ConnectionState.waiting,
                child: const LinearProgressIndicator(
                  minHeight: 2,
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<Inbox?>(
          stream:
              _inboxManager.getInboxes(query: options[currentIndex]).asStream(),
          builder: (context, snapshot) {
            _snapshot = snapshot;
            if (snapshot.connectionState == ConnectionState.waiting &&
                snapshot.data == null) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == null) {
              return const EmptyWidget(
                message: 'You don\'t have any message yet.',
                imageAsset: 'no_inbox.png',
              );
            }

            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data!.data!.isEmpty) {
              return const EmptyWidget(
                message: 'You don\'t have any message yet.',
                imageAsset: 'no_inbox.png',
              );
            }

            return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(24),
                itemBuilder: (context, index) => InboxItemWidget(
                      onTap: () {
                        showBarModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            builder: (context) {
                              return MessageDisplayWidget(
                                  firebaseAuth: _firebaseAuth,
                                  snapshot: snapshot.data!.data![index],
                                  inboxManager: _inboxManager);
                            });
                      },
                      avatar: snapshot.data!.data![index].user!.picture,
                      description: snapshot.data!.data![index].message,
                      isLiked: snapshot.data!.data![index].like == null
                          ? false
                          : snapshot.data!.data![index].like
                              .contains(_firebaseAuth.currentUser!.uid),
                      teamName: snapshot.data!.data![index].team,
                      title: snapshot.data!.data![index].title,
                      timestamp: time_ago
                          .format(snapshot.data!.data![index].updatedAt!),
                      dueDate: snapshot.data!.data![index].status!,
                      replies: snapshot.data!.data![index].like == null
                          ? 0
                          : snapshot.data!.data![index].like!.length,
                    ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.data!.length);
          }),
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_message',
        backgroundColor: customRedColor,
        child: const Icon(
          MaterialCommunityIcons.chat_outline,
          color: Colors.white,
        ),
        onPressed: () async {
          final res = await Navigator.of(context).pushNamed('/createInboxView');
          if (res != null) {
            setState(() {});
          }
        },
      ),
    );
  }
}

class MessageDisplayWidget extends StatefulWidget {
  const MessageDisplayWidget({
    super.key,
    required FirebaseAuth firebaseAuth,
    required this.snapshot,
    required this.inboxManager,
  })  : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;
  final Datum snapshot;
  final InboxManager inboxManager;

  @override
  State<MessageDisplayWidget> createState() => _MessageDisplayWidgetState();
}

class _MessageDisplayWidgetState extends State<MessageDisplayWidget> {
  final TextEditingController _commentController = TextEditingController();

  final UiUtilities uiUtilities = UiUtilities();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors
                        .primaries[Random().nextInt(Colors.primaries.length)],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    widget.snapshot.team!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              Text(
                widget.snapshot.status!,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: widget.snapshot.status! == 'Completed'
                        ? Colors.green
                        : customGreyColor),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                        side: BorderSide(
                            color: widget.snapshot.status! == 'Completed'
                                ? Colors.transparent
                                : customGreyColor)),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: widget.snapshot.status! == 'Completed'
                          ? Colors.green
                          : Colors.transparent,
                      child: Icon(
                        Icons.check,
                        color: widget.snapshot.status! == 'Completed'
                            ? Colors.white
                            : customGreyColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.snapshot.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              widget.snapshot.like == null
                  ? const SizedBox.shrink()
                  : Material(
                      color: customRedColor,
                      borderRadius: BorderRadius.circular(35),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                        child: Row(
                          children: [
                            Text(
                              '${widget.snapshot.like == null ? 0 : widget.snapshot.like!.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Icon(
                              Ionicons.ios_chatbubbles,
                              color: Colors.white,
                              size: 15,
                            )
                          ],
                        ),
                      ),
                    )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.2),
                radius: 30,
                backgroundImage: (widget.snapshot.user!.picture!.isEmpty
                        ? const ExactAssetImage('assets/avatar.png')
                        : NetworkImage(widget.snapshot.user!.picture!))
                    as ImageProvider,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    child: ReadMoreText(
                      widget.snapshot.message!,
                      trimLines: 5,
                      colorClickableText: customRedColor,
                      lessStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: customRedColor),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.normal),
                      moreStyle: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(
                              fontWeight: FontWeight.w600,
                              color: customRedColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${time_ago.format(widget.snapshot.createdAt!)} - ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: customGreyColor),
                      ),
                      Icon(
                        (widget.snapshot.like == null
                                ? false
                                : widget.snapshot.like.contains(
                                    widget._firebaseAuth.currentUser!.uid))
                            ? Icons.thumb_up
                            : Feather.thumbs_up,
                        color: (widget.snapshot.like == null
                                ? false
                                : widget.snapshot.like.contains(
                                    widget._firebaseAuth.currentUser!.uid))
                            ? customRedColor
                            : customGreyColor,
                        size: 20,
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            '---------- Comments ----------',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, color: customGreyColor),
          ),
          const SizedBox(
            height: 25,
          ),
          StreamBuilder<comment.Comment?>(
              stream: widget.inboxManager
                  .getInboxComments(inboxId: widget.snapshot.id!)
                  .asStream(),
              builder: (context, commentSnapshot) {
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (commentSnapshot.connectionState ==
                              ConnectionState.waiting &&
                          commentSnapshot.data == null) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }

                      if (commentSnapshot.connectionState ==
                              ConnectionState.done &&
                          commentSnapshot.data == null) {
                        return const SizedBox.shrink();
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)]
                                .withOpacity(.2),
                            radius: 30,
                            backgroundImage: (widget
                                        .snapshot.user!.picture!.isEmpty
                                    ? const ExactAssetImage('assets/avatar.png')
                                    : NetworkImage(
                                        widget.snapshot.user!.picture!))
                                as ImageProvider,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 120,
                                child: ReadMoreText(
                                  widget.snapshot.message!,
                                  trimLines: 5,
                                  colorClickableText: customRedColor,
                                  lessStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: customRedColor),
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontWeight: FontWeight.normal),
                                  moreStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: customRedColor),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${time_ago.format(widget.snapshot.createdAt!)} - ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: customGreyColor),
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: commentSnapshot.data == null
                        ? 0
                        : commentSnapshot.data!.data!.length);
              })
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextFormField(
            controller: _commentController,
            style: Theme.of(context).textTheme.bodyLarge,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.words,
            maxLines: 1,
            cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
            enableInteractiveSelection: true,
            decoration: InputDecoration(
                suffixIcon: InkWell(
                    onTap: () async {
                      BotToast.showLoading(
                          allowClick: false,
                          clickClose: false,
                          backButtonBehavior: BackButtonBehavior.ignore);

                      bool isSent = await widget.inboxManager
                          .submitInboxComment(
                              comment: _commentController.text,
                              inboxId: widget.snapshot.id!);
                      BotToast.closeAllLoading();
                      if (!context.mounted) return;

                      if (isSent) {
                        _commentController.clear();
                        uiUtilities.actionAlertWidget(
                            context: context, alertType: AlertType.success);
                        uiUtilities.alertNotification(
                            context: context,
                            message: widget.inboxManager.message!);
                      } else {
                        uiUtilities.actionAlertWidget(
                            context: context, alertType: AlertType.error);
                        uiUtilities.alertNotification(
                            context: context,
                            message: widget.inboxManager.message!);
                        debugPrint('$e');
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: customGreyColor,
                    )),
                label: Text(
                  'Comment',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: customGreyColor.withOpacity(.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: customGreyColor.withOpacity(.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.grey)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Field cannot be Empty';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class InboxItemWidget extends StatelessWidget {
  final String? teamName;
  final String? title;
  final String? description;
  final String dueDate;
  final String timestamp;
  final bool isLiked;
  final String? avatar;
  final int replies;
  final VoidCallback onTap;

  const InboxItemWidget({
    super.key,
    required this.teamName,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.timestamp,
    required this.isLiked,
    required this.avatar,
    this.replies = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      teamName!.toCapitalize(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Text(
                  dueDate,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: dueDate == 'Completed'
                          ? Colors.green
                          : customGreyColor),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                          side: BorderSide(
                              color: dueDate == 'Completed'
                                  ? Colors.transparent
                                  : customGreyColor)),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: dueDate == 'Completed'
                            ? Colors.green
                            : Colors.transparent,
                        child: Icon(
                          Icons.check,
                          color: dueDate == 'Completed'
                              ? Colors.white
                              : customGreyColor,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                replies == 0
                    ? const SizedBox.shrink()
                    : Material(
                        color: customRedColor,
                        borderRadius: BorderRadius.circular(35),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                          child: Row(
                            children: [
                              Text(
                                '$replies',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Ionicons.ios_chatbubbles,
                                color: Colors.white,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .withOpacity(.2),
                  radius: 30,
                  backgroundImage: (avatar!.isEmpty
                      ? const ExactAssetImage('assets/avatar.png')
                      : NetworkImage(avatar!)) as ImageProvider,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '$timestamp - ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: customGreyColor),
                        ),
                        Icon(
                          isLiked ? Icons.thumb_up : Feather.thumbs_up,
                          color: isLiked ? customRedColor : customGreyColor,
                          size: 20,
                        )
                      ],
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
