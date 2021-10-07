import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tasky_mobile_app/managers/task_manager.dart';
import 'package:tasky_mobile_app/models/task.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_appbar_widget.dart';
import 'package:tasky_mobile_app/shared_widgets/custom_checkbox_widget.dart';
import 'package:tasky_mobile_app/shared_widgets/empty_widget.dart';
import 'package:tasky_mobile_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_mobile_app/utils/ui_utils/ui_utils.dart';


class TaskView extends StatefulWidget {
  const TaskView({Key key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final UiUtilities uiUtilities = UiUtilities();
  final ScrollController _scrollController = ScrollController();
final TaskManager _taskManager = GetIt.I.get<TaskManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Tasks',
      ),
      body: StreamBuilder<Task>(
          stream: _taskManager.getTasks().asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }

            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasData) {
              return const EmptyWidget(
                imageAsset: 'no_task.png',
                message:
                    'Tasks aasigned to you and tasks created for you appears here.',
              );
            }

            if (snapshot.data == null) {
              return const EmptyWidget(
                imageAsset: 'no_task.png',
                message:
                    'Tasks aasigned to you and tasks created for you appears here.',
              );
            }

            return ListView(
              controller: _scrollController,
              children: [
                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rate_rounded,
                        color: Color.fromRGBO(245, 101, 101, 1),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Starred',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Text(
                      'Tasks',
                      style: Theme.of(context).textTheme.bodyText1,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView.separated(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          dueDate: snapshot.data.data[index].dueDate,
                          images: snapshot.data.data[index].participants,
                          taskTitle: snapshot.data.data[index].description,
                          isCompleted:
                              snapshot.data.data[index].status == 'completed',
                          onTap: (bool value) async {
                            BotToast.showLoading(
                                allowClick: false,
                                clickClose: false,
                                backButtonBehavior: BackButtonBehavior.ignore);
                            bool isChanged =
                                await _taskManager.markTaskAsCompleted(
                                    status: 'completed',
                                    taskId: snapshot.data.data[index].id);
                            BotToast.closeAllLoading();
                            if (isChanged) {
                              uiUtilities.actionAlertWidget(
                                  context: context, alertType: 'success');
                              uiUtilities.alertNotification(
                                  context: context,
                                  message: 'Marked as completed!');
                              setState(() {
                                snapshot.data.data[index].status =
                                    value ? 'complete' : 'todo';
                              });
                            } else {
                              uiUtilities.actionAlertWidget(
                                  context: context, alertType: 'error');
                              uiUtilities.alertNotification(
                                  context: context,
                                  message: _taskManager.message);
                            }
                          },
                          changeStatus: () async {
                            showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    content: SizedBox(
                                      height: 170,
                                      child: Column(
                                        children: [
                                          RadioListTile(
                                              title: Text(
                                                'To do',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              value: 'todo',
                                              groupValue: 'status',
                                              onChanged: (value) async {
                                                BotToast.showLoading(
                                                    allowClick: false,
                                                    clickClose: false,
                                                    backButtonBehavior:
                                                        BackButtonBehavior
                                                            .ignore);
                                                bool isChanged =
                                                    await _taskManager
                                                        .markTaskAsCompleted(
                                                            status: value,
                                                            taskId: snapshot
                                                                .data
                                                                .data[index]
                                                                .id);
                                                BotToast.closeAllLoading();
                                                await _taskManager.getTasks();
                                                if (isChanged) {
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'success');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          'Marked as a To-do!');
                                                  Navigator.of(dialogContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                } else {
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'error');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          _taskManager.message);
                                                }
                                              }),
                                          RadioListTile(
                                              title: Text(
                                                'In Progress',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              value: 'in progress',
                                              groupValue: 'status',
                                              onChanged: (value) async {
                                                BotToast.showLoading(
                                                    allowClick: false,
                                                    clickClose: false,
                                                    backButtonBehavior:
                                                        BackButtonBehavior
                                                            .ignore);
                                                bool isChanged =
                                                    await _taskManager
                                                        .markTaskAsCompleted(
                                                            status: value,
                                                            taskId: snapshot
                                                                .data
                                                                .data[index]
                                                                .id);
                                                BotToast.closeAllLoading();
                                                await _taskManager.getTasks();
                                                if (isChanged) {
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'success');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          'Marked as In Progress!');
                                                  Navigator.of(dialogContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                } else {
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'error');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          _taskManager.message);
                                                }
                                              }),
                                          RadioListTile(
                                              title: Text(
                                                'Complete',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                              value: 'completed',
                                              groupValue: 'status',
                                              onChanged: (value) async {
                                                BotToast.showLoading(
                                                    allowClick: false,
                                                    clickClose: false,
                                                    backButtonBehavior:
                                                        BackButtonBehavior
                                                            .ignore);
                                                bool isChanged =
                                                    await _taskManager
                                                        .markTaskAsCompleted(
                                                            status: value,
                                                            taskId: snapshot
                                                                .data
                                                                .data[index]
                                                                .id);
                                                BotToast.closeAllLoading();
                                                if (isChanged) {
                                                  await _taskManager.getTasks();
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'success');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          'Marked as completed!');
                                                  Navigator.of(dialogContext,
                                                          rootNavigator: true)
                                                      .pop();
                                                } else {
                                                  uiUtilities.actionAlertWidget(
                                                      context: context,
                                                      alertType: 'error');
                                                  uiUtilities.alertNotification(
                                                      context: context,
                                                      message:
                                                          _taskManager.message);
                                                }
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          onOpened: () {
                            showBarModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return ListView(
                                    padding: const EdgeInsets.all(16),
                                    children: [
                                      Text(
                                        'Task:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        snapshot.data.data[index].description,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Assignees:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      SizedBox(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) =>
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child:
                                                        ExtendedImage.network(
                                                      snapshot
                                                          .data
                                                          .data[index]
                                                          .assignees[index]
                                                          .picture,
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                      cache: true,
                                                      loadStateChanged:
                                                          (ExtendedImageState
                                                              state) {
                                                        if (state
                                                                .extendedImageLoadState ==
                                                            LoadState.failed) {
                                                          return Image.asset(
                                                            'assets/avatar.png',
                                                            fit: BoxFit.cover,
                                                            width: 60,
                                                            height: 60,
                                                          );
                                                        } else {
                                                          return ExtendedRawImage(
                                                            image: state
                                                                .extendedImageInfo
                                                                ?.image,
                                                            fit: BoxFit.cover,
                                                            width: 60,
                                                            height: 60,
                                                          );
                                                        }
                                                      },
                                                    )),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      width: 4,
                                                    ),
                                            itemCount: snapshot.data.data[index]
                                                .assignees.length),
                                      )
                                    ],
                                  );
                                });
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              endIndent: 10,
                              indent: 40,
                            ),
                          ),
                      itemCount: snapshot.data.data.length),
                ),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customRedColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () =>
            Navigator.pushReplacementNamed(context, '/createNewTaskView'),
      ),
    );
  }
}

