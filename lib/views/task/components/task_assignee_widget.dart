import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tasky_mobile_app/managers/task_manager.dart';
import 'package:tasky_mobile_app/models/member.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/views/task/components/assignee_tile_widget.dart';

class TaskAssigneeWidget extends StatefulWidget {
  final Member? data;
  final TaskManager taskManager;
  const TaskAssigneeWidget({
    super.key,
    required this.data,
    required this.taskManager,
  });

  @override
  State<TaskAssigneeWidget> createState() => _TaskAssigneeWidgetState();
}

class _TaskAssigneeWidgetState extends State<TaskAssigneeWidget> {
  List<Data> users = [];
  bool isChecked = false;
  final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 14,
          ),
          Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(45)),
          ),
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(24),
            controller: ModalScrollController.of(context),
            children: List.generate(widget.data!.data!.length, (index) {
              return AssigneeTileWidget(
                isChecked: (widget.taskManager.assignees
                        .singleWhereOrNull((it) => it.id == widget.data!.data![index].id)) !=
                    null,
                selectedUser: widget.data!.data![index],
                onTap: (Data user) {
                  setState(() {
                    if ((users.singleWhereOrNull((it) => it.id == user.id)) != null) {
                      users.remove(user);
                    } else {
                      users.add(user);
                    }
                  });
                  widget.taskManager.setAssignees(users);
                  _logger.d(widget.taskManager.assignees);
                },
              );
            }),
          ),
          const SizedBox(
            height: 25,
          ),
          TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.black),
            onPressed: () {
              setState(() {
                widget.taskManager.setAssignees(users);
              });
              if (widget.taskManager.assignees.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Done',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
