import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:tasky_app/models/user.dart';
import 'package:tasky_app/services/task_service.dart';
import 'package:tasky_app/utils/local_storage.dart';

class TaskManager with ChangeNotifier {
  final TaskService _taskService = GetIt.I.get<TaskService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

  List<Data> _assignees = [];
  List<String> _imagesList = [];
  String _message = '';
  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;
  List<Data> get assignees => _assignees;
  List<String> get imagesList => _imagesList;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setAssignees(List<Data> users) {
    _assignees = users;
    List<String> ee = [];
    users.forEach((element) {
      ee.add(element.picture);
    });
    _imagesList = ee;

    notifyListeners();
  }

  Future<bool> createTask(
      {String description,
      String department,
      String dueDate,
      bool shouldSetReminder,
      List<int> assignees}) async {
    setisLoading(true);
    bool isSaved = false;
    int userId = await _localStorage.getId();
    int organizationId = await _localStorage.getOrganizationId();
    await _taskService
        .createTaskRequest(
            department: department,
            dueDate: dueDate,
            createdBy: userId,
            assignees: assignees,
            description: description,
            isReminder: shouldSetReminder,
            organizationId: organizationId)
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage(body['message']);
      setisLoading(false);
      if (statusCode == 201) {
        isSaved = true;
      } else {
        isSaved = false;
      }
    }).catchError((onError) {
      isSaved = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      isSaved = false;
    });
    return isSaved;
  }
}