// this widget represent each individual task list tile
class TaskListTile extends StatelessWidget {
  const TaskListTile({
    Key key,
    @required this.images,
    @required this.isCompleted,
    @required this.taskTitle,
    @required this.onTap,
    @required this.changeStatus,
    @required this.dueDate,
    @required this.onOpened,
  }) : super(key: key);

  final List<String> images;
  final bool isCompleted;
  final String taskTitle;
  final Function onTap;
  final Function changeStatus;
  final String dueDate;
  final Function onOpened;

  @override
  Widget build(BuildContext context) {
    final List dates = dueDate.split(' ');
    String dateFormat =
        DateFormat().add_yMMMEd().format(DateTime.tryParse(dates[0]));

    return GestureDetector(
      onTap: () => onOpened(),
      child: SizedBox(
        height: 80,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: CustomCheckBox(
                    isChecked: isCompleted,
                    onTap: (value) {
                      onTap(value);
                    },
                    uncheckedColor: customGreyColor,
                    checkedColor: Colors.green,
                    size: 27,
                    checkedWidget: const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    taskTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterImageStack(
                  imageList: images,
                  extraCountTextStyle: Theme.of(context).textTheme.subtitle2,
                  itemBorderColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  itemRadius: 25,
                  itemCount: images.length,
                  itemBorderWidth: 1,
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]
                      .withOpacity(.5),
                  totalCount: images.length,
                ),
                Row(
                  children: [
                    Text(
                      '$dateFormat ${dates[1]}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: customRedColor),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            context: context,
                            elevation: 3,
                            builder: (context) {
                              return Container(
                                height: 260,
                                decoration: const BoxDecoration(
                                    color: customRedColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white70,
                                            borderRadius:
                                                BorderRadius.circular(45)),
                                        height: 6,
                                        width: 40,
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        changeStatus();
                                      },
                                      title: Text(
                                        'Change status',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Edit Task',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: .5,
                                    ),
                                    ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        'Delete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: const Icon(
                        Icons.more_vert,
                        color: customGreyColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
