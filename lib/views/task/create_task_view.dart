import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';

class CreateNewTaskView extends StatefulWidget {
  @override
  _CreateNewTaskViewState createState() => _CreateNewTaskViewState();
}

class _CreateNewTaskViewState extends State<CreateNewTaskView> {
  FocusNode taskFocusNode = FocusNode();
  bool isSwitched = false;
  DateTime _dueDate;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customRedColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'New Task',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Form(
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
                controller: TextEditingController(
                    text: _dueDate == null
                        ? ''
                        : DateFormat('dd MMM yyyy, hh:mm a').format(_dueDate)),
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
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () async {},
                child: DottedBorder(
                  borderType: BorderType.Circle,
                  radius: Radius.circular(6),
                  color: customGreyColor,
                  dashPattern: [6, 3, 6, 3],
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
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
            ),
            SizedBox(height: 45),
            TextButton(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.black),
              onPressed: () {},
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
                      _dueDate = picked;
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
            _dueDate = DateTime(picked.year, picked.month, picked.day,
                timeOfDay.hour, timeOfDay.minute);
          });
      }
    }
  }
}
