import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tasky_app/managers/organization_manager.dart';
import 'package:tasky_app/managers/task_manager.dart';
import 'package:tasky_app/models/member.dart';
import 'package:tasky_app/models/user.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';
import 'package:tasky_app/utils/ui_utils/ui_utils.dart';

final OrganizationManager _organizationManager =
    GetIt.I.get<OrganizationManager>();
final TaskManager _taskManager = GetIt.I.get<TaskManager>();

class CreateNewTaskView extends StatefulWidget {
  @override
  _CreateNewTaskViewState createState() => _CreateNewTaskViewState();
}

class _CreateNewTaskViewState extends State<CreateNewTaskView> {
  final UiUtilities uiUtilities = UiUtilities();
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode taskFocusNode = FocusNode();
  bool isSwitched = false;
  final TextEditingController descriptionTextEditingController =
      TextEditingController();
  final TextEditingController departmentTextEditingController =
      TextEditingController();
  final TextEditingController dueDateTextEditingController =
      TextEditingController();
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  DateTime dueDate;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/', arguments: 1);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: customRedColor,
          iconTheme: IconThemeData(color: Colors.white),
          leading: BackButton(color: Colors.white,onPressed: () => Navigator.pushReplacementNamed(context, '/', arguments: 1),),
          title: Text(
            'New Task',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              Text(
                'What needs to be done ?',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: descriptionTextEditingController,
                focusNode: taskFocusNode,
                style: Theme.of(context).textTheme.bodyText1,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                enableInteractiveSelection: true,
                decoration: InputDecoration(
                    filled: false,
                    hintText: 'Start Typing ...',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: customGreyColor)),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.grey)),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Field cannot be Empty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'By when ?',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Due date & time',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.normal, color: customGreyColor),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  await pickDateTime(context);
                },
                child: TextFormField(
                  onTap: () async {
                    await pickDateTime(context);
                  },
                  controller: dueDateTextEditingController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.w600),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  maxLines: 1,
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  enableInteractiveSelection: true,
                  decoration: InputDecoration(
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: customGreyColor)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: customGreyColor)),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.grey),
                      suffixIcon: Icon(
                        Icons.arrow_forward,
                        color: customGreyColor,
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Field cannot be Empty';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set task reminder',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Switch.adaptive(
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                      });
                    },
                    value: isSwitched,
                    activeColor: customRedColor,
                    activeTrackColor: customRedColor.withOpacity(.5),
                    inactiveThumbColor: customGreyColor,
                    inactiveTrackColor: customGreyColor,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Text(
                'By whom ?',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'select Assignee',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    fontWeight: FontWeight.normal, color: customGreyColor),
              ),
              SizedBox(
                height: 15,
              ),
              _taskManager.assignees.isEmpty
                  ? FutureBuilder<Member>(
                      future: _organizationManager.getOrganizationMembers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            !snapshot.hasData) {
                          return CupertinoActivityIndicator();
                        }
                        if (snapshot.connectionState == ConnectionState.done &&
                            !snapshot.hasData) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              radius: Radius.circular(6),
                              color: customGreyColor,
                              dashPattern: [6, 3, 6, 3],
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  color: customGreyColor.withOpacity(.2),
                                  child: Center(
                                      child: Icon(
                                    MaterialIcons.person_add,
                                    color: customGreyColor,
                                  )),
                                ),
                              ),
                            ),
                          );
                        }

                        return Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () async {
                              if (Platform.isIOS) {
                                showCupertinoModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return TaskAssigneeWidget(
                                      data: snapshot.data,
                                    );
                                  },
                                );
                              } else {
                                showMaterialModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return TaskAssigneeWidget(
                                      data: snapshot.data,
                                    );
                                  },
                                );
                              }
                            },
                            child: DottedBorder(
                              borderType: BorderType.Circle,
                              radius: Radius.circular(6),
                              color: customGreyColor,
                              dashPattern: [6, 3, 6, 3],
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(45)),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  color: customGreyColor.withOpacity(.2),
                                  child: Center(
                                      child: Icon(
                                    MaterialIcons.person_add,
                                    color: customGreyColor,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Padding(
                      padding: const EdgeInsets.only(left: 100.0),
                      child: FlutterImageStack(
                        imageList: _taskManager.imagesList,
                        extraCountTextStyle:
                            Theme.of(context).textTheme.subtitle2,
                        imageBorderColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        imageRadius: 25,
                        imageCount: _taskManager.assignees.length,
                        imageBorderWidth: 1,
                        backgroundColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)]
                            .withOpacity(.5),
                        totalCount: _taskManager.assignees.length - 1,
                      ),
                    ),
              SizedBox(height: 45),
              TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.black),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    BotToast.showLoading(
                        allowClick: false,
                        clickClose: false,
                        backButtonBehavior: BackButtonBehavior.ignore);
                    List<int> userIds = [];
                    _taskManager.assignees.forEach((element) {
                      userIds.add(element.id);
                    });

                    bool isSaved = await _taskManager.createTask(
                        department: departmentTextEditingController.text,
                        description: descriptionTextEditingController.text,
                        dueDate: dueDateTextEditingController.text,
                        shouldSetReminder: isSwitched,
                        assignees: userIds);
                    BotToast.closeAllLoading();
                    if (isSaved) {
                      uiUtilities.actionAlertWidget(
                          context: context, alertType: 'success');
                      uiUtilities.alertNotification(
                          context: context, message: _taskManager.message);

                      Future.delayed(Duration(seconds: 3), () {
                        Navigator.pushReplacementNamed(context, '/taskView');
                      });
                    } else {
                      uiUtilities.actionAlertWidget(
                          context: context, alertType: 'error');
                      uiUtilities.alertNotification(
                          context: context, message: _taskManager.message);
                    }
                  } else {
                    uiUtilities.actionAlertWidget(
                        context: context, alertType: 'error');
                    uiUtilities.alertNotification(
                        context: context, message: 'Fields cannot be empty');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Create Task',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.white)),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  pickDateTime(BuildContext context) async {
    if (Platform.isIOS) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                onDateTimeChanged: (picked) {
                  if (picked != null)
                    setState(() {
                      dueDate = picked;
                      dueDateTextEditingController.text =
                          dateFormat.format(dueDate);
                    });
                },
                initialDateTime: DateTime.now(),
                minimumYear: DateTime.now().year,
                maximumYear: 2030,
              ),
            );
          });
    } else {
      DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        helpText: 'Select due date',
      );
      if (picked != null) {
        TimeOfDay timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          helpText: 'Select due time',
        );

        if (timeOfDay != null && picked != null)
          setState(() {
            dueDate = DateTime(picked.year, picked.month, picked.day,
                timeOfDay.hour, timeOfDay.minute);
            dueDateTextEditingController.text = dateFormat.format(dueDate);
          });
      }
    }
  }
}

class TaskAssigneeWidget extends StatefulWidget {
  final Member data;
  TaskAssigneeWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  @override
  _TaskAssigneeWidgetState createState() => _TaskAssigneeWidgetState();
}

class _TaskAssigneeWidgetState extends State<TaskAssigneeWidget> {
  bool isChecked = false;
  List<Data> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 14,
          ),
          Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(45)),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(24),
            controller: ModalScrollController.of(context),
            children: List.generate(widget.data.data.length, (index) {
              return Material(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage('${widget.data.data[index].picture}'),
                  ),
                  title: Text(
                    '${widget.data.data[index].name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        isChecked = !isChecked;
                        if (users.contains(widget.data.data[index])) {
                          users.remove(widget.data.data[index]);
                        } else {
                          users.add(widget.data.data[index]);
                        }
                      });
                    },
                    child: Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                          side: BorderSide(
                              color: isChecked
                                  ? Colors.transparent
                                  : customGreyColor)),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor:
                            isChecked ? Colors.green : Colors.transparent,
                        child: Icon(
                          Icons.check,
                          color: isChecked ? Colors.white : customGreyColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 25,
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.black),
            onPressed: () {
              _taskManager.setAssignees(users);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Done',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.white)),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
