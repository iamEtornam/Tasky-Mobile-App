import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tasky_mobile_app/models/task.dart';
import 'package:tasky_mobile_app/models/task_statistic.dart';
import 'package:tasky_mobile_app/models/user.dart';
import 'package:tasky_mobile_app/services/task_service.dart';
import 'package:tasky_mobile_app/utils/local_storage.dart';

class TaskManager with ChangeNotifier {
  final Logger _logger = Logger();
  final TaskService _taskService = GetIt.I.get<TaskService>();
  final LocalStorage _localStorage = GetIt.I.get<LocalStorage>();

  List<Data> _assignees = [];
  String? _message = '';
  bool _isLoading = false;

  String? get message => _message;
  bool get isLoading => _isLoading;
  List<Data> get assignees => _assignees;

  setMessage(String? message) {
    _message = message;
    notifyListeners();
  }

  setisLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setAssignees(List<Data> users) {
    _assignees = users;
    notifyListeners();
  }

  Future<bool> createTask(
      {required String description,
      required String? team,
      required String dueDate,
      required bool shouldSetReminder,
      required List<int?> assignees}) async {
    setisLoading(true);
    bool isSaved = false;
    int? userId = await _localStorage.getId();
    int? organizationId = await _localStorage.getOrganizationId();
    await _taskService
        .createTaskRequest(
            team: team,
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
      _logger.d(body['message']);
      if (statusCode == 201) {
        isSaved = true;
      } else {
        isSaved = false;
      }
    }).catchError((onError) {
      isSaved = false;
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      isSaved = false;
    });
    return isSaved;
  }

  Future<Task?> getTasks() async {
    Task? tasks;
    int? organizationId = await _localStorage.getOrganizationId();
    if (organizationId == null) {
      return null;
    }
    await _taskService.getTaskRequest(organizationId).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setisLoading(false);
      if (statusCode == 200) {
        tasks = Task.fromMap(body);
      } else {
        setMessage(body['message']);

        tasks = null;
      }
    }).catchError((onError) {
      _logger.d('$onError');
      setMessage('$onError');
      setisLoading(false);
      tasks = null;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      tasks = null;
    });
    return tasks;
  }

  Future<TaskStatistic?> getTaskStatistics() async {
    TaskStatistic? taskStatistic;
    int? userId = await _localStorage.getId();
    await _taskService.getTaskStatisticsRequest(userId!).then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      _logger.d(body['message']);
      setisLoading(false);
      _logger.d(body['message']);
      if (statusCode == 200) {
        taskStatistic = TaskStatistic.fromMap(body);
      } else {
        setMessage(body['message']);

        taskStatistic = null;
      }
    }).catchError((onError) {
      taskStatistic = null;
      _logger.d('$onError');
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      taskStatistic = null;
    });
    return taskStatistic;
  }

  Future<bool> markTaskAsCompleted(
      {required int taskId, required String status}) async {
    bool isDone = false;
    await _taskService
        .markAsCompletedRequest(status: status, taskId: taskId)
        .then((response) {
      int statusCode = response.statusCode;
      Map<String, dynamic> body = json.decode(response.body);
      setMessage('${body['mesage']}');
      if (statusCode == 200) {
        isDone = true;
      } else {
        isDone = false;
      }
    }).catchError((onError) {
      isDone = false;
      _logger.d('$onError');
      setMessage('$onError');
      setisLoading(false);
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage('Timeout! Check your internet connection.');
      setisLoading(false);
      isDone = false;
    });
    return isDone;
  }
}
