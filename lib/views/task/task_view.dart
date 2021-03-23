import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:tasky_app/shared_widgets/custom_appbar_widget.dart';
import 'package:tasky_app/shared_widgets/custom_checkbox_widget.dart';
import 'package:tasky_app/utils/ui_utils/custom_colors.dart';

class TaskView extends StatefulWidget {
  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final List<Map<String, dynamic>> data = [
    {
      'title': 'Provide design team content for next web seminar',
      'isCompleted': true,
      'date': DateTime.now().subtract(Duration(days: 10)),
      'participants': [
        "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
        "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
        "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
      ]
    },
    {
      'title':
          'Create a beautiful physical christmas card for upcoming christmas',
      'isCompleted': false,
      'date': DateTime.now().subtract(Duration(days: 5)),
      'participants': [
        "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
        "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
        "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
        "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Tasks',
      ),
      body: ListView(
        children: [
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  color: Color.fromRGBO(245, 101, 101, 1),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Starred',
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
          ),
          Divider(),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Text(
                'Tasks',
                style: Theme.of(context).textTheme.bodyText1,
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return TaskListTile(
                    images: data[index]['participants'],
                    taskTitle: data[index]['title'],
                    isCompleted: data[index]['isCompleted'],
                    onTap: (value) {
                      setState(() {
                        data[index]['isCompleted'] = value;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Divider(
                        endIndent: 10,
                        indent: 40,
                      ),
                    ),
                itemCount: data.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: customRedColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, '/createNewTaskView'),
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
  }) : super(key: key);

  final List<String> images;
  final bool isCompleted;
  final String taskTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                checkedWidget: Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                '$taskTitle',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: FlutterImageStack(
                imageList: images,
                extraCountTextStyle: Theme.of(context).textTheme.subtitle2,
                imageBorderColor: Theme.of(context).scaffoldBackgroundColor,
                imageRadius: 25,
                imageCount: images
                    .length,
                imageBorderWidth: 1,
                backgroundColor: Colors
                    .primaries[Random().nextInt(Colors.primaries.length)]
                    .withOpacity(.5),
                totalCount: images.length,
              ),
            ),
            Row(
              children: [
                Text(
                  'Due next week',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: customRedColor),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.more_vert,
                  color: customGreyColor,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
